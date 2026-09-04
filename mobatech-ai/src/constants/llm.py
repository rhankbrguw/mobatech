import os

EMBEDDING_MODEL_NAME = os.getenv("EMBEDDING_MODEL_NAME", "paraphrase-multilingual-MiniLM-L12-v2")
EMBEDDING_DIMENSION = 384
DEFAULT_TOP_K = 3
API_SEARCH_TOP_K = 10

GEMINI_MODEL_NAME = os.getenv("GEMINI_MODEL_NAME", "gemini-1.5-flash")
LOCALE_ID = "id_ID.UTF-8"
TIME_FORMAT = "%A, %d %B %Y %H:%M WIB"
ERR_LLM_OFFLINE = (
    "Sistem AI sedang offline. Silakan tambahkan GEMINI_API_KEY di environment."
)
ERR_LLM_EXCEPTION = "Maaf, terjadi gangguan pada sistem AI: {error}"
ERR_LOCALE_FAILED = "Gagal mengatur locale: {e}"
