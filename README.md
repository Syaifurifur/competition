# Kreasi UNM 2026

Platform promosi, pendaftaran, pemeriksaan, dan pengelolaan kompetisi SMA berbasis React, Tailwind CSS, Laravel, dan MySQL.

## Teknologi

- Frontend: React 19, React Router, Tailwind CSS, Vite, dan Lucide Icons
- Backend: Laravel 12 dan PHP 8.2+
- Database: MySQL/MariaDB
- Autentikasi API: bearer token
- Penyimpanan dokumen dan gambar: Laravel public storage
- Ekspor data: workbook Excel `.xlsx`

## Prasyarat

- PHP 8.2 atau lebih baru
- Composer
- Node.js 20 atau lebih baru
- npm
- MySQL atau MariaDB

## Instalasi awal

```powershell
# Backend
cd backend
copy .env.example .env
composer install
php artisan key:generate
php artisan storage:link
php artisan migrate:fresh --seed

# Frontend
cd ..\frontend
copy .env.example .env
npm install
```

> `migrate:fresh` menghapus seluruh tabel dan hanya digunakan untuk instalasi awal atau reset data pengembangan. Untuk memperbarui aplikasi yang sudah berisi data, gunakan `php artisan migrate --force`.

Konfigurasi database bawaan:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=nova_arena
DB_USERNAME=root
DB_PASSWORD=
```

Konfigurasi API frontend:

```env
VITE_API_URL=http://127.0.0.1:8000/api
```

## Menjalankan aplikasi

Jalankan backend:

```powershell
cd backend
php artisan serve --host=127.0.0.1 --port=8000
```

Jalankan frontend pada terminal lain:

```powershell
cd frontend
npm run dev -- --host 127.0.0.1 --port 5173
```

- Website: `http://127.0.0.1:5173`
- API: `http://127.0.0.1:8000/api`

## Akun demo

- Super Admin: `admin@kreasiunm.id` / `password123`
- PIC: `pic@kreasiunm.id` / `password123`

Brand aplikasi telah berubah menjadi **Kreasi UNM 2026**. Nama database `nova_arena` dan prefix tiket lama `NOVA-` tetap dipertahankan untuk menjaga kompatibilitas data.

## Role dan hak akses

### Super Admin

- Mengakses seluruh dashboard dan seluruh lomba
- Membuat, mengubah, dan menghapus lomba
- Mengelola akun, PIC, role kustom, dan izin
- Menentukan jumlah slot PIC dan menugaskan beberapa PIC pada satu lomba
- Memeriksa peserta, melihat nama ibu, memvalidasi NISN, dan menentukan hasil verifikasi
- Membuka struk pembayaran dan memvalidasi pembayaran setiap pendaftaran atau tim
- Menghapus data pendaftaran secara permanen
- Mengelola konten landing page, slideshow, sponsor, dan media partner

### PIC lomba

- Hanya mengakses data lomba yang ditugaskan
- Melihat dan memeriksa pendaftar
- Melihat nama ibu untuk kebutuhan pengecekan NISN
- Menandai NISN anggota sebagai valid atau membatalkan validasi
- Membuka bukti pembayaran dan menandainya valid atau membatalkan validasi
- Memberikan keputusan diterima, butuh revisi, atau ditolak
- Mengekspor pendaftar tervalidasi

### Tim registrasi atau role kustom

Super Admin dapat membuat role kustom dan memilih izin berikut:

- `dashboard.view`
- `registrations.view`
- `registrations.review`
- `registrations.export`
- `competitions.view`
- `competitions.format`
- `competitions.manage`
- `accounts.manage`
- `roles.manage`
- `content.manage`

Akun tim registrasi yang memiliki `registrations.view` dan `registrations.review` dapat memeriksa peserta sesuai penugasan lombanya.

### Peserta

- Login menggunakan akun yang dibuat saat pendaftaran
- Melihat seluruh pendaftaran yang dibuat dengan akun yang sama
- Melihat data tim, anggota, official, status, catatan panitia, dan hasil validasi NISN
- Mengubah data hanya ketika panitia menetapkan status **Butuh Revisi**

## Fitur landing page

- Branding Kreasi UNM 2026
- Katalog, pencarian, filter, dan detail lomba
- Timeline lomba fleksibel
- Tombol WhatsApp untuk setiap PIC aktif yang ditugaskan
- Hero dinamis dengan teks, tombol, hashtag, dan slideshow maksimal 10 gambar
- Slideshow dokumentasi kegiatan terdahulu maksimal 12 foto
- Setiap foto kegiatan dapat ditautkan ke postingan Instagram
- Logo sponsor maksimal 20 item
- Logo media partner maksimal 20 item
- Sponsor dan Media Partners tampil berdampingan di desktop dan bertumpuk pada layar kecil
- Setiap logo sponsor atau media partner dapat ditautkan ke website terkait

## Manajemen konten website

Menu **Dashboard → Konten Website** tersedia bagi akun dengan izin `content.manage`.

Konten yang dapat dikelola:

- Label kecil hero
- Dua baris judul hero
- Deskripsi hero
- Teks dan tujuan dua tombol hero
- Hashtag
- Gambar dan durasi slideshow hero
- Judul, deskripsi, foto, durasi, dan tautan Instagram galeri kegiatan
- Judul, logo, nama, urutan, dan tautan website sponsor
- Judul, logo, nama, urutan, dan tautan Media Partners

Gambar konten dapat berasal dari URL atau upload JPG, JPEG, PNG, dan WebP maksimal 5 MB per file.

Ukuran aset visual yang disarankan:

| Jenis gambar | Ukuran piksel | Rasio | Catatan |
| --- | --- | --- | --- |
| Hero slider | 1600 × 900 px | 16:9 | Gunakan foto lanskap dengan objek utama di tengah |
| Galeri kegiatan | 1600 × 900 px | 16:9 | Disiapkan untuk slideshow dan tautan Instagram |
| Poster lomba | 1080 × 1350 px | 4:5 | Hindari teks penting terlalu dekat dengan tepi |
| Logo sponsor | 800 × 400 px | 2:1 | PNG/WebP transparan disarankan |
| Logo Media Partners | 800 × 400 px | 2:1 | PNG/WebP transparan disarankan |

Keterangan ukuran piksel juga ditampilkan langsung pada setiap input gambar di dashboard.

## Manajemen lomba

- Jenis lomba: Sport Competition, Talent Competition, dan Science Competition
- Format peserta individu atau tim
- Jumlah anggota tim dapat diatur hingga 20 siswa
- Jumlah official dapat diatur hingga 20 orang
- Jumlah slot PIC dapat diatur hingga 10 akun
- Beberapa PIC dapat ditugaskan pada satu lomba sesuai kapasitas slot
- Timeline menggunakan nama tahap bebas
- Input URL poster menampilkan rekomendasi ukuran 1080 × 1350 px dengan rasio 4:5
- Setiap tahap dapat memakai satu tanggal atau rentang tanggal
- Tahap diurutkan otomatis berdasarkan tanggal
- Tanggal pertama dan terakhir dipakai sebagai rentang internal katalog
- Format tidak dapat diubah setelah lomba memiliki pendaftar jika perubahan memengaruhi struktur peserta

## Pendaftaran peserta

### Pendaftaran individu

Peserta mengisi identitas, NISN, nama ibu, sekolah, guru pendamping, kontak, dan dokumen wajib.

### Pendaftaran tim

- Satu perwakilan mendaftarkan seluruh tim
- Perwakilan otomatis menjadi anggota pertama
- Jumlah anggota wajib sama dengan pengaturan lomba
- Setiap anggota memiliki nama, email, WhatsApp, NISN, tempat/tanggal lahir, kelas, nama ibu, kartu pelajar, dan pas foto
- Jumlah official wajib sama dengan pengaturan lomba
- Setiap official memiliki nama, jabatan, dan WhatsApp
- NISN anggota harus unik dalam tim dan belum terdaftar pada lomba yang sama
- Akun peserta dapat digunakan kembali untuk mendaftar lomba lain jika password sesuai

Dokumen pendaftaran yang didukung:

- Kartu pelajar: JPG, JPEG, PNG, atau PDF
- Surat Rekomendasi Sekolah: DOC, DOCX, JPG, JPEG, PNG, atau PDF
- Pas foto: JPG, JPEG, atau PNG
- Bukti pembayaran: JPG, JPEG, PNG, atau PDF
- Batas ukuran: 2 MB per file

## Alur pemeriksaan dan validasi

1. Pendaftaran baru masuk dengan status **Menunggu**.
2. Super Admin, PIC, atau tim registrasi berizin membuka halaman **Pendaftar → Periksa**.
3. Petugas dapat melihat data anggota, official, dan dokumen.
4. Tombol pengecekan NISN tersedia langsung pada card masing-masing anggota tim.
5. Petugas menyalin NISN dan nama ibu lalu membuka situs resmi NISN Kemendikdasmen.
6. Jika data ditemukan, petugas memilih **Tandai NISN Valid** pada card anggota tersebut.
7. Sistem menyimpan waktu dan akun petugas yang melakukan validasi.
8. Petugas memilih keputusan **Diterima**, **Butuh Revisi**, atau **Ditolak**.
9. Untuk lomba berbayar, petugas membuka struk dan menandai **Pembayaran Valid** sebelum peserta dapat diterima.
10. Catatan wajib diisi untuk keputusan Butuh Revisi atau Ditolak.

Nama ibu disimpan dalam keadaan terenkripsi. Nilai tersebut hanya ditampilkan kepada peserta pemilik data dan petugas yang memiliki izin pemeriksaan.

## Alur revisi data

- Data peserta terkunci secara bawaan.
- Tombol **Perbaiki Data Tim** hanya muncul saat status pendaftaran **Butuh Revisi**.
- Status tersebut dapat diberikan oleh Super Admin, PIC, atau tim registrasi dengan izin `registrations.review`.
- Peserta dapat memperbarui seluruh anggota, official, sekolah, administrasi, dan dokumen terkait.
- Setelah dikirim, status kembali menjadi **Menunggu** dan data terkunci kembali.
- Status valid NISN anggota direset agar petugas memeriksa ulang data hasil revisi.

## Dashboard dan data pendaftar

- Ringkasan jumlah lomba, pendaftar, antrean verifikasi, dan estimasi transaksi
- Filter pendaftar berdasarkan nama lomba, status, nama, tim, tiket, atau sekolah
- Pemeriksaan data individu dan tim
- Kontak WhatsApp siswa dan official
- Status verifikasi pembayaran terlihat oleh petugas dan peserta
- Ekspor pendaftar berstatus diterima ke workbook Excel `.xlsx`
- Penghapusan permanen pendaftaran khusus Super Admin

## Akun dan keamanan

- Login terpadu untuk peserta, PIC, role kustom, dan Super Admin
- Akun peserta dibuat saat pendaftaran
- Lupa password menggunakan token sekali pakai yang berlaku 60 menit
- Super Admin dapat mengaktifkan atau menonaktifkan akun
- Password disimpan dalam bentuk hash
- Nama ibu disimpan terenkripsi
- Endpoint backend menegakkan role, izin, kepemilikan data, dan cakupan lomba
- Data peserta hanya dapat diedit oleh pemilik pendaftaran ketika status Butuh Revisi

## Pengujian dan build

Jalankan seluruh pengujian backend:

```powershell
cd backend
php artisan test
```

Periksa dan build frontend:

```powershell
cd frontend
npm run lint
npm run build
```

Kondisi verifikasi terakhir: **15 tes backend lulus dengan 112 assertions**, build frontend berhasil, dan endpoint landing/content merespons HTTP 200.

## Kebijakan dokumentasi

Setiap perubahan fitur, skema database, API, hak akses, atau alur pengguna wajib dicatat pada bagian **Changelog**. Entri terbaru ditempatkan paling atas dan memuat tanggal serta ringkasan perubahan.

## Changelog

### 2026-06-28

- Menambahkan keterangan ukuran piksel dan rasio yang disarankan pada input hero slider, galeri kegiatan, poster lomba, sponsor, dan Media Partners.
- Menyatukan tombol dan status verifikasi NISN ke dalam card masing-masing anggota tim pada pemeriksaan peserta.
- Menambahkan pemeriksaan bukti pembayaran per pendaftaran/tim beserta status valid, waktu, dan petugas pemeriksa.
- Memperbarui README agar mendokumentasikan seluruh fitur, role, alur peserta, verifikasi, revisi, dan manajemen konten terbaru.
- Menambahkan pengelolaan logo Media Partners dan menampilkannya berdampingan dengan sponsor di landing page.
- Menambahkan slideshow foto kegiatan yang terhubung ke Instagram dan deretan logo sponsor di atas footer, keduanya dikelola dari dashboard konten.
- Mengubah branding NOVA Arena menjadi Kreasi UNM 2026 pada website, dashboard, email sistem, dan akun demo.
- Menambahkan pengelolaan konten hero halaman depan dari dashboard, termasuk teks, tombol, hashtag, dan slideshow hingga 10 gambar.
- Menampilkan data lengkap anggota dan official beserta hasil validasi NISN pada dashboard peserta.
- Mengizinkan peserta memperbarui seluruh data tim hanya setelah Super Admin atau tim registrasi meminta revisi.
- Memberikan akses PIC lomba untuk melihat nama ibu dan memvalidasi NISN anggota dalam cakupan lombanya.
- Menambahkan tombol Valid pada pemeriksaan NISN setiap anggota tim serta menyimpan status dan petugas yang memvalidasi.
- Menambahkan pengaturan jumlah timeline saat membuat lomba, lengkap dengan nama dan tanggal bebas untuk setiap tahap.
- Menambahkan pilihan satu tanggal atau rentang tanggal awal–akhir pada setiap timeline.
- Menampilkan seluruh timeline kustom pada halaman detail lomba.
- Menghapus input tanggal mulai pendaftaran, tutup pendaftaran, dan tanggal utama; seluruh tanggal kini bersumber dari timeline fleksibel.
- Mengurutkan timeline berdasarkan tanggal serta memakai tahap pertama dan terakhir sebagai rentang internal untuk kompatibilitas katalog.
- Mengubah pendaftaran tim agar perwakilan menjadi anggota pertama dan dapat melengkapi anggota lain sesuai jumlah yang ditetapkan pengelola.
- Menambahkan pengaturan jumlah official untuk lomba format tim.
- Menambahkan input nama, jabatan, dan WhatsApp official pada formulir pendaftaran tim.
- Menampilkan daftar official tim beserta jabatan dan kontak WhatsApp pada pemeriksaan pendaftar.
- Menambahkan email dan nomor telepon/WhatsApp untuk setiap siswa anggota tim pada formulir serta pemeriksaan pendaftar.
- Menambahkan role kustom pada Kelola Akun dengan checklist izin untuk dashboard, pendaftar, verifikasi, ekspor, lomba, akun, role, dan konten.
- Menegakkan izin role pada endpoint backend serta menyaring menu panel berdasarkan hak akses akun.
- Menambahkan filter berdasarkan nama lomba yang tersedia pada halaman Pendaftar.
- Mengubah jenis lomba menjadi Sport Competition, Talent Competition, dan Science Competition.
- Mengubah ekspor pendaftar tervalidasi dari CSV menjadi workbook Excel `.xlsx`.
- Menambahkan penghapusan permanen data pendaftaran khusus Super Admin.
- Menambahkan validasi jumlah anggota, jumlah official, dan duplikasi NISN seluruh anggota tim.

### 2026-06-27

- Menambahkan ringkasan pesan kesalahan yang terlihat ketika pendaftaran gagal disimpan, termasuk kegagalan koneksi server dan validasi setiap field.
- Menambahkan jumlah slot PIC ketika membuat lomba dan pengaturan PIC serta slot ketika mengedit lomba.
- Menambahkan penugasan beberapa PIC untuk satu lomba.
- Mewajibkan nomor WhatsApp aktif pada akun PIC.
- Menambahkan tombol WhatsApp untuk setiap PIC pada halaman detail lomba.
- Mengembalikan tombol pengaturan format lomba Individu/Tim pada Manajemen Lomba.
- Menambahkan modul Kelola Akun khusus Super Admin.
- Menambahkan fitur lupa dan reset password dengan token sekali pakai selama 60 menit.
- Menambahkan login dan dashboard peserta beserta alur revisi data berdasarkan permintaan panitia.
- Mengubah pendaftaran tim agar cukup dilakukan oleh satu peserta perwakilan.
- Menambahkan format lomba Individu/Tim serta konfigurasi jumlah anggota tim.
