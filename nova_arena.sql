-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 30 Jun 2026 pada 08.52
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nova_arena`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `access_roles`
--

CREATE TABLE `access_roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(80) NOT NULL,
  `slug` varchar(80) NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`permissions`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `access_roles`
--

INSERT INTO `access_roles` (`id`, `name`, `slug`, `permissions`, `created_at`, `updated_at`) VALUES
(1, 'TIM REGISTRASI', 'tim_registrasi', '[\"dashboard.view\",\"registrations.view\",\"registrations.review\",\"registrations.export\",\"competitions.format\"]', '2026-06-27 22:43:13', '2026-06-27 22:43:13');

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `competitions`
--

CREATE TABLE `competitions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `category` varchar(40) NOT NULL,
  `participation_type` enum('individual','team') NOT NULL DEFAULT 'individual',
  `team_size` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `official_count` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `pic_slots` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `short_description` text NOT NULL,
  `description` longtext NOT NULL,
  `quota` int(10) UNSIGNED NOT NULL,
  `fee` decimal(12,2) NOT NULL DEFAULT 0.00,
  `registration_start` date NOT NULL,
  `registration_end` date NOT NULL,
  `team_update_deadline_at` datetime DEFAULT NULL,
  `document_upload_deadline_at` datetime DEFAULT NULL,
  `event_date` date NOT NULL,
  `submission_start_at` datetime DEFAULT NULL,
  `submission_end_at` datetime DEFAULT NULL,
  `judging_locked_at` timestamp NULL DEFAULT NULL,
  `results_announced_at` timestamp NULL DEFAULT NULL,
  `location` varchar(255) NOT NULL DEFAULT 'Online',
  `poster_url` varchar(255) DEFAULT NULL,
  `whatsapp_group_url` varchar(500) DEFAULT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `guides` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`guides`)),
  `downloadable_documents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`downloadable_documents`)),
  `judging_guide` longtext DEFAULT NULL,
  `timeline` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`timeline`)),
  `schedule_venues` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`schedule_venues`)),
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `competitions`
--

INSERT INTO `competitions` (`id`, `title`, `slug`, `category`, `participation_type`, `team_size`, `official_count`, `pic_slots`, `short_description`, `description`, `quota`, `fee`, `registration_start`, `registration_end`, `team_update_deadline_at`, `document_upload_deadline_at`, `event_date`, `submission_start_at`, `submission_end_at`, `judging_locked_at`, `results_announced_at`, `location`, `poster_url`, `whatsapp_group_url`, `requirements`, `guides`, `downloadable_documents`, `judging_guide`, `timeline`, `schedule_venues`, `is_featured`, `created_at`, `updated_at`) VALUES
(5, 'PADEL CHAMPIONSHIP', 'padel-championship', 'Sport Competition', 'team', 3, 1, 1, 'Lomba Padel Tingkat SMA / MA / SMK Sederajat', 'Lomba Padel Tingkat SMA adalah kompetisi olahraga padel yang dirancang khusus untuk siswa-siswi sekolah menengah atas. Pertandingan dilakukan dalam format ganda (doubles) dengan sistem gugur (knock-out) yang dipadu babak grup di tahap awal. Tujuan kompetisi ini adalah mengembangkan bakat dan semangat kompetisi atletis para pelajar sekaligus mempopulerkan olahraga padel di kalangan generasi muda.', 100, 100000.00, '2026-07-01', '2026-08-01', '2026-08-01 16:59:59', '2026-08-01 16:59:59', '2026-08-01', NULL, NULL, NULL, NULL, 'Online', 'https://res.cloudinary.com/di1ec1jxv/image/upload/v1782639848/08eaac80-b149-43c2-8360-dae2c27bff5f_zjcbkd.png', NULL, '[]', '[{\"title\":\"Ketentuan Umum\",\"content\":\"Siswa\\/siswi aktif SMA\\/SMK\\/MA sederajat yang dibuktikan dengan Kartu Pelajar atau surat keterangan dari sekolah\\nBerusia maksimal 19 tahun pada saat kompetisi berlangsung\\nWajib membawa Kartu Pelajar asli dan fotokopi saat registrasi ulang pada hari pertandingan\\nSetiap pasangan terdiri dari 2 pemain sesuai kategori yang diikuti (putra, putri, atau campuran)\\nPeserta belum pernah terdaftar sebagai atlet padel profesional atau menjuarai turnamen nasional resmi\\nBersedia menjunjung sportivitas, fair play, dan mematuhi seluruh peraturan panitia\"}]', NULL, NULL, '[{\"label\":\"Waktu Lomba\",\"type\":\"single\",\"date\":\"2026-07-01\"},{\"label\":\"Penutupan Pendaftaran\",\"type\":\"single\",\"date\":\"2026-07-30\"},{\"label\":\"Technical Meeting\",\"type\":\"single\",\"date\":\"2026-07-31\"},{\"label\":\"Pendaftaran\",\"type\":\"single\",\"date\":\"2026-08-01\"}]', NULL, 1, '2026-06-27 18:24:04', '2026-06-28 07:11:27'),
(6, 'FUTSAL COMPETITION', 'futsal-competition', 'Sport Competition', 'team', 5, 1, 3, 'Lomba Futsal Tingkat SMA / MA / SMK Sederajat', 'Lomba Futsal KREASI UNM 2026 merupakan ajang kompetisi olahraga antarpelajar yang diselenggarakan oleh Universitas Nusa Mandiri dalam rangka Kompetisi Kreativitas Siswa Indonesia (KREASI) 2026. Kompetisi ini menjadi wadah bagi para peserta untuk menunjukkan kemampuan bermain, strategi, kekompakan tim, semangat juang, dan sportivitas di lapangan.\n\nPertandingan futsal akan dilaksanakan pada 18–20 Agustus 2026. Segera bentuk tim terbaikmu, tampilkan permainan yang solid, dan buktikan bahwa sekolahmu layak menjadi juara!\n\nUnleash Your Spirit!\nSaatnya ubah semangat menjadi prestasi bersama KREASI UNM 2026.', 32, 250000.00, '2026-08-15', '2026-08-20', '2026-08-20 16:59:00', '2026-08-20 16:59:00', '2026-08-20', NULL, NULL, NULL, NULL, 'Sport Center UNM Kampus Jatiwaringin', 'https://res.cloudinary.com/di1ec1jxv/image/upload/v1782639756/37eddf5b-4559-4a63-b3d8-30f31bfe3713_cv6w60.png', NULL, '[]', '[{\"title\":\"Ketentuan Pendaftaran\",\"content\":\"Pendaftaran dan update berkas dapat dilakukan secara online melalui link: kreasi.nusamandiri.info\\nBiaya pendaftaran: FREE\\nBiaya Komitmen Pertandingan dengan kode unik Sebesar Rp. 200.000 (Akan dikembalikan jika Tim telah mengikuti kompetisi hingga Akhir). Biaya tersebut dapat ditransfer melalui Rekening Mandiri 123 000 111 3804, a\\/n Yayasan Indonesia Nusa Mandiri Kcp Kramat Raya Jakarta Pusat\"}]', NULL, NULL, '[{\"label\":\"Batas Pendaftaran\",\"type\":\"single\",\"date\":\"2026-08-15\"},{\"label\":\"Tecnical Meeting\",\"type\":\"single\",\"date\":\"2026-08-16\"},{\"label\":\"Pelaksanaan Futsal Competition\",\"type\":\"range\",\"start_date\":\"2026-08-18\",\"end_date\":\"2026-08-20\",\"date\":\"2026-08-18|2026-08-20\"}]', NULL, 1, '2026-06-28 02:36:30', '2026-06-29 00:26:41');

-- --------------------------------------------------------

--
-- Struktur dari tabel `competition_notifications`
--

CREATE TABLE `competition_notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `competition_id` bigint(20) UNSIGNED DEFAULT NULL,
  `author_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(160) NOT NULL,
  `message` text NOT NULL,
  `published_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `judge_assignments`
--

CREATE TABLE `judge_assignments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `competition_id` bigint(20) UNSIGNED NOT NULL,
  `registration_id` bigint(20) UNSIGNED NOT NULL,
  `judge_id` bigint(20) UNSIGNED NOT NULL,
  `assigned_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'draft',
  `notes` text DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `judge_scores`
--

CREATE TABLE `judge_scores` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `judge_assignment_id` bigint(20) UNSIGNED NOT NULL,
  `judging_criterion_id` bigint(20) UNSIGNED NOT NULL,
  `score` decimal(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `judging_criteria`
--

CREATE TABLE `judging_criteria` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `competition_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(160) NOT NULL,
  `description` text DEFAULT NULL,
  `max_score` decimal(8,2) NOT NULL DEFAULT 100.00,
  `sort_order` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_06_27_000001_create_event_management_tables', 1),
(5, '2026_06_27_000002_add_competition_format_and_members', 2),
(6, '2026_06_27_000003_add_participant_accounts', 3),
(7, '2026_06_27_000004_add_account_status', 4),
(8, '2026_06_27_000005_add_pic_capacity_and_whatsapp', 5),
(9, '2026_06_28_000006_add_team_officials', 6),
(10, '2026_06_28_000007_add_member_contacts', 7),
(11, '2026_06_28_000008_add_custom_roles', 8),
(12, '2026_06_28_000009_update_competition_categories', 9),
(13, '2026_06_28_000008_add_nisn_verification_to_registration_members', 10),
(14, '2026_06_28_000009_create_site_contents_table', 11),
(15, '2026_06_28_000010_rename_demo_accounts_for_kreasi_unm', 12),
(16, '2026_06_28_000011_add_payment_verification_to_registrations', 13),
(17, '2026_06_28_000012_add_guides_to_competitions', 14),
(18, '2026_06_28_000013_create_competition_notifications_table', 15),
(19, '2026_06_28_000014_add_work_submission_fields', 16),
(20, '2026_06_28_000015_add_school_location_to_registrations', 17),
(21, '2026_06_28_000016_create_judging_tables', 18),
(22, '2026_06_29_000017_create_tournament_drawing_tables', 19),
(23, '2026_06_29_000018_add_match_scheduling', 20),
(24, '2026_06_29_000019_add_staged_registration_fields', 21),
(25, '2026_06_29_000020_allow_document_slots_before_team_data', 22),
(26, '2026_06_29_000021_add_downloadable_documents_to_competitions', 23),
(27, '2026_06_30_000022_add_whatsapp_group_url_to_competitions', 24),
(28, '2026_06_30_000023_rename_nova_ticket_prefix_to_kreasi', 25);

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `registrations`
--

CREATE TABLE `registrations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `competition_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ticket_code` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `whatsapp` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `birth_place` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `grade` enum('X','XI','XII') DEFAULT NULL,
  `nisn` varchar(10) DEFAULT NULL,
  `mother_name` text DEFAULT NULL,
  `school_name` varchar(255) DEFAULT NULL,
  `school_city` varchar(120) DEFAULT NULL,
  `school_address` text DEFAULT NULL,
  `school_logo_path` varchar(255) DEFAULT NULL,
  `teacher_name` varchar(255) DEFAULT NULL,
  `teacher_contact` varchar(20) DEFAULT NULL,
  `school_code` varchar(255) DEFAULT NULL,
  `team_name` varchar(255) DEFAULT NULL,
  `participant_category` varchar(255) DEFAULT NULL,
  `student_card_path` varchar(255) DEFAULT NULL,
  `delegation_letter_path` varchar(255) DEFAULT NULL,
  `statement_letter_path` varchar(255) DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `payment_proof_path` varchar(255) DEFAULT NULL,
  `work_submission_url` text DEFAULT NULL,
  `work_submitted_at` timestamp NULL DEFAULT NULL,
  `work_verification_status` varchar(20) NOT NULL DEFAULT 'pending',
  `work_verification_note` text DEFAULT NULL,
  `work_verified_by` bigint(20) UNSIGNED DEFAULT NULL,
  `work_verified_at` timestamp NULL DEFAULT NULL,
  `consent` tinyint(1) NOT NULL DEFAULT 0,
  `team_completed_at` timestamp NULL DEFAULT NULL,
  `documents_completed_at` timestamp NULL DEFAULT NULL,
  `status` enum('pending','approved','rejected','revision') NOT NULL DEFAULT 'pending',
  `review_note` text DEFAULT NULL,
  `reviewed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `payment_verified_at` timestamp NULL DEFAULT NULL,
  `payment_verified_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `registrations`
--

INSERT INTO `registrations` (`id`, `competition_id`, `user_id`, `ticket_code`, `full_name`, `whatsapp`, `email`, `birth_place`, `birth_date`, `grade`, `nisn`, `mother_name`, `school_name`, `school_city`, `school_address`, `school_logo_path`, `teacher_name`, `teacher_contact`, `school_code`, `team_name`, `participant_category`, `student_card_path`, `delegation_letter_path`, `statement_letter_path`, `photo_path`, `payment_proof_path`, `work_submission_url`, `work_submitted_at`, `work_verification_status`, `work_verification_note`, `work_verified_by`, `work_verified_at`, `consent`, `team_completed_at`, `documents_completed_at`, `status`, `review_note`, `reviewed_by`, `reviewed_at`, `created_at`, `updated_at`, `payment_verified_at`, `payment_verified_by`) VALUES
(6, 5, 8, 'KREASI-03EM8CIC', 'Syaifur Rahmatullah', '081283485854', 'syaifur.syl1@gmail.com', 'Jakarta', '2026-05-31', 'XII', '1234569104', 'eyJpdiI6ImpFcTYwaVgrZnFTNlVoUzRLVDdMdnc9PSIsInZhbHVlIjoiQ28rTkYwcWZrR3NWNTl1K0ROMG9lUT09IiwibWFjIjoiMTk0MzUzMmUyYzk3MjkzZGVkNmQxOWFmOGJmMjQ2MjIxZjBhN2ZkM2U4ZjNmM2UwYWU3MGVjZjc2OWM1OGNlOSIsInRhZyI6IiJ9', 'sma 38', NULL, NULL, NULL, 'ROFIKOH', '081288569851', '-', 'OKEOCE', NULL, 'registrations/5/1tBILrPxXbm2MSRAjHsrx2HymLm0v55UUVlum9hL.jpg', 'registrations/5/v73hoSwNSw5RRIUIPyXeKBcnWPRtIRpHKMk3p3Sw.jpg', NULL, 'registrations/5/Z1GZ3FFj6etuMij8qFrHijOey238bWpQ9OEzLgzS.jpg', 'registrations/5/8CeBILfuzQ59cFzkbaMyUER5wq5bnwUFwy5pZCee.jpg', NULL, NULL, 'pending', NULL, NULL, NULL, 1, NULL, NULL, 'revision', 'aaaa', 1, '2026-06-28 20:54:46', '2026-06-27 18:41:52', '2026-06-28 20:54:46', NULL, NULL),
(7, 6, 9, 'KREASI-KN6CFGZB', 'Syaifur Rahmatullah', '081282750318', 'syaifur1.syl@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'pending', NULL, NULL, NULL, 1, NULL, NULL, 'pending', NULL, NULL, NULL, '2026-06-29 00:27:45', '2026-06-29 00:27:45', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `registration_members`
--

CREATE TABLE `registration_members` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `registration_id` bigint(20) UNSIGNED NOT NULL,
  `competition_id` bigint(20) UNSIGNED NOT NULL,
  `member_order` tinyint(3) UNSIGNED NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `whatsapp` varchar(20) DEFAULT NULL,
  `nisn` varchar(10) DEFAULT NULL,
  `birth_place` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `grade` enum('X','XI','XII') DEFAULT NULL,
  `mother_name` text DEFAULT NULL,
  `student_card_path` varchar(255) DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `nisn_verified_at` timestamp NULL DEFAULT NULL,
  `nisn_verified_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `registration_members`
--

INSERT INTO `registration_members` (`id`, `registration_id`, `competition_id`, `member_order`, `full_name`, `email`, `whatsapp`, `nisn`, `birth_place`, `birth_date`, `grade`, `mother_name`, `student_card_path`, `photo_path`, `created_at`, `updated_at`, `nisn_verified_at`, `nisn_verified_by`) VALUES
(4, 6, 5, 1, 'Syaifur Rahmatullah', 'syaifur.syl1@gmail.com', '081283485854', '1234569104', 'Jakarta', '2026-05-31', 'XII', 'eyJpdiI6IkNtQnhPN2ZrdEZzbzlCRHI2SHpOWFE9PSIsInZhbHVlIjoiNXk2eUVaZGxvSnFWVzV6QjVxTVVqUT09IiwibWFjIjoiZWZlZWM3MTg2MDhhMDg2NTM4NDMyNmMwMzcxYjRiYzEzOGY4OTA4ODA3ZTg2NDM5YTU3ZWQ2OGM3NjAzZWE4MCIsInRhZyI6IiJ9', 'registrations/5/1tBILrPxXbm2MSRAjHsrx2HymLm0v55UUVlum9hL.jpg', 'registrations/5/Z1GZ3FFj6etuMij8qFrHijOey238bWpQ9OEzLgzS.jpg', '2026-06-27 18:41:52', '2026-06-28 20:48:09', '2026-06-28 20:48:09', 1),
(5, 6, 5, 2, 'Zafran', 'syaifur1.syl@gmail.com', '081283485855', '1234569105', 'Jakarta', '2026-06-01', 'XII', 'eyJpdiI6InZhbDgwaGRmQkZpVThuRTVQdU9VRHc9PSIsInZhbHVlIjoibUhSeXJTNDU5OG1EcWdWajJuVzhMdz09IiwibWFjIjoiYzliOWZiMjc1NjJiZjVmZDhiOWZhNjMzODQ4ODBiM2VmNTVhMGFmNmU5NjQ2NjQ4MGE4MTc3YTIyZTE3OGQxMiIsInRhZyI6IiJ9', 'registrations/5/members/0hwOC3a0VL4wzyAnBH4A6r1noOE87fUfOxvhQJoI.jpg', 'registrations/5/members/koXZZ4o9de8EMhCDCLZGY24C1kBy9zxyTpANmuQC.jpg', '2026-06-27 18:41:52', '2026-06-28 06:59:19', NULL, NULL),
(6, 6, 5, 3, 'rayya', 'syaifur2.syl@gmail.com', '081283485856', '1234569107', 'Jakarta', '2026-06-07', 'XII', 'eyJpdiI6IlIrdys0MzFwMGo2V1p3bEZFM0ErUEE9PSIsInZhbHVlIjoiaEF3UXJpK1JOMmJYYnp1aDNlWndqQT09IiwibWFjIjoiZTUyMWU2ZmE0ZDM1NDQ3NTMwNGJlNzcwNWEzZWNjMTk3ZDQ0Yzg2NjI3MWU2NTQzOTdjY2M0OTAyNDAzZWIxOSIsInRhZyI6IiJ9', 'registrations/5/members/VxlJUHij47CsohFqYNqgAvQjyOVYCvBcQKSboQaJ.jpg', 'registrations/5/members/9JsBOP8b1IDQaKVq7Mfqxe2Wb6AQxq2GM9s1Cg7L.jpg', '2026-06-27 18:41:52', '2026-06-28 06:59:19', NULL, NULL),
(7, 7, 6, 1, 'Syaifur Rahmatullah', 'syaifur1.syl@gmail.com', '081282750318', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-29 00:27:45', '2026-06-29 00:27:45', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `registration_officials`
--

CREATE TABLE `registration_officials` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `registration_id` bigint(20) UNSIGNED NOT NULL,
  `official_order` tinyint(3) UNSIGNED NOT NULL,
  `full_name` varchar(120) NOT NULL,
  `position` varchar(80) NOT NULL,
  `whatsapp` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `registration_officials`
--

INSERT INTO `registration_officials` (`id`, `registration_id`, `official_order`, `full_name`, `position`, `whatsapp`, `created_at`, `updated_at`) VALUES
(1, 6, 1, 'rohisetiawan', 'Pelatih', '081283243583', '2026-06-27 18:41:52', '2026-06-27 18:41:52');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('E0jtHfyIZ1bljcjm7k0vCRL6Ol6bAcm8RZG8kxAz', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.6899', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSEZYSmxHb25wRmdNRnlvUXVUQWFkajc5TFZyT2s0ejdZMGMwbk1kbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782780995),
('eLnThYkWGVXsx5zFeh4zLf3kFF9OkAnKc5xsLXNx', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.6899', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSWoxalJNbDJ6UmFsaWZ6M3V0M3BkR0pQNk5yUWhURnJGdW5KMTBVUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782625482),
('n6e1qk4Ev7rfgbtKW4Jbw2NL5d3Ykk2yVpHipPmU', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.6899', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMGhPdjFhQVVPUjhRMjhlaTFyYlM5YUhxQ0g4a1VMekcxSWRMZVg1NiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782625940),
('nAdUqrpv51eqcVPjEvnk6X06qu7kffNxLbsDxLKC', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.6899', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ3ZEaVBSdTZvOGhxcEJBdUdNVTBVZTQ5RnJiWjB0aDFndGtKc1pZSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782629800),
('uiJ3jN9iw0nih2qxh6JS0GMeeGA2tZtfJD3XhAsE', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.126.0 Chrome/148.0.7778.97 Electron/42.2.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWURwREkyYnFrRUJOZHdoR0x0clVKOGw3WXFKYkdCVkJKS1VWUXRITyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782625219),
('WeNpmSWewx5BiMDCWDCcb1olIQWm3z0PKPuVwjwf', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.6899', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidzNCM1pvNVpkTlFwT1hNYkxKcUdVMFpxcUFzdHNFT1FsYjhvQ3NaVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782625210);

-- --------------------------------------------------------

--
-- Struktur dari tabel `site_contents`
--

CREATE TABLE `site_contents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`content`)),
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `site_contents`
--

INSERT INTO `site_contents` (`id`, `key`, `content`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 'home_hero', '{\"badge\":\"Kompetisi Kreatifitas Siswa Indonesia\",\"title_primary\":\"KREASI UNM\",\"title_accent\":\"UNLEASH YOUR SPIRIT\",\"description\":\"perlombaan secara hybrid (online dan offline) berskala nasional antar siswa SLTA\\/sederajat dalam mendukung kreativitas dan sportivitas untuk berkontribusi mencetak generasi mandiri yang bertalenta digital untuk Indonesia yang lebih baik\",\"primary_button_label\":\"Temukan Lomba\",\"primary_button_url\":\"\\/lomba\",\"secondary_button_label\":\"Login\",\"secondary_button_url\":\"\\/login\",\"hashtag\":\"#KREASIUNM2026\",\"slide_interval\":\"5\",\"slides\":[{\"image_url\":\"https:\\/\\/res.cloudinary.com\\/di1ec1jxv\\/image\\/upload\\/v1782639848\\/08eaac80-b149-43c2-8360-dae2c27bff5f_zjcbkd.png\",\"alt_text\":\"Padel Competition\"},{\"image_url\":\"https:\\/\\/res.cloudinary.com\\/di1ec1jxv\\/image\\/upload\\/v1782639756\\/37eddf5b-4559-4a63-b3d8-30f31bfe3713_cv6w60.png\",\"alt_text\":\"Futsal Competition\"}]}', 1, '2026-06-27 23:44:04', '2026-06-28 02:45:53'),
(2, 'landing_extras', '{\"activity_title\":\"Cerita dari kegiatan sebelumnya\",\"activity_description\":\"Lihat kembali semangat, karya, dan momen terbaik para peserta.\",\"activity_interval\":5,\"activity_slides\":[],\"sponsor_title\":\"Didukung oleh\",\"sponsors\":[],\"media_partner_title\":\"Media Partners\",\"media_partners\":[]}', 1, '2026-06-28 02:45:27', '2026-06-28 02:45:27');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tournament_draws`
--

CREATE TABLE `tournament_draws` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `competition_id` bigint(20) UNSIGNED NOT NULL,
  `operator_id` bigint(20) UNSIGNED DEFAULT NULL,
  `version` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `mode` varchar(20) NOT NULL,
  `format` varchar(40) NOT NULL,
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`settings`)),
  `status` varchar(20) NOT NULL DEFAULT 'draft',
  `drawn_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `locked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tournament_draw_entries`
--

CREATE TABLE `tournament_draw_entries` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tournament_draw_id` bigint(20) UNSIGNED NOT NULL,
  `registration_id` bigint(20) UNSIGNED DEFAULT NULL,
  `slot_number` int(10) UNSIGNED NOT NULL,
  `seed_number` int(10) UNSIGNED DEFAULT NULL,
  `group_name` varchar(20) DEFAULT NULL,
  `is_bye` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tournament_matches`
--

CREATE TABLE `tournament_matches` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tournament_draw_id` bigint(20) UNSIGNED NOT NULL,
  `stage` varchar(30) NOT NULL DEFAULT 'main',
  `round_number` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `round_label` varchar(80) NOT NULL,
  `match_number` int(10) UNSIGNED NOT NULL,
  `group_name` varchar(20) DEFAULT NULL,
  `participant_a_id` bigint(20) UNSIGNED DEFAULT NULL,
  `participant_b_id` bigint(20) UNSIGNED DEFAULT NULL,
  `source_a_match_id` bigint(20) UNSIGNED DEFAULT NULL,
  `source_a_outcome` varchar(10) DEFAULT NULL,
  `source_b_match_id` bigint(20) UNSIGNED DEFAULT NULL,
  `source_b_outcome` varchar(10) DEFAULT NULL,
  `score_a` decimal(8,2) DEFAULT NULL,
  `score_b` decimal(8,2) DEFAULT NULL,
  `winner_id` bigint(20) UNSIGNED DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `duration_minutes` smallint(5) UNSIGNED NOT NULL DEFAULT 60,
  `venue` varchar(160) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'scheduled',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tournament_schedule_blocks`
--

CREATE TABLE `tournament_schedule_blocks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `competition_id` bigint(20) UNSIGNED NOT NULL,
  `tournament_draw_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(120) NOT NULL,
  `venue` varchar(160) NOT NULL,
  `starts_at` datetime NOT NULL,
  `duration_minutes` smallint(5) UNSIGNED NOT NULL DEFAULT 60,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `whatsapp` varchar(20) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(80) NOT NULL DEFAULT 'participant',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `api_token` varchar(64) DEFAULT NULL,
  `competition_id` bigint(20) UNSIGNED DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `whatsapp`, `email_verified_at`, `password`, `role`, `is_active`, `api_token`, `competition_id`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', 'admin@kreasiunm.id', NULL, NULL, '$2y$12$2HnkSsRuGC.xV/V9pKE8XeIRcr.z127e1zmDyc9BxJoRWi8cE8Qoe', 'super_admin', 1, NULL, NULL, NULL, '2026-06-27 03:02:06', '2026-06-29 22:56:43'),
(2, 'Ade Kurniawan', 'pic@kreasiunm.id', '081234567890', NULL, '$2y$12$qajOzla6Lzz5FvPGdQxdT.HjgzcpXql4y9hW9zU7D2fpsI/187MCO', 'pic', 1, NULL, 5, NULL, '2026-06-27 03:02:06', '2026-06-28 07:14:21'),
(3, 'Perwakilan Basket QA', 'peserta.dashboard.qa@example.com', NULL, NULL, '$2y$12$..9RlOEOp5eF4VzvdGrtGefDNaEaQdtMqV8.hTYsARuip.ndb5b.q', 'participant', 1, '0fbba90f5a17c51aca10b7d2d2907c1a474c7043a31f1200637e537cf523fd52', NULL, NULL, '2026-06-27 03:44:23', '2026-06-27 03:44:37'),
(7, 'Syaifur Rahmatullah', 'syaifur.syl@bsi.ac.id', NULL, NULL, '$2y$12$N3WdKeCRopEmVPsXs6w22u2Kz928rJCJN8HLSGrPfW4bQ1DIZUtzW', 'participant', 1, NULL, NULL, NULL, '2026-06-27 04:58:24', '2026-06-27 05:00:43'),
(8, 'Syaifur Rahmatullah', 'syaifur.syl@gmail.com', NULL, NULL, '$2y$12$NyrlupVtleOde2VeediJjemRYgzGzflLShA.wNgk83v/4HfCMlWSq', 'participant', 1, NULL, NULL, NULL, '2026-06-27 18:41:52', '2026-06-28 21:13:18'),
(9, 'Syaifur Rahmatullah', 'syaifur1.syl@gmail.com', NULL, NULL, '$2y$12$ArKQcZv2S2zS.6Z1l8Lus.BcVjSlCjSQrZBD66dyvI0XpSkANwtle', 'participant', 1, NULL, NULL, NULL, '2026-06-29 00:27:45', '2026-06-29 01:13:10');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `access_roles`
--
ALTER TABLE `access_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `access_roles_slug_unique` (`slug`);

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `competitions`
--
ALTER TABLE `competitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `competitions_slug_unique` (`slug`);

--
-- Indeks untuk tabel `competition_notifications`
--
ALTER TABLE `competition_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `competition_notifications_competition_id_foreign` (`competition_id`),
  ADD KEY `competition_notifications_author_id_foreign` (`author_id`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `judge_assignments`
--
ALTER TABLE `judge_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `judge_assignments_registration_id_judge_id_unique` (`registration_id`,`judge_id`),
  ADD KEY `judge_assignments_competition_id_foreign` (`competition_id`),
  ADD KEY `judge_assignments_judge_id_foreign` (`judge_id`),
  ADD KEY `judge_assignments_assigned_by_foreign` (`assigned_by`);

--
-- Indeks untuk tabel `judge_scores`
--
ALTER TABLE `judge_scores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `judge_scores_judge_assignment_id_judging_criterion_id_unique` (`judge_assignment_id`,`judging_criterion_id`),
  ADD KEY `judge_scores_judging_criterion_id_foreign` (`judging_criterion_id`);

--
-- Indeks untuk tabel `judging_criteria`
--
ALTER TABLE `judging_criteria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `judging_criteria_competition_id_foreign` (`competition_id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `registrations`
--
ALTER TABLE `registrations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `registrations_competition_id_nisn_unique` (`competition_id`,`nisn`),
  ADD UNIQUE KEY `registrations_ticket_code_unique` (`ticket_code`),
  ADD KEY `registrations_reviewed_by_foreign` (`reviewed_by`),
  ADD KEY `registrations_competition_id_status_index` (`competition_id`,`status`),
  ADD KEY `registrations_user_id_status_index` (`user_id`,`status`),
  ADD KEY `registrations_payment_verified_by_foreign` (`payment_verified_by`),
  ADD KEY `registrations_work_verified_by_foreign` (`work_verified_by`);

--
-- Indeks untuk tabel `registration_members`
--
ALTER TABLE `registration_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `registration_members_competition_id_nisn_unique` (`competition_id`,`nisn`),
  ADD UNIQUE KEY `registration_members_registration_id_member_order_unique` (`registration_id`,`member_order`),
  ADD KEY `registration_members_nisn_verified_by_foreign` (`nisn_verified_by`);

--
-- Indeks untuk tabel `registration_officials`
--
ALTER TABLE `registration_officials`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `registration_officials_registration_id_official_order_unique` (`registration_id`,`official_order`);

--
-- Indeks untuk tabel `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indeks untuk tabel `site_contents`
--
ALTER TABLE `site_contents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_contents_key_unique` (`key`),
  ADD KEY `site_contents_updated_by_foreign` (`updated_by`);

--
-- Indeks untuk tabel `tournament_draws`
--
ALTER TABLE `tournament_draws`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tournament_draws_competition_id_version_unique` (`competition_id`,`version`),
  ADD KEY `tournament_draws_operator_id_foreign` (`operator_id`);

--
-- Indeks untuk tabel `tournament_draw_entries`
--
ALTER TABLE `tournament_draw_entries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tournament_draw_entries_tournament_draw_id_slot_number_unique` (`tournament_draw_id`,`slot_number`),
  ADD KEY `tournament_draw_entries_registration_id_foreign` (`registration_id`);

--
-- Indeks untuk tabel `tournament_matches`
--
ALTER TABLE `tournament_matches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tournament_matches_tournament_draw_id_match_number_unique` (`tournament_draw_id`,`match_number`),
  ADD KEY `tournament_matches_participant_a_id_foreign` (`participant_a_id`),
  ADD KEY `tournament_matches_participant_b_id_foreign` (`participant_b_id`),
  ADD KEY `tournament_matches_source_a_match_id_foreign` (`source_a_match_id`),
  ADD KEY `tournament_matches_source_b_match_id_foreign` (`source_b_match_id`),
  ADD KEY `tournament_matches_winner_id_foreign` (`winner_id`);

--
-- Indeks untuk tabel `tournament_schedule_blocks`
--
ALTER TABLE `tournament_schedule_blocks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tournament_schedule_blocks_competition_id_foreign` (`competition_id`),
  ADD KEY `tournament_schedule_blocks_tournament_draw_id_foreign` (`tournament_draw_id`),
  ADD KEY `tournament_schedule_blocks_created_by_foreign` (`created_by`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_api_token_unique` (`api_token`),
  ADD KEY `users_competition_id_foreign` (`competition_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `access_roles`
--
ALTER TABLE `access_roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `competitions`
--
ALTER TABLE `competitions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `competition_notifications`
--
ALTER TABLE `competition_notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `judge_assignments`
--
ALTER TABLE `judge_assignments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `judge_scores`
--
ALTER TABLE `judge_scores`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `judging_criteria`
--
ALTER TABLE `judging_criteria`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT untuk tabel `registrations`
--
ALTER TABLE `registrations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `registration_members`
--
ALTER TABLE `registration_members`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `registration_officials`
--
ALTER TABLE `registration_officials`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `site_contents`
--
ALTER TABLE `site_contents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `tournament_draws`
--
ALTER TABLE `tournament_draws`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `tournament_draw_entries`
--
ALTER TABLE `tournament_draw_entries`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `tournament_matches`
--
ALTER TABLE `tournament_matches`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `tournament_schedule_blocks`
--
ALTER TABLE `tournament_schedule_blocks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `competition_notifications`
--
ALTER TABLE `competition_notifications`
  ADD CONSTRAINT `competition_notifications_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `competition_notifications_competition_id_foreign` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `judge_assignments`
--
ALTER TABLE `judge_assignments`
  ADD CONSTRAINT `judge_assignments_assigned_by_foreign` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `judge_assignments_competition_id_foreign` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `judge_assignments_judge_id_foreign` FOREIGN KEY (`judge_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `judge_assignments_registration_id_foreign` FOREIGN KEY (`registration_id`) REFERENCES `registrations` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `judge_scores`
--
ALTER TABLE `judge_scores`
  ADD CONSTRAINT `judge_scores_judge_assignment_id_foreign` FOREIGN KEY (`judge_assignment_id`) REFERENCES `judge_assignments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `judge_scores_judging_criterion_id_foreign` FOREIGN KEY (`judging_criterion_id`) REFERENCES `judging_criteria` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `judging_criteria`
--
ALTER TABLE `judging_criteria`
  ADD CONSTRAINT `judging_criteria_competition_id_foreign` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `registrations`
--
ALTER TABLE `registrations`
  ADD CONSTRAINT `registrations_competition_id_foreign` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `registrations_payment_verified_by_foreign` FOREIGN KEY (`payment_verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `registrations_reviewed_by_foreign` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `registrations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `registrations_work_verified_by_foreign` FOREIGN KEY (`work_verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `registration_members`
--
ALTER TABLE `registration_members`
  ADD CONSTRAINT `registration_members_competition_id_foreign` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `registration_members_nisn_verified_by_foreign` FOREIGN KEY (`nisn_verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `registration_members_registration_id_foreign` FOREIGN KEY (`registration_id`) REFERENCES `registrations` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `registration_officials`
--
ALTER TABLE `registration_officials`
  ADD CONSTRAINT `registration_officials_registration_id_foreign` FOREIGN KEY (`registration_id`) REFERENCES `registrations` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `site_contents`
--
ALTER TABLE `site_contents`
  ADD CONSTRAINT `site_contents_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `tournament_draws`
--
ALTER TABLE `tournament_draws`
  ADD CONSTRAINT `tournament_draws_competition_id_foreign` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tournament_draws_operator_id_foreign` FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `tournament_draw_entries`
--
ALTER TABLE `tournament_draw_entries`
  ADD CONSTRAINT `tournament_draw_entries_registration_id_foreign` FOREIGN KEY (`registration_id`) REFERENCES `registrations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tournament_draw_entries_tournament_draw_id_foreign` FOREIGN KEY (`tournament_draw_id`) REFERENCES `tournament_draws` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `tournament_matches`
--
ALTER TABLE `tournament_matches`
  ADD CONSTRAINT `tournament_matches_participant_a_id_foreign` FOREIGN KEY (`participant_a_id`) REFERENCES `registrations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tournament_matches_participant_b_id_foreign` FOREIGN KEY (`participant_b_id`) REFERENCES `registrations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tournament_matches_source_a_match_id_foreign` FOREIGN KEY (`source_a_match_id`) REFERENCES `tournament_matches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tournament_matches_source_b_match_id_foreign` FOREIGN KEY (`source_b_match_id`) REFERENCES `tournament_matches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tournament_matches_tournament_draw_id_foreign` FOREIGN KEY (`tournament_draw_id`) REFERENCES `tournament_draws` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tournament_matches_winner_id_foreign` FOREIGN KEY (`winner_id`) REFERENCES `registrations` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `tournament_schedule_blocks`
--
ALTER TABLE `tournament_schedule_blocks`
  ADD CONSTRAINT `tournament_schedule_blocks_competition_id_foreign` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tournament_schedule_blocks_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tournament_schedule_blocks_tournament_draw_id_foreign` FOREIGN KEY (`tournament_draw_id`) REFERENCES `tournament_draws` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_competition_id_foreign` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
