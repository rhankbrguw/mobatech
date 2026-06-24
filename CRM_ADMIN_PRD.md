# Product Requirements Document (PRD)
**Project Name:** Hermina Smart Assistant - CRM Admin Portal
**Platform:** Web Application (Next.js / React)
**Architecture:** Layered Architecture (Aligned with Go Backend)

---

## 1. Executive Summary
Sesuai dengan blueprint `Tugas Pertemuan 5 - 9` dan `UTS Project Kelompok 3`, CRM (Customer Relationship Management) atau CMS (Content Management System) Admin Portal ini adalah jembatan kendali utama (Control Center) untuk operasional Rumah Sakit Hermina. 

Fungsi krusial aplikasi ini adalah memanipulasi **Master Data** (Dokter, Jadwal, Layanan) secara dinamis, yang mana setiap perubahan akan secara otomatis memicu sinkronisasi (Pipeline RAG) ke *Vector Database* agar AI Chatbot (GPT-5) di sisi Mobile App (pasien) selalu memiliki pemahaman faktual yang *real-time* dan tidak berhalusinasi.

---

## 2. Tech Stack & Architecture
- **Framework:** Next.js (App Router) atau React Vite.
- **Styling:** Vanilla CSS / Tailwind CSS (dengan tema modern, *glassmorphism*, profesional).
- **State Management:** Zustand atau Redux Toolkit.
- **API Communication:** Axios / Fetch API (terkoneksi ke Go Backend REST API).
- **Authentication & Security:** JWT Auth (Admin Roles) dengan penegakan enkripsi AES-256 untuk mematuhi regulasi PDP (Personal Data Protection) sesuai spesifikasi laporan NFR-01.

---

## 3. Key Features & Modules

### 🩺 A. Master Data Management (Modul Utama)
Mengelola entitas utama rumah sakit yang terhubung langsung ke SIRS (Sistem Informasi Rumah Sakit).
- **Manajemen Poliklinik (Logic Mapping):**
  - Tambah/Edit/Hapus data poliklinik (Misal: menambahkan "Poli Onkologi").
  - Menambahkan *keyword* layanan agar mudah dikenali oleh LLM Chatbot.
- **Manajemen Dokter & Jadwal Praktik:**
  - CRUD Data Dokter (Nama, Spesialisasi, Foto, NIK).
  - CRUD Jadwal Praktik Dokter (Hari, Jam Mulai, Jam Selesai, Kuota Pasien).
  - *Trigger* otomatis: Setiap modifikasi di tabel ini akan menjalankan *webhook* ke server untuk meng- *update* Vector DB (Embeddings).

### 🤖 B. AI Orchestrator Dashboard
- **Knowledge Base Monitor:** Memantau jumlah *chunk* data rekam medis dan jadwal yang berhasil di-*embed* ke Vector DB.
- **Chat History & Audit:** Memantau riwayat obrolan AI dengan pasien (dengan data PII/Personal Identifiable Information yang telah disamarkan/Anonymized).
- **Manual Sync Button:** Tombol untuk memaksa sistem me- *rebuild* Vector Database jika terjadi anomali (RAG Trigger).

### 👥 C. Patient & Booking Tracker
- **Daftar Pasien Terregistrasi:** Melihat demografi pasien yang mendaftar via aplikasi *mobile*.
- **Live Booking Queue (Antrean):** Memantau janji temu/pendaftaran poliklinik yang masuk hari ini.
- **Emergency / Gawat Darurat (Opsional):** Menerima notifikasi atau *log* panggilan darurat dari fitur *Emergency* di aplikasi *mobile*.

---

## 4. User Interface (UI) & User Experience (UX)
Sesuai dengan pakem `AGENTS.md` untuk desain yang mewah dan premium:
- **Tema:** *Dashboard* beraksen putih bersih (White/Light mode) atau *Dark Mode* elegan dengan perpaduan warna hijau khas RS Hermina.
- **Layout:** *Sidebar Navigation* (Kiri) dan *Main Content Area* (Kanan).
- **Data Tables:** Menggunakan tabel responsif yang mendukung fitur *Search, Pagination, dan Filter* untuk mencari data dokter/pasien dengan instan.
- **Dynamic Feedback:** Menggunakan `CustomSnackbar` yang setara cantiknya dengan versi *mobile* untuk menampilkan sukses/gagal menyimpan data.

---

## 5. Sinkronisasi dengan Mobile App & Backend
1. **Admin** menambah jadwal dokter di **CRM Web**.
2. **CRM Web** menembak *endpoint* POST ke **Go Backend**.
3. **Go Backend** menyimpan data relasional ke MySQL.
4. **Go Backend** memicu Python Script / Microservice (seperti di `Untitled0.ipynb`) untuk mengubah jadwal tersebut menjadi bahasa natural, memecahnya (*Chunking*), dan merubahnya menjadi *Embeddings*.
5. Vektor disimpan ke dalam **Vector Database**.
6. Saat Pasien (di **Mobile App**) bertanya: *"Jadwal dokter kandungan hari ini?"*, Chatbot langsung menjawab berdasarkan jadwal terbaru yang di-input oleh Admin di atas.

---

## 6. Development Milestones
- [ ] **Fase 1:** Setup Project (Next.js/React), Desain Sistem Desain (CSS), & Halaman Login Admin.
- [ ] **Fase 2:** Layout Dashboard, Routing, & Master Data Dokter/Poliklinik UI.
- [ ] **Fase 3:** Integrasi API (CRUD Jadwal & Trigger RAG).
- [ ] **Fase 4:** AI Audit Dashboard & Final Polish.
