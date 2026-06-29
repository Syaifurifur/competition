# NOVA Arena

Platform manajemen promosi dan pendaftaran lomba SMA berbasis React, Tailwind CSS, Laravel, dan MySQL.

## Menjalankan aplikasi

Prasyarat: PHP 8.2+, Composer, Node.js 20+, npm, dan MySQL.

```powershell
# Backend
cd backend
copy .env.example .env
composer install
php artisan key:generate
php artisan storage:link
php artisan migrate:fresh --seed
php artisan serve --host=127.0.0.1 --port=8000

# Frontend (terminal lain)
cd frontend
copy .env.example .env
npm install
npm run dev -- --host 127.0.0.1 --port 5173
```

Database default: `nova_arena`, user MySQL `root`, tanpa password. Sesuaikan `backend/.env` bila konfigurasi lokal berbeda.

## Akun demo

- Super Admin: `admin@novaarena.id` / `admin@novaarena.id`
- PIC: `pic@novaarena.id` / `password123`

## Fitur utama

- Landing page, katalog, pencarian/filter, dan detail lomba
- Pendaftaran mobile-first dengan validasi NISN dan file maksimal 2 MB
- Format lomba individu atau tim; untuk tim cukup satu peserta perwakilan yang mendaftarkan tim
- Akun peserta dibuat saat pendaftaran dan digunakan untuk login
- Lupa password dengan token reset sekali pakai yang berlaku selama 60 menit
- Dashboard peserta menampilkan status serta catatan verifikasi
- Edit data hanya aktif ketika panitia menetapkan status Butuh Revisi
- Dashboard agregat Super Admin, CRUD lomba, dan manajemen PIC
- Kelola seluruh akun oleh Super Admin: role, penugasan PIC, reset password, serta aktivasi akun
- Jumlah slot dan penugasan banyak PIC dapat diatur per lomba
- Tombol WhatsApp publik dibuat otomatis untuk setiap PIC aktif yang ditugaskan
- Meja verifikasi PIC, pembatasan data per lomba, dan ekspor CSV
- Enkripsi nama ibu di database serta masking penuh dari akun PIC

## Kebijakan Dokumentasi

Setiap perubahan fitur, skema database, API, hak akses, atau alur pengguna wajib dicatat pada bagian **Changelog** di bawah. Entri terbaru ditempatkan paling atas dan memuat tanggal serta ringkasan perubahan.

## Changelog

### 2026-06-27

- Menambahkan jumlah slot PIC ketika membuat lomba dan pengaturan `PIC & Slot` ketika mengedit lomba.
- Menambahkan penugasan beberapa PIC untuk satu lomba.
- Mewajibkan nomor WhatsApp aktif pada akun PIC.
- Menambahkan tombol WhatsApp untuk setiap PIC pada halaman detail lomba.
- Mengembalikan tombol pengaturan format lomba Individu/Tim pada Manajemen Lomba.
- Menambahkan modul Kelola Akun khusus Super Admin.
- Menambahkan fitur lupa dan reset password dengan token sekali pakai selama 60 menit.
- Menambahkan login dan dashboard peserta beserta alur revisi data berdasarkan permintaan panitia.
- Mengubah pendaftaran tim agar cukup dilakukan oleh satu peserta perwakilan.
- Menambahkan format lomba Individu/Tim serta konfigurasi jumlah anggota tim.
