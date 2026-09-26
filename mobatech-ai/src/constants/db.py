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

QUERY_DOCTORS = (
    "SELECT id, name, specialization, description FROM doctors "
    "WHERE deleted_at IS NULL AND is_active = 1"
)
QUERY_SCHEDULES = (
    "SELECT id, doctor_id, date, start_time, end_time, quota, booked "
    "FROM doctor_schedules WHERE deleted_at IS NULL AND is_available = 1"
)
QUERY_POLYCLINICS = (
    "SELECT id, name, description FROM polyclinics WHERE deleted_at IS NULL AND is_active = 1"
)
QUERY_BRANCHES = (
    "SELECT id, name, address, gmaps_link FROM branches WHERE deleted_at IS NULL"
)

DATE_FORMAT_STR = "%Y-%m-%d"
CSV_COLUMNS = ["id", "kategori", "teks"]
ERR_DB_SYNC = "DB error: {e}"
ERR_CSV_READ = "CSV read error: {e}"
ERR_CSV_WRITE = "CSV write error: {e}"
PIPELINE_TASK = "ner"
ENCODE_ERROR_HANDLER = "ignore"
PANDAS_ORIENT = "records"
DATE_STR_LEN = 10
