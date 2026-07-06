import logging
import pymysql
import csv
import os
from dotenv import dotenv_values
import constants as const

class SyncEngine:
    def __init__(self, data_path: str, backend_env_path: str):
        self.data_path = data_path
        self.env_path = backend_env_path

    def get_db_connection(self):
        config = dotenv_values(self.env_path)
        return pymysql.connect(
            host=config.get(const.DB_ENV_KEYS["host"], const.DB_DEFAULTS["host"]),
            user=config.get(const.DB_ENV_KEYS["user"], const.DB_DEFAULTS["user"]),
            password=config.get(const.DB_ENV_KEYS["password"], const.DB_DEFAULTS["password"]),
            database=config.get(const.DB_ENV_KEYS["name"], const.DB_DEFAULTS["name"]),
            port=int(config.get(const.DB_ENV_KEYS["port"], const.DB_DEFAULTS["port"])),
            cursorclass=pymysql.cursors.DictCursor
        )

    def _fetch_data_from_db(self):
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
            logging.info(const.ERR_DB_SYNC.format(e=e))
            return None, None, None, None
        finally:
            if 'conn' in locals() and conn:
                conn.close()

    def _process_dynamic_knowledge(self, doctors, schedules, polyclinics, branches):
        knowledge = []
        row_id = const.KNOWLEDGE_START_ID
        doc_map = {d["id"]: d for d in doctors}

        for poly in polyclinics:
            t = const.TEMPLATE_POLY.format(name=poly['name'], description=poly['description'])
            knowledge.append({"id": row_id, "kategori": const.CAT_LAYANAN, "teks": t})
            row_id += 1

        for branch in branches:
            t = const.TEMPLATE_BRANCH.format(name=branch['name'], address=branch['address'], link=branch['gmaps_link'])
            knowledge.append({"id": row_id, "kategori": const.CAT_CABANG, "teks": t})
            row_id += 1

        for doc in doctors:
            t = const.TEMPLATE_DOCTOR.format(name=doc['name'], spec=doc['specialization'], desc=doc['description'])
            knowledge.append({"id": row_id, "kategori": const.CAT_DOKTER, "teks": t})
            row_id += 1

        for sched in schedules:
            doc = doc_map.get(sched["doctor_id"])
            if doc:
                d = sched["date"]
                date_str = d.strftime(const.DATE_FORMAT_STR) if hasattr(d, "strftime") else str(d)[:const.DATE_STR_LEN]
                q = sched['quota'] - sched['booked']
                t = const.TEMPLATE_SCHEDULE.format(name=doc['name'], spec=doc['specialization'], date=date_str, start=sched['start_time'], end=sched['end_time'], quota=q)
                knowledge.append({"id": row_id, "kategori": const.CAT_JADWAL, "teks": t})
                row_id += 1
        return knowledge

    def _load_static_items(self):
        static_items = []
        if os.path.exists(self.data_path):
            try:
                with open(self.data_path, mode='r', encoding='utf-8') as f:
                    cats = [const.CAT_JADWAL, const.CAT_LAYANAN, const.CAT_DOKTER, const.CAT_CABANG]
                    static_items = [row for row in csv.DictReader(f) if row["kategori"] not in cats]
            except Exception as e:
                logging.info(const.ERR_CSV_READ.format(e=e))
        return static_items

    def _save_to_csv(self, static_items, new_knowledge):
        try:
            with open(self.data_path, mode='w', newline='', encoding='utf-8') as f:
                writer = csv.DictWriter(f, fieldnames=const.CSV_COLUMNS)
                writer.writeheader()
                writer.writerows(static_items)
                writer.writerows(new_knowledge)
            return True
        except Exception as e:
            logging.info(const.ERR_CSV_WRITE.format(e=e))
            return False

    def sync_database(self) -> bool:
        db_data = self._fetch_data_from_db()
        if db_data[0] is None:
            return False
            
        doctors, schedules, polyclinics, branches = db_data
        new_knowledge = self._process_dynamic_knowledge(doctors, schedules, polyclinics, branches)
        static_items = self._load_static_items()
        
        return self._save_to_csv(static_items, new_knowledge)
