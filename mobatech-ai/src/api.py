import logging
import os
import uvicorn
from fastapi import FastAPI
from pydantic import BaseModel
from apscheduler.schedulers.background import BackgroundScheduler
from typing import Any

from services.anonymizer import AnonymizationEngine
from services.rag_search import VectorSearchEngine
from services.sync_engine import SyncEngine
from services.llm_engine import GenerativeEngine
import constants as const

app = FastAPI(title=const.API_TITLE)

anonymizer = AnonymizationEngine()
llm_engine = GenerativeEngine()

data_path = os.path.join(os.path.dirname(__file__), const.DATA_PATH_REL)
backend_env_path = os.path.join(os.path.dirname(__file__), const.BACKEND_ENV_PATH_REL)

vector_search = VectorSearchEngine(data_path)
vector_search.build_index()

sync_engine = SyncEngine(data_path, backend_env_path)

scheduler = BackgroundScheduler()

@scheduler.scheduled_job(const.SCHEDULER_CRON_TRIGGER, minute=const.SCHEDULER_CRON_MINUTE)
def automated_daily_sync() -> None:
    logging.info(const.MSG_RUNNING_SYNC)
    if sync_engine.sync_database():
        vector_search.build_index()

scheduler.start()

class PromptRequest(BaseModel):
    query: str

class RAGResponse(BaseModel):
    anonymized_query: str
    context: list[str]

class ChatResponse(BaseModel):
    query: str
    answer: str
    context_used: int

@app.post(const.API_SYNC_ENDPOINT)
def sync_rag() -> dict[str, str]:
    if not sync_engine.sync_database():
        return {const.KEY_STATUS: const.RESPONSE_STATUS_ERROR, const.KEY_MESSAGE: const.MSG_DB_SYNC_FAILED}
    if not vector_search.build_index():
        return {const.KEY_STATUS: const.RESPONSE_STATUS_ERROR, const.KEY_MESSAGE: const.MSG_INDEX_REBUILD_FAILED}
    return {const.KEY_STATUS: const.RESPONSE_STATUS_SUCCESS, const.KEY_MESSAGE: const.MSG_SYNC_SUCCESS}

@app.get(const.API_STATUS_ENDPOINT)
def get_rag_status() -> dict[str, Any]:
    return {
        const.KEY_STATUS: const.RESPONSE_STATUS_ACTIVE,
        const.KEY_VECTOR_COUNT: vector_search.index.ntotal,
        const.KEY_KNOWLEDGE_BASE_SIZE: len(vector_search.knowledge_base)
    }

@app.post(const.API_CONTEXT_ENDPOINT, response_model=RAGResponse)
def get_rag_context(req: PromptRequest) -> RAGResponse:
    safe_query = anonymizer.anonymize(req.query)
    context_chunks = vector_search.search(safe_query, top_k=const.API_SEARCH_TOP_K)
    return RAGResponse(anonymized_query=safe_query, context=context_chunks)

@app.post(const.API_CHAT_ENDPOINT, response_model=ChatResponse)
def get_rag_chat(req: PromptRequest) -> ChatResponse:
    safe_query = anonymizer.anonymize(req.query)
    context_chunks = vector_search.search(safe_query, top_k=const.API_SEARCH_TOP_K)
    
    answer = llm_engine.generate_response(safe_query, context_chunks)
    
    return ChatResponse(
        query=req.query,
        answer=answer,
        context_used=len(context_chunks)
    )

if __name__ == "__main__":
    uvicorn.run(app, host=const.API_HOST, port=const.API_PORT)
