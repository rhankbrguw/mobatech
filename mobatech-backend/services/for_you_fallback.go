package services

import (
	"strings"
)

func (s *forYouService) getPersonalizedFallback(chatContext string) []Article {
	lower := strings.ToLower(chatContext)
	if strings.Contains(lower, "jantung") || strings.Contains(lower, "dada") || strings.Contains(lower, "hipertensi") {
		return s.getCardiologyFallback()
	}
	if strings.Contains(lower, "anak") || strings.Contains(lower, "bayi") || strings.Contains(lower, "imunisasi") {
		return s.getPediatricFallback()
	}
	if strings.Contains(lower, "maag") || strings.Contains(lower, "lambung") || strings.Contains(lower, "gerd") || strings.Contains(lower, "mual") {
		return s.getInternalMedicineFallback()
	}
	if strings.Contains(lower, "batuk") || strings.Contains(lower, "paru") || strings.Contains(lower, "sesak") || strings.Contains(lower, "flu") {
		return s.getRespiratoryFallback()
	}
	if strings.Contains(lower, "gigi") || strings.Contains(lower, "gusi") {
		return s.getDentalFallback()
	}
	return s.getGeneralFallback()
}

func (s *forYouService) getCardiologyFallback() []Article {
	return []Article{
		{ID: "cardio-1", Title: "Menjaga Kesehatan Jantung & Pembuluh Darah", Category: "Poli Jantung", ReadTime: "4 min", Content: "Aktivitas kardio ringan 30 menit dan batasi asupan garam untuk menjaga kestabilan tekanan darah.", Tag: "Berdasarkan Chat Keluhan Dada/Jantung", ActionText: "Konsultasi dr. Gia Pratama Putra", ActionRoute: "/doctors", DoctorName: "dr. Gia Pratama Putra, Sp.JP", PolyName: "Poli Jantung & Pembuluh Darah", LikesCount: 156},
		{ID: "cardio-2", Title: "Pentingnya Pemeriksaan EKG Rutin", Category: "Kardiovaskular", ReadTime: "3 min", Content: "Pemeriksaan rekam jantung berkala membantu mendeteksi aritmia dan penyumbatan sejak dini.", Tag: "Rekomendasi Medis RS Hermina", ActionText: "Daftar Poli Jantung", ActionRoute: "/polyclinics", PolyName: "Poli Jantung & Pembuluh Darah", LikesCount: 98},
		{ID: "cardio-3", Title: "Pola Makan Rendah Kolesterol Jahat (LDL)", Category: "Gaya Hidup", ReadTime: "5 min", Content: "Konsumsi omega-3 dari ikan dan perbanyak serat larut untuk mengontrol plak pembuluh darah.", Tag: "Tips Sehat Harian", ActionText: "Baca Tips Lengkap", ActionRoute: "/for-you", LikesCount: 210},
	}
}

func (s *forYouService) getPediatricFallback() []Article {
	return []Article{
		{ID: "pedia-1", Title: "Panduan Penanganan Demam Si Kecil di Rumah", Category: "Poli Anak", ReadTime: "3 min", Content: "Kompres air hangat dan jaga kecukupan cairan. Waspadai bila demam berlanjut lebih dari 3 hari.", Tag: "Berdasarkan Chat Kesehatan Anak", ActionText: "Konsultasi dr. Budi Santoso, Sp.A", ActionRoute: "/doctors", DoctorName: "dr. Budi Santoso, Sp.A", PolyName: "Poli Anak (Pediatri)", LikesCount: 312},
		{ID: "pedia-2", Title: "Jadwal Imunisasi Dasar Lengkap", Category: "Imunisasi", ReadTime: "4 min", Content: "Pastikan vaksinasi dasar si kecil lengkap sesuai anjuran IDAI demi kekebalan optimal.", Tag: "Rekomendasi Layanan Hermina", ActionText: "Daftar Poli Anak", ActionRoute: "/polyclinics", PolyName: "Poli Anak (Pediatri)", LikesCount: 184},
		{ID: "pedia-3", Title: "Gizi Seimbang untuk Daya Tahan Tubuh Anak", Category: "Nutrisi Anak", ReadTime: "5 min", Content: "Penuhi asupan protein hewani dan vitamin C harian untuk mendukung tumbuh kembang anak.", Tag: "Tips Sehat Keluarga", ActionText: "Baca Tips Lengkap", ActionRoute: "/for-you", LikesCount: 145},
	}
}

func (s *forYouService) getInternalMedicineFallback() []Article {
	return []Article{
		{ID: "intern-1", Title: "Pencegahan dan Perawatan Maag serta GERD", Category: "Penyakit Dalam", ReadTime: "4 min", Content: "Makan teratur dalam porsi kecil namun sering, serta hindari langsung berbaring setelah makan.", Tag: "Berdasarkan Chat Asam Lambung", ActionText: "Konsultasi dr. Tirta Mandira Hudhi", ActionRoute: "/doctors", DoctorName: "dr. Tirta Mandira Hudhi, M.B.A.", PolyName: "Poli Penyakit Dalam", LikesCount: 267},
		{ID: "intern-2", Title: "Membedakan Gejala Maag dan Gangguan Jantung", Category: "Edukasi Medis", ReadTime: "3 min", Content: "Nyeri ulu hati yang menjalar ke leher atau lengan butuh perhatian khusus dari dokter spesialis.", Tag: "Edukasi Klinis Hermina", ActionText: "Konsultasi Dokter", ActionRoute: "/doctors", PolyName: "Poli Penyakit Dalam", LikesCount: 198},
	}
}

func (s *forYouService) getRespiratoryFallback() []Article {
	return []Article{
		{ID: "resp-1", Title: "Pertolongan Pertama Batuk Pilek dan Radang", Category: "Poli Paru & Saluran Napas", ReadTime: "3 min", Content: "Perbanyak minum air hangat dan istirahat. Segera periksakan jika batuk berdahak lebih dari 2 minggu.", Tag: "Berdasarkan Chat Gejala Flu/Batuk", ActionText: "Konsultasi Spesialis Paru", ActionRoute: "/doctors", PolyName: "Poli Paru & Saluran Napas", LikesCount: 175},
		{ID: "resp-2", Title: "Cara Mencegah Penularan Infeksi Saluran Napas", Category: "Pencegahan", ReadTime: "4 min", Content: "Gunakan masker saat bergejala dan jaga sirkulasi udara ruangan tetap bersih dan mengalir.", Tag: "Tips Pencegahan", ActionText: "Lihat Info Layanan", ActionRoute: "/services", LikesCount: 130},
	}
}

func (s *forYouService) getDentalFallback() []Article {
	return []Article{
		{ID: "dent-1", Title: "Pentingnya Scaling Gigi Setiap 6 Bulan Sekali", Category: "Poli Gigi & Mulut", ReadTime: "3 min", Content: "Pembersihan karang gigi secara rutin mencegah radang gusi dan bau mulut tak sedap.", Tag: "Berdasarkan Chat Perawatan Gigi", ActionText: "Daftar Poli Gigi", ActionRoute: "/polyclinics", PolyName: "Poli Gigi & Mulut", LikesCount: 120},
		{ID: "dent-2", Title: "Pertolongan Pertama Gigi Ngilu Sensitif", Category: "Kesehatan Gigi", ReadTime: "3 min", Content: "Gunakan pasta gigi khusus gigi sensitif dan hindari makanan minuman terlalu dingin/panas.", Tag: "Tips Rawat Gigi", ActionText: "Konsultasi Dokter Gigi", ActionRoute: "/doctors", LikesCount: 88},
	}
}

func (s *forYouService) getGeneralFallback() []Article {
	return []Article{
		{ID: "gen-1", Title: "Pentingnya Hidrasi dan Menjaga Pola Tidur Sehat", Category: "Kesehatan Umum", ReadTime: "3 min", Content: "Minum minimal 2 liter air per hari dan tidur 7-8 jam untuk meregenerasi sel imun tubuh.", Tag: "Tips Sehat Harian", ActionText: "Mulai Chat AI", ActionRoute: "/chat", LikesCount: 230},
		{ID: "gen-2", Title: "Pola Makan Gizi Seimbang Isi Piringku", Category: "Nutrisi & Kebugaran", ReadTime: "4 min", Content: "Porsi seimbang antara karbohidrat kompleks, protein, dan sayuran hijau melancarkan metabolisme.", Tag: "Gaya Hidup", ActionText: "Lihat Panduan", ActionRoute: "/for-you", LikesCount: 180},
		{ID: "gen-3", Title: "Pemeriksaan Kesehatan Rutin (Medical Check-Up)", Category: "Pencegahan", ReadTime: "5 min", Content: "Deteksi dini faktor risiko diabetes dan kolesterol melalui MCU tahunan di RS Hermina.", Tag: "Layanan Unggulan", ActionText: "Daftar MCU", ActionRoute: "/services", LikesCount: 195},
	}
}
