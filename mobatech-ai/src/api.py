import logging
from fastapi import FastAPI
from pydantic import BaseModel
from services.anonymizer import AnonymizationEngine
from services.rag_search import VectorSearchEngine
import os

app = FastAPI(title="Hermina AI Orchestrator")

anonymizer = AnonymizationEngine()

data_path = os.path.join(os.path.dirname(__file__), "../data/mock_medical_knowledge.csv")
vector_search = VectorSearchEngine(data_path)
vector_search.build_index()

class PromptRequest(BaseModel):
    query: str

class RAGResponse(BaseModel):
    anonymized_query: str
    context: list[str]

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
