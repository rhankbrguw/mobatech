import logging
import pymysql
import csv
import os
from typing import Any
from dotenv import dotenv_values
import constants as const
from services.sync_processor import process_dynamic_knowledge


class SyncEngine:
    def __init__(self, data_path: str, backend_env_path: str) -> None:
        self.data_path = data_path
        self.env_path = backend_env_path

    def get_db_connection(self) -> Any:
        config = dotenv_values(self.env_path)
        return pymysql.connect(
            host=config.get(const.DB_ENV_KEYS["host"], const.DB_DEFAULTS["host"]),
            user=config.get(const.DB_ENV_KEYS["user"], const.DB_DEFAULTS["user"]),
            password=config.get(
                const.DB_ENV_KEYS["password"], const.DB_DEFAULTS["password"]
            ),
            database=config.get(const.DB_ENV_KEYS["name"], const.DB_DEFAULTS["name"]),
            port=int(config.get(const.DB_ENV_KEYS["port"], const.DB_DEFAULTS["port"])),
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
        except Exception as e:
            logging.error(const.ERR_DB_SYNC.format(e=e))
            return None, None, None, None
        finally:
            if conn:
                conn.close()

    def _load_static_items(self) -> list[dict[str, Any]]:
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
        except Exception as e:
            logging.error(const.ERR_CSV_READ.format(e=e))
            return []

    def _save_to_csv(
        self, static_items: list[dict[str, Any]], new_knowledge: list[dict[str, Any]]
    ) -> bool:
        try:
            with open(self.data_path, mode="w", newline="", encoding="utf-8") as f:
                writer = csv.DictWriter(f, fieldnames=const.CSV_COLUMNS)
                writer.writeheader()
                writer.writerows(static_items)
                writer.writerows(new_knowledge)
            return True
        except Exception as e:
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
