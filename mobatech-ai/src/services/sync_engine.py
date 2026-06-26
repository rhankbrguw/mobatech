import pymysql
import csv
import os
from dotenv import dotenv_values

class SyncEngine:
    def __init__(self, data_path: str, backend_env_path: str):
        self.data_path = data_path
        self.env_path = backend_env_path

    def get_db_connection(self):
        config = dotenv_values(self.env_path)
        return pymysql.connect(
            host=config.get("DB_HOST", "127.0.0.1"),
            user=config.get("DB_USER", "root"),
            password=config.get("DB_PASSWORD", ""),
            database=config.get("DB_NAME", "mobatech"),
            port=int(config.get("DB_PORT", 3306)),
            cursorclass=pymysql.cursors.DictCursor
        )

    def sync_database(self) -> bool:
        try:
            conn = self.get_db_connection()
        except Exception as e:
            print(f"Database connection failed: {e}")
            return False

        try:
            with conn.cursor() as cursor:
                cursor.execute("SELECT id, name, specialization, description FROM doctors WHERE deleted_at IS NULL AND is_active = 1")
                doctors = cursor.fetchall()
                cursor.execute("SELECT id, doctor_id, date, start_time, end_time, quota, booked FROM doctor_schedules WHERE deleted_at IS NULL AND is_available = 1")
                schedules = cursor.fetchall()
                cursor.execute("SELECT id, name, description FROM polyclinics WHERE deleted_at IS NULL AND is_active = 1")
                polyclinics = cursor.fetchall()
        except Exception as e:
            print(f"Query execution failed: {e}")
            return False
        finally:
            conn.close()

        new_knowledge = []
        row_id = 100
        doc_map = {d["id"]: d for d in doctors}

        for poly in polyclinics:
            text = f"Layanan Poliklinik {poly['name']}: {poly['description']}."
            new_knowledge.append({"id": row_id, "kategori": "Layanan", "teks": text})
            row_id += 1

        for doc in doctors:
            text = f"Dokter {doc['name']} adalah spesialis {doc['specialization']}. {doc['description']}"
            new_knowledge.append({"id": row_id, "kategori": "Dokter", "teks": text})
            row_id += 1

        for sched in schedules:
            doc = doc_map.get(sched["doctor_id"])
            if not doc:
                continue
            date_val = sched["date"]
            date_str = date_val.strftime("%Y-%m-%d") if hasattr(date_val, "strftime") else str(date_val)[:10]
            text = f"Jadwal praktik {doc['name']} ({doc['specialization']}): tanggal {date_str} jam {sched['start_time']} - {sched['end_time']}. Sisa kuota pasien: {sched['quota'] - sched['booked']}."
            new_knowledge.append({"id": row_id, "kategori": "Jadwal", "teks": text})
            row_id += 1

        static_items = []
        if os.path.exists(self.data_path):
            try:
                with open(self.data_path, mode='r', encoding='utf-8') as f:
                    reader = csv.DictReader(f)
                    for row in reader:
                        if row["kategori"] not in ["Jadwal", "Layanan", "Dokter"]:
                            static_items.append(row)
            except Exception as e:
                print(f"Failed to read existing CSV: {e}")

        try:
            with open(self.data_path, mode='w', newline='', encoding='utf-8') as f:
                writer = csv.DictWriter(f, fieldnames=["id", "kategori", "teks"])
                writer.writeheader()
                writer.writerows(static_items)
                writer.writerows(new_knowledge)
            return True
        except Exception as e:
            print(f"Failed to write CSV: {e}")
            return False
