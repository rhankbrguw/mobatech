import logging
import os
import uvicorn
from fastapi import FastAPI
from apscheduler.schedulers.background import BackgroundScheduler

from services.anonymizer import AnonymizationEngine
from services.rag_search import VectorSearchEngine
from services.sync_engine import SyncEngine
from services.llm_engine import GenerativeEngine
import constants as const
from schemas import ApiResponse, PromptRequest, RAGResponseData, ChatResponseData

app = FastAPI(title=const.API_TITLE)

anonymizer = AnonymizationEngine()
llm_engine = GenerativeEngine()

data_path = os.path.join(os.path.dirname(__file__), const.DATA_PATH_REL)
backend_env_path = os.path.join(os.path.dirname(__file__), const.BACKEND_ENV_PATH_REL)

vector_search = None
sync_engine = None


@app.on_event("startup")
async def startup_event():
    global vector_search, sync_engine
    try:
        vector_search = VectorSearchEngine(data_path)
        vector_search.build_index()
        sync_engine = SyncEngine(data_path, backend_env_path)
        logging.info("AI services initialized successfully.")
    except Exception as e:
        logging.error(f"Failed to initialize AI services: {e}")

scheduler = BackgroundScheduler()


@scheduler.scheduled_job(
    const.SCHEDULER_CRON_TRIGGER, minute=const.SCHEDULER_CRON_MINUTE
)
def automated_daily_sync() -> None:
    logging.info(const.MSG_RUNNING_SYNC)
    if sync_engine.sync_database():
        vector_search.build_index()


scheduler.start()


@app.post(const.API_SYNC_ENDPOINT, response_model=ApiResponse[str])
def sync_rag() -> ApiResponse[str]:
    if not sync_engine.sync_database():
        return ApiResponse(
            success=False, code=const.CODE_SYNC_DB_ERROR, message=const.MSG_DB_SYNC_FAILED
        )
    if not vector_search.build_index():
        return ApiResponse(
            success=False,
            code=const.CODE_SYNC_INDEX_ERROR,
            message=const.MSG_INDEX_REBUILD_FAILED,
        )
    return ApiResponse(success=True, code=const.CODE_SUCCESS, message=const.MSG_SYNC_SUCCESS)


@app.get(const.API_STATUS_ENDPOINT, response_model=ApiResponse[dict[str, int | str | bool]])
def get_rag_status() -> ApiResponse[dict[str, int | str | bool]]:
    return ApiResponse(
        success=True,
        code=const.CODE_SUCCESS,
        message=const.MSG_STATUS_SUCCESS,
        data={
            const.KEY_STATUS: const.RESPONSE_STATUS_ACTIVE,
            const.KEY_VECTOR_COUNT: vector_search.index.ntotal,
            const.KEY_KNOWLEDGE_BASE_SIZE: len(vector_search.knowledge_base),
        },
    )


@app.post(const.API_CONTEXT_ENDPOINT, response_model=ApiResponse[RAGResponseData])
def get_rag_context(req: PromptRequest) -> ApiResponse[RAGResponseData]:
    safe_query = anonymizer.anonymize(req.query)
    context_chunks = vector_search.search(safe_query, top_k=const.API_SEARCH_TOP_K)
    return ApiResponse(
        success=True,
        code=const.CODE_SUCCESS,
        message=const.MSG_CONTEXT_SUCCESS,
        data=RAGResponseData(anonymized_query=safe_query, context=context_chunks),
    )


@app.post(const.API_CHAT_ENDPOINT, response_model=ApiResponse[ChatResponseData])
def get_rag_chat(req: PromptRequest) -> ApiResponse[ChatResponseData]:
    safe_query = anonymizer.anonymize(req.query)
    context_chunks = vector_search.search(safe_query, top_k=const.API_SEARCH_TOP_K)

    answer = llm_engine.generate_response(safe_query, context_chunks)

    return ApiResponse(
        success=True,
        code=const.CODE_SUCCESS,
        message=const.MSG_CHAT_SUCCESS,
        data=ChatResponseData(
            query=req.query, answer=answer, context_used=len(context_chunks)
        ),
    )


if __name__ == "__main__":
    uvicorn.run(app, host=const.API_HOST, port=const.API_PORT)
