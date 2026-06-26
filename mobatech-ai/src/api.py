import logging
from fastapi import FastAPI
from pydantic import BaseModel
from services.anonymizer import AnonymizationEngine
from services.rag_search import VectorSearchEngine
from services.sync_engine import SyncEngine
import os

app = FastAPI(title="Hermina AI Orchestrator")

anonymizer = AnonymizationEngine()

data_path = os.path.join(os.path.dirname(__file__), "../data/mock_medical_knowledge.csv")
backend_env_path = os.path.join(os.path.dirname(__file__), "../../mobatech-backend/.env")

vector_search = VectorSearchEngine(data_path)
vector_search.build_index()

sync_engine = SyncEngine(data_path, backend_env_path)

class PromptRequest(BaseModel):
    query: str

class RAGResponse(BaseModel):
    anonymized_query: str
    context: list[str]

@app.post("/api/rag/sync")
def sync_rag():
    success = sync_engine.sync_database()
    if not success:
        return {"status": "error", "message": "Database synchronization failed"}
    rebuilt = vector_search.build_index()
    if not rebuilt:
        return {"status": "error", "message": "Failed to rebuild FAISS index"}
    return {"status": "success", "message": "Vector DB synced and rebuilt successfully"}

@app.get("/api/rag/status")
def get_rag_status():
    return {
        "status": "active",
        "vector_count": vector_search.index.ntotal,
        "knowledge_base_size": len(vector_search.knowledge_base)
    }

@app.post("/api/rag/context", response_model=RAGResponse)
def get_rag_context(req: PromptRequest):
    # 1. Privacy Sensor: Anonymize query
    safe_query = anonymizer.anonymize(req.query)
    
    # 2. Semantic Search: Fetch relevant context from Vector DB
    context_chunks = vector_search.search(safe_query, top_k=3)
    
    return RAGResponse(
        anonymized_query=safe_query,
        context=context_chunks
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
