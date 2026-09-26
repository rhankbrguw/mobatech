import os

API_TITLE = os.getenv("API_TITLE", "Hermina AI Orchestrator")
API_HOST = os.getenv("API_HOST", "0.0.0.0")  # nosec B104
API_PORT = int(os.getenv("PORT", os.getenv("API_PORT", "8000")))
API_SYNC_ENDPOINT = "/api/rag/sync"
API_STATUS_ENDPOINT = "/api/rag/status"
API_CONTEXT_ENDPOINT = "/api/rag/context"
API_CHAT_ENDPOINT = "/api/rag/chat"

SCHEDULER_CRON_TRIGGER = "cron"
SCHEDULER_CRON_MINUTE = 0

DATA_PATH_REL = os.getenv("DATA_PATH_REL", "../data/mock_medical_knowledge.csv")
BACKEND_ENV_PATH_REL = os.getenv("BACKEND_ENV_PATH_REL", "../../mobatech-backend/.env")
LLM_BACKEND_ENV_PATH_REL = os.getenv(
    "LLM_BACKEND_ENV_PATH_REL", "../../../mobatech-backend/.env"
)

RESPONSE_STATUS_ERROR = "error"
RESPONSE_STATUS_SUCCESS = "success"
RESPONSE_STATUS_ACTIVE = "active"

CODE_SUCCESS = "SUCCESS"
CODE_SYNC_DB_ERROR = "SYNC_DB_ERROR"
CODE_SYNC_INDEX_ERROR = "SYNC_INDEX_ERROR"

MSG_DB_SYNC_FAILED = "Database synchronization failed"
MSG_INDEX_REBUILD_FAILED = "Failed to rebuild FAISS index"
MSG_SYNC_SUCCESS = "Vector DB synced and rebuilt successfully"
MSG_RUNNING_SYNC = "Running automated hourly Vector DB sync..."
MSG_STATUS_SUCCESS = "Status retrieved successfully"
MSG_CONTEXT_SUCCESS = "Context retrieved successfully"
MSG_CHAT_SUCCESS = "Chat response generated successfully"

KEY_STATUS = "status"
KEY_MESSAGE = "message"
KEY_VECTOR_COUNT = "vector_count"
KEY_KNOWLEDGE_BASE_SIZE = "knowledge_base_size"
KEY_START = "start"
KEY_TEKS = "teks"
KEY_KATEGORI = "kategori"
KEY_ID = "id"
KEY_NAME = "name"
KEY_DESCRIPTION = "description"
KEY_ADDRESS = "address"
KEY_GMAPS_LINK = "gmaps_link"
KEY_SPECIALIZATION = "specialization"
KEY_DOCTOR_ID = "doctor_id"
KEY_DATE = "date"
KEY_QUOTA = "quota"
KEY_BOOKED = "booked"
KEY_START_TIME = "start_time"
KEY_END_TIME = "end_time"
