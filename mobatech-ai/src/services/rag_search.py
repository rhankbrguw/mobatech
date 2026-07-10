import pandas as pd
from sentence_transformers import SentenceTransformer
import faiss
import logging
from typing import Any
import constants as const

class VectorSearchEngine:
    def __init__(self, data_path: str) -> None:
        self.data_path = data_path
        self.model = SentenceTransformer(const.EMBEDDING_MODEL_NAME)
        self.dimension = const.EMBEDDING_DIMENSION
        self.index = faiss.IndexFlatL2(self.dimension)
        self.knowledge_base: list[dict[str, Any]] = []
        
    def build_index(self) -> bool:
        try:
            df = pd.read_csv(self.data_path)
        except Exception as e:
            logging.error(const.ERR_CSV_READ.format(e=e))
            return False
            
        self.knowledge_base = df.to_dict(const.PANDAS_ORIENT)
        texts = [str(item.get(const.KEY_TEKS, "")) for item in self.knowledge_base]
        
        embeddings = self.model.encode(texts)
        faiss.normalize_L2(embeddings)
        
        self.index = faiss.IndexFlatL2(self.dimension)
        self.index.add(embeddings)
        return True
        
    def search(self, query: str, top_k: int = const.DEFAULT_TOP_K) -> list[str]:
        if self.index.ntotal == 0:
            return []
            
        query_vector = self.model.encode([query])
        faiss.normalize_L2(query_vector)
        
        _, indices = self.index.search(query_vector, top_k)
        
        results: list[str] = []
        for i in range(top_k):
            idx = indices[0][i]
            if idx != -1:
                results.append(str(self.knowledge_base[idx].get(const.KEY_TEKS, "")))
                
        return results
