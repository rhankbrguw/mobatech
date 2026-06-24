import csv
import os

def generate_mock_data(output_path: str):
    data = [
        {"id": 1, "kategori": "Gejala", "teks": "Jika pasien mengalami batuk lebih dari 2 minggu, disertai darah dan keringat malam, arahkan ke Spesialis Paru untuk indikasi Tuberkulosis (TBC)."},
        {"id": 2, "kategori": "Gejala", "teks": "Jika pasien anak mengalami demam tinggi lebih dari 3 hari disertai bintik merah, arahkan ke Spesialis Anak (dr. Budi Santoso, Sp.A) untuk suspek Demam Berdarah."},
        {"id": 3, "kategori": "Jadwal", "teks": "Jadwal dr. Budi Santoso, Sp.A (Spesialis Anak): Senin 09:00 - 14:00, Rabu 10:00 - 15:00."},
        {"id": 4, "kategori": "Jadwal", "teks": "Jadwal dr. Siti Aminah, Sp.P (Spesialis Paru): Selasa 13:00 - 17:00, Kamis 13:00 - 17:00."},
        {"id": 5, "kategori": "FAQ", "teks": "Jam besuk RS Hermina: Pagi pukul 10:00 - 12:00, Sore pukul 17:00 - 19:00."},
        {"id": 6, "kategori": "FAQ", "teks": "Untuk pendaftaran menggunakan BPJS, pasien diwajibkan membawa surat rujukan aktif dari faskes tingkat pertama."},
        {"id": 7, "kategori": "Layanan", "teks": "IGD RS Hermina beroperasi 24 jam dengan layanan ambulans siaga penuh."},
        {"id": 8, "kategori": "Gejala", "teks": "Nyeri dada sebelah kiri yang menjalar hingga ke lengan atau rahang merupakan tanda serangan jantung darurat. Segera arahkan pasien ke IGD."},
        {"id": 9, "kategori": "Gejala", "teks": "Sakit kepala hebat disertai pandangan kabur pada ibu hamil adalah tanda preeklamsia. Arahkan ke Spesialis Kandungan."},
        {"id": 10, "kategori": "Jadwal", "teks": "Jadwal dr. Gunawan Saputra, Sp.OG (Spesialis Kandungan): Jumat 08:00 - 13:00, Sabtu 08:00 - 13:00."}
    ]
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=["id", "kategori", "teks"])
        writer.writeheader()
        writer.writerows(data)
        
    print(f"Mock data generated successfully at {output_path}")

if __name__ == "__main__":
    import os
    data_path = os.path.join(os.path.dirname(__file__), "../data/mock_medical_knowledge.csv")
    generate_mock_data(data_path)
