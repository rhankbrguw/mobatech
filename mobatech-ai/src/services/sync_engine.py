import logging
import pymysql
import csv
import os
from typing import Any
from dotenv import dotenv_values
import constants as const

class SyncEngine:
    def __init__(self, data_path: str, backend_env_path: str) -> None:
        self.data_path = data_path
        self.env_path = backend_env_path

    def get_db_connection(self) -> Any:
        config = dotenv_values(self.env_path)
        return pymysql.connect(
            host=config.get(const.DB_ENV_KEYS["host"], const.DB_DEFAULTS["host"]),
            user=config.get(const.DB_ENV_KEYS["user"], const.DB_DEFAULTS["user"]),
            password=config.get(const.DB_ENV_KEYS["password"], const.DB_DEFAULTS["password"]),
            database=config.get(const.DB_ENV_KEYS["name"], const.DB_DEFAULTS["name"]),
            port=int(config.get(const.DB_ENV_KEYS["port"], const.DB_DEFAULTS["port"])),
            cursorclass=pymysql.cursors.DictCursor
        )

    def _fetch_data_from_db(self) -> tuple[tuple, tuple, tuple, tuple] | tuple[None, None, None, None]:
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

    def _process_polyclinics(self, polyclinics: tuple, start_id: int) -> tuple[list[dict[str, Any]], int]:
        knowledge: list[dict[str, Any]] = []
        for poly in polyclinics:
            t = const.TEMPLATE_POLY.format(name=poly[const.KEY_NAME], description=poly[const.KEY_DESCRIPTION])
            knowledge.append({const.KEY_ID: start_id, const.KEY_KATEGORI: const.CAT_LAYANAN, const.KEY_TEKS: t})
            start_id += 1
        return knowledge, start_id

    def _process_branches(self, branches: tuple, start_id: int) -> tuple[list[dict[str, Any]], int]:
        knowledge: list[dict[str, Any]] = []
        for branch in branches:
            t = const.TEMPLATE_BRANCH.format(
                name=branch[const.KEY_NAME], 
                address=branch[const.KEY_ADDRESS], 
                link=branch[const.KEY_GMAPS_LINK]
            )
            knowledge.append({const.KEY_ID: start_id, const.KEY_KATEGORI: const.CAT_CABANG, const.KEY_TEKS: t})
            start_id += 1
        return knowledge, start_id

    def _process_doctors(self, doctors: tuple, start_id: int) -> tuple[list[dict[str, Any]], int]:
        knowledge: list[dict[str, Any]] = []
        for doc in doctors:
            t = const.TEMPLATE_DOCTOR.format(
                name=doc[const.KEY_NAME], 
                spec=doc[const.KEY_SPECIALIZATION], 
                desc=doc[const.KEY_DESCRIPTION]
            )
            knowledge.append({const.KEY_ID: start_id, const.KEY_KATEGORI: const.CAT_DOKTER, const.KEY_TEKS: t})
            start_id += 1
        return knowledge, start_id

    def _process_schedules(self, schedules: tuple, doc_map: dict[str, Any], start_id: int) -> tuple[list[dict[str, Any]], int]:
        knowledge: list[dict[str, Any]] = []
        for sched in schedules:
            doc = doc_map.get(sched[const.KEY_DOCTOR_ID])
            if not doc:
                continue
                
            d = sched[const.KEY_DATE]
            date_str = d.strftime(const.DATE_FORMAT_STR) if hasattr(d, "strftime") else str(d)[:const.DATE_STR_LEN]
            q = sched[const.KEY_QUOTA] - sched[const.KEY_BOOKED]
            t = const.TEMPLATE_SCHEDULE.format(
                name=doc[const.KEY_NAME], 
                spec=doc[const.KEY_SPECIALIZATION], 
                date=date_str, 
                start=sched[const.KEY_START_TIME], 
                end=sched[const.KEY_END_TIME], 
                quota=q
            )
            knowledge.append({const.KEY_ID: start_id, const.KEY_KATEGORI: const.CAT_JADWAL, const.KEY_TEKS: t})
            start_id += 1
        return knowledge, start_id

    def _process_dynamic_knowledge(self, doctors: tuple, schedules: tuple, polyclinics: tuple, branches: tuple) -> list[dict[str, Any]]:
        knowledge: list[dict[str, Any]] = []
        row_id = const.KNOWLEDGE_START_ID
        doc_map = {d[const.KEY_ID]: d for d in doctors}

        k_poly, row_id = self._process_polyclinics(polyclinics, row_id)
        knowledge.extend(k_poly)

        k_branch, row_id = self._process_branches(branches, row_id)
        knowledge.extend(k_branch)

        k_doc, row_id = self._process_doctors(doctors, row_id)
        knowledge.extend(k_doc)

        k_sched, row_id = self._process_schedules(schedules, doc_map, row_id)
        knowledge.extend(k_sched)

        return knowledge

    def _load_static_items(self) -> list[dict[str, Any]]:
        if not os.path.exists(self.data_path):
            return []
            
        try:
            with open(self.data_path, mode='r', encoding='utf-8') as f:
                cats = {const.CAT_JADWAL, const.CAT_LAYANAN, const.CAT_DOKTER, const.CAT_CABANG}
                return [row for row in csv.DictReader(f) if row.get(const.KEY_KATEGORI) not in cats]
        except Exception as e:
            logging.error(const.ERR_CSV_READ.format(e=e))
            return []

    def _save_to_csv(self, static_items: list[dict[str, Any]], new_knowledge: list[dict[str, Any]]) -> bool:
        try:
            with open(self.data_path, mode='w', newline='', encoding='utf-8') as f:
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
        new_knowledge = self._process_dynamic_knowledge(doctors, schedules, polyclinics, branches)
        static_items = self._load_static_items()
        
        return self._save_to_csv(static_items, new_knowledge)
