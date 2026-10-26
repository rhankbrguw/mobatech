package constants

const (
	GeminiSystemPrompt = `Anda adalah "Asisten Hermina", AI Asisten Medis & Customer Service 24/7 RS Hermina.
Peran Anda:
1. CS 24/7: Membantu jadwal dokter, alur booking, lokasi cabang, fasilitas RS, dan ambulans.
2. Edukasi Medis Dasar: Menjawab pertanyaan kesehatan umum & pertolongan pertama dasar secara ramah, aman, dan jelas.
Saat ini adalah tanggal: %s

ATURAN UTAMA MENJAWAB:
1. GAYA BAHASA & STRUKTUR:
   - Gunakan bahasa Indonesia yang santai, bersahabat, dan JELAS.
   - JAWABLAH DENGAN RINGKAS DAN TO THE POINT. Gunakan poin-poin (bullet points) agar mudah dibaca di ponsel.
   - DILARANG mengulang salam berulang kali pada setiap giliran chat.

2. EDUKASI KESEHATAN DASAR & PERTOLONGAN PERTAMA:
   - Jawab pertanyaan kesehatan dasar (tips flu, demam ringan, maag/asam lambung, hidrasi, luka ringan, pola hidup) secara edukatif.
   - Wajib sertakan disclaimer singkat: "Saran ini bersifat edukatif dan bukan pengganti diagnosa dokter."
   - Dilarang keras meresepkan obat keras. Hanya sarankan perawatan rumahan aman atau obat bebas (seperti oralit/paracetamol) bila perlu.
   - Sarankan periksa ke Poliklinik RS Hermina jika keluhan berlanjut lebih dari 2-3 hari.

3. TRIAS KELUHAN MEDIS GAWAT DARURAT (RED FLAGS):
   - JIKA gejala mencakup kondisi kritis (nyeri dada berat, sesak napas parah, pendarahan hebat, penurunan kesadaran), HENTIKAN PERCAKAPAN BASA-BASI dan WAJIB langsung arahkan ke IGD (Instalasi Gawat Darurat) SEGERA.

4. CARA PENDAFTARAN & JADWAL DOKTER:
   - Alur booking: Buka menu Home/Poliklinik -> Pilih Dokter -> Pilih Jadwal -> Konfirmasi.
   - Selalu patuhi data dari [Konteks Internal]. JIKA jadwal tidak ada di data, dilarang mengarang dokter fiktif. Katakan jadwal belum tersedia.

5. OUT-OF-DOMAIN REJECTION:
   - Jika pertanyaan DI LUAR konteks medis, kesehatan, jadwal dokter, atau RS Hermina (contoh: resep masakan, politik, coding), tolak dengan sopan.`

	GeminiForYouPrompt = `Anda adalah AI Kurator Konten Medis Edukatif RS Hermina. Berdasarkan riwayat/keluhan pengguna:
%s

Hasilkan 4 kartu edukasi kesehatan FYP yang PALING RELEVAN dan menarik untuk layar beranda pasien.
Format output HARUS JSON array murni tanpa markdown:
[
  {
    "title": "Judul Menarik & Edukatif",
    "category": "Poli Jantung / Poli Anak / Penyakit Dalam / Gigi / Umum",
    "readTime": "3 min",
    "content": "Tips ringkas 1-2 kalimat yang actionable dan mudah dipahami pasien.",
    "tag": "Berdasarkan Chat Terakhir Anda",
    "actionText": "Konsultasi Dokter Terkait",
    "actionRoute": "/doctors",
    "doctorName": "dr. Gia Pratama Putra, Sp.JP",
    "polyName": "Poli Jantung & Pembuluh Darah"
  }
]`

	DefaultChatContext = "Pengguna belum pernah konsultasi. Berikan rekomendasi kesehatan preventif umum."

	MsgAmbulanceDispatched = "Ambulans telah dikirim ke lokasi Anda"
	MsgAmbulanceArrived    = "Ambulans telah tiba di lokasi Anda"
	StatusDispatched       = "Dispatched"
	StatusArrived          = "Arrived"

	// Notification Strings
	MsgNotifNewEResepTitle      = "E-Resep Baru Diterbitkan"
	MsgNotifNewEResepPharmacist = "Dokter telah menerbitkan E-Resep baru untuk pasien. Mohon segera disiapkan/diracik."
	MsgNotifNewEResepPatient    = "Dokter telah menerbitkan e-resep untuk Anda. Silakan tebus di apotek."
	MsgNotifOrderStatusReady    = "Pesanan obat Anda telah selesai diracik oleh apoteker dan siap diambil/dikirim."

	// Standard Error Messages
	MsgUnauthorized         = "Unauthorized"
	MsgInternalServer       = "Terjadi kesalahan internal pada server"
	MsgNotFound             = "Data tidak ditemukan"
	MsgDoctorNotFound       = "Doctor not found"
	MsgServiceNotFound      = "Service not found"
	MsgMedicineNotFound     = "Medicine not found"
	MsgOrderNotFound        = "Order not found"
	MsgPrescriptionNotFound = "Prescription not found"
	MsgPolyclinicNotFound   = "Polyclinic not found"
	MsgEmergencyNotFound    = "Emergency request not found"
	MsgEmailConflict        = "Email sudah terdaftar atau terjadi kesalahan server."
	MsgLoginFailed          = "Email atau kata sandi salah."
	MsgUserNotFound         = "User not found"
	MsgCreateUserFailed     = "Gagal membuat pengguna."
	MsgNoFileUploaded       = "No file uploaded"
	MsgFileSaveFailed       = "Failed to save file"
	MsgFileUploadSuccess    = "File uploaded successfully"

	// Missing String Constants
	MsgInvalidIDParam       = "Invalid id parameter"
	MsgResourceCreated      = "Resource created successfully"
	MsgSuccess              = "Success"
	MsgAccessDenied         = "Access denied"
	MsgInvalidPageParam     = "Invalid page parameter"
	MsgInvalidLimitParam    = "Invalid limit parameter"
	MsgResourceDeleted      = "Resource deleted successfully"
	MsgPrescriptionRedeemed = "Prescription redeemed successfully"
)
