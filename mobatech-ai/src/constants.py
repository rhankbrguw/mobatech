import os

# API configuration
API_TITLE = os.getenv("API_TITLE", "Hermina AI Orchestrator")
API_HOST = os.getenv("API_HOST", "0.0.0.0")  # nosec B104
API_PORT = int(os.getenv("API_PORT", 8000))
API_SYNC_ENDPOINT = "/api/rag/sync"
API_STATUS_ENDPOINT = "/api/rag/status"
API_CONTEXT_ENDPOINT = "/api/rag/context"
API_CHAT_ENDPOINT = "/api/rag/chat"

# Scheduler configuration
SCHEDULER_CRON_TRIGGER = "cron"
SCHEDULER_CRON_MINUTE = 0

# File Paths
DATA_PATH_REL = os.getenv("DATA_PATH_REL", "../data/mock_medical_knowledge.csv")
BACKEND_ENV_PATH_REL = os.getenv("BACKEND_ENV_PATH_REL", "../../mobatech-backend/.env")
LLM_BACKEND_ENV_PATH_REL = os.getenv(
    "LLM_BACKEND_ENV_PATH_REL", "../../../mobatech-backend/.env"
)

# RAG & Embeddings
EMBEDDING_MODEL_NAME = "paraphrase-multilingual-MiniLM-L12-v2"
EMBEDDING_DIMENSION = 384
DEFAULT_TOP_K = 3
API_SEARCH_TOP_K = 10

# API Responses
RESPONSE_STATUS_ERROR = "error"
RESPONSE_STATUS_SUCCESS = "success"
RESPONSE_STATUS_ACTIVE = "active"

MSG_DB_SYNC_FAILED = "Database synchronization failed"
MSG_INDEX_REBUILD_FAILED = "Failed to rebuild FAISS index"
MSG_SYNC_SUCCESS = "Vector DB synced and rebuilt successfully"
MSG_RUNNING_SYNC = "Running automated hourly Vector DB sync..."

# LLM Config
GEMINI_MODEL_NAME = "gemini-1.5-flash"
LOCALE_ID = "id_ID.UTF-8"
TIME_FORMAT = "%A, %d %B %Y %H:%M WIB"
ERR_LLM_OFFLINE = (
    "Sistem AI sedang offline. Silakan tambahkan GEMINI_API_KEY di environment."
)
ERR_LLM_EXCEPTION = "Maaf, terjadi gangguan pada sistem AI: {error}"
ERR_LOCALE_FAILED = "Gagal mengatur locale: {e}"

# LLM Prompt
PROMPT_TEMPLATE = """Anda adalah 'Hermina Smart Assistant', asisten virtual medis dan layanan pelanggan resmi di RS Hermina.
Tugas utama Anda adalah memberikan informasi jadwal dokter, layanan rumah sakit, dan triase awal gejala (mengarahkan ke poliklinik yang tepat).

KONTEKS WAKTU SAAT INI: {current_time_str}
Gunakan waktu ini sebagai acuan mutlak jika pengguna bertanya tentang 'hari ini', 'besok', atau 'jadwal terdekat'.

ATURAN KETAT (SYSTEM GUARDRAILS):
1. OUT-OF-DOMAIN: Jika pertanyaan di luar konteks medis, kesehatan, jadwal dokter, atau RS Hermina (misal: resep masakan, politik, coding), TOLAK DENGAN SOPAN. Katakan bahwa Anda hanya asisten medis RS Hermina.
2. TRIAGE & DISCLAIMER GEJALA: Jika pasien menyebutkan keluhan penyakit/gejala, Anda HARUS memberikan peringatan bahwa Anda bukan dokter. Arahkan mereka ke Poliklinik yang relevan berdasarkan konteks.
3. GAWAT DARURAT (EMERGENCY): Jika gejala meliputi nyeri dada berat, sesak napas parah, pendarahan hebat, atau penurunan kesadaran, SEGERA arahkan pasien ke IGD (Instalasi Gawat Darurat) terdekat tanpa basa-basi.
4. ANTI-HALUSINASI: Dilarang keras merekomendasikan nama dokter, jadwal, atau fasilitas yang TIDAK ADA dalam 'Konteks Sistem' di bawah ini. Jika jadwal tidak ada, katakan Anda belum memiliki data tersebut.

Konteks Sistem (Database Jadwal & Layanan RS):
{context_str}

Pertanyaan Pasien: {query}
"""

# Anonymizer Config
NER_MODEL_NAME = "cahya/bert-base-indonesian-NER"
NER_AGGREGATION_STRATEGY = "simple"
WARN_NER_NOT_LOADED = "Warning: NER model not loaded. Using fallback regex anonymizer."
ERR_NER_LOAD_FAILED = "Error loading NER model: {error}"
REGEX_NIK = r"\b\d{16}\b"
REGEX_PHONE = r"\b(?:08|\+628)\d{8,11}\b"
REDACTED_NIK = "[REDACTED_NIK]"
REDACTED_PHONE = "[REDACTED_PHONE]"
RS_NAME_ORIGINAL = "Hermina"
RS_NAME_REDACTED = "[RS_NAME]"
ASCII_ENCODING = "ascii"
REGEX_WHITESPACE = r"\s+"
REPLACE_WHITESPACE = " "

# Database Sync
DB_ENV_KEYS = {
    "host": "DB_HOST",
    "user": "DB_USER",
    "password": "DB_PASSWORD",  # nosec B105
    "name": "DB_NAME",
    "port": "DB_PORT",
}
DB_DEFAULTS = {
    "host": "127.0.0.1",
    "user": "root",
    "password": "",  # nosec B105
    "name": "mobatech",
    "port": 3306,
}

QUERY_DOCTORS = "SELECT id, name, specialization, description FROM doctors WHERE deleted_at IS NULL AND is_active = 1"
QUERY_SCHEDULES = "SELECT id, doctor_id, date, start_time, end_time, quota, booked FROM doctor_schedules WHERE deleted_at IS NULL AND is_available = 1"
QUERY_POLYCLINICS = "SELECT id, name, description FROM polyclinics WHERE deleted_at IS NULL AND is_active = 1"
QUERY_BRANCHES = (
    "SELECT id, name, address, gmaps_link FROM branches WHERE deleted_at IS NULL"
)

KNOWLEDGE_START_ID = 100
CAT_LAYANAN = "Layanan"
CAT_CABANG = "Cabang"
CAT_DOKTER = "Dokter"
CAT_JADWAL = "Jadwal"

TEMPLATE_POLY = "Layanan Poliklinik {name}: {description}."
TEMPLATE_BRANCH = "Cabang Rumah Sakit Hermina {name} berlokasi di alamat {address}. Link Google Maps: {link}"
TEMPLATE_DOCTOR = "Dokter {name} adalah spesialis {spec}. {desc}"
TEMPLATE_SCHEDULE = "Jadwal praktik {name} ({spec}): tanggal {date} jam {start} - {end}. Sisa kuota pasien: {quota}."

DATE_FORMAT_STR = "%Y-%m-%d"
CSV_COLUMNS = ["id", "kategori", "teks"]
ERR_DB_SYNC = "DB error: {e}"
ERR_CSV_READ = "CSV read error: {e}"
ERR_CSV_WRITE = "CSV write error: {e}"
PIPELINE_TASK = "ner"
ENCODE_ERROR_HANDLER = "ignore"
PANDAS_ORIENT = "records"

# Dictionary Keys
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

DATE_STR_LEN = 10
