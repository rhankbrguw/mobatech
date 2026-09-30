import logging
import pymysql
import csv
import os
from dotenv import dotenv_values
import constants as const
from services.sync_processor import process_dynamic_knowledge


class SyncEngine:
    def __init__(self, data_path: str, backend_env_path: str) -> None:
        self.data_path = data_path
        self.env_path = backend_env_path

    def get_db_connection(self) -> pymysql.connections.Connection:
        config = dotenv_values(self.env_path)

        required_keys = ["host", "user", "password", "name", "port"]
        for key in required_keys:
            env_key = const.DB_ENV_KEYS[key]
            if env_key not in config or not config[env_key]:
                raise ValueError(f"Missing required DB config: {env_key}")

        return pymysql.connect(
            host=config[const.DB_ENV_KEYS["host"]],
            user=config[const.DB_ENV_KEYS["user"]],
            password=config[const.DB_ENV_KEYS["password"]],
            database=config[const.DB_ENV_KEYS["name"]],
            port=int(config[const.DB_ENV_KEYS["port"]]),
            cursorclass=pymysql.cursors.DictCursor,
        )

    def _fetch_data_from_db(
        self,
    ) -> tuple[tuple, tuple, tuple, tuple] | tuple[None, None, None, None]:
        conn = None
        try:
            conn = self.get_db_connection()
            with conn.cursor() as cursor:
                cursor.execute(const.QUERY_DOCTORS)
                doctors = cursor.fetchall()
                cursor.execute(const.QUERY_SCHEDULES)
                schedules = cursor.fetchall()
                cursor.execute(const.QUERY_POLYCLINICS)
                polyclinics = cursor.fetchall()
                cursor.execute(const.QUERY_BRANCHES)
                branches = cursor.fetchall()
            return doctors, schedules, polyclinics, branches
        except pymysql.Error as e:
            logging.error(const.ERR_DB_SYNC.format(e=e))
            return None, None, None, None
        finally:
            if conn:
                conn.close()

    def _load_static_items(self) -> list[dict[str, object]]:
        if not os.path.exists(self.data_path):
            return []

        try:
            with open(self.data_path, mode="r", encoding="utf-8") as f:
                cats = {
                    const.CAT_JADWAL,
                    const.CAT_LAYANAN,
                    const.CAT_DOKTER,
                    const.CAT_CABANG,
                }
                return [
                    row
                    for row in csv.DictReader(f)
                    if row.get(const.KEY_KATEGORI) not in cats
                ]
        except (IOError, csv.Error) as e:
            logging.error(const.ERR_CSV_READ.format(e=e))
            return []

    def _save_to_csv(
        self, static_items: list[dict[str, object]], new_knowledge: list[dict[str, object]]
    ) -> bool:
        try:
            with open(self.data_path, mode="w", newline="", encoding="utf-8") as f:
                writer = csv.DictWriter(f, fieldnames=const.CSV_COLUMNS)
                writer.writeheader()
                writer.writerows(static_items)
                writer.writerows(new_knowledge)
            return True
        except IOError as e:
            logging.error(const.ERR_CSV_WRITE.format(e=e))
            return False

    def sync_database(self) -> bool:
        db_data = self._fetch_data_from_db()
        if db_data[0] is None:
            return False

        doctors, schedules, polyclinics, branches = db_data
        new_knowledge = process_dynamic_knowledge(
            doctors, schedules, polyclinics, branches
        )
        static_items = self._load_static_items()

        return self._save_to_csv(static_items, new_knowledge)
