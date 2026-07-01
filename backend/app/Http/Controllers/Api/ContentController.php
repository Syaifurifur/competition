<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SiteContent;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;

class ContentController extends Controller
{
    private const KEY = 'home_hero';
    private const EXTRAS_KEY = 'landing_extras';
    private const CONSENT_KEY = 'data_consent';
    private const GENERAL_DOCUMENTS_KEY = 'general_documents';

    private const DEFAULT_CONTENT = [
        'badge' => 'Musim kompetisi 2026',
        'title_primary' => 'YOUR TALENT.',
        'title_accent' => 'YOUR ARENA.',
        'description' => 'Daftar sekali, lalu pantau verifikasi dan revisi data langsung dari dashboard peserta.',
        'primary_button_label' => 'Temukan Lomba',
        'primary_button_url' => '/lomba',
        'secondary_button_label' => 'Masuk Dashboard',
        'secondary_button_url' => '/login',
        'hashtag' => '#BERANIUNGGUL',
        'slide_interval' => 5,
        'slides' => [
            ['image_url'=>'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&w=1200&q=85','alt_text'=>'Kompetisi olahraga pelajar'],
            ['image_url'=>'https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=1200&q=85','alt_text'=>'Kompetisi sains pelajar'],
            ['image_url'=>'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&w=1200&q=85','alt_text'=>'Kompetisi seni pelajar'],
        ],
    ];

    private const DEFAULT_EXTRAS = [
        'activity_title' => 'Cerita dari kegiatan sebelumnya',
        'activity_description' => 'Lihat kembali semangat, karya, dan momen terbaik para peserta.',
        'activity_interval' => 5,
        'activity_slides' => [],
        'sponsor_title' => 'Didukung oleh',
        'sponsors' => [],
        'media_partner_title' => 'Media Partners',
        'media_partners' => [],
    ];

    private const DEFAULT_CONSENT = [
        'title' => 'Persetujuan penggunaan data',
        'checkbox_label' => 'Saya telah membaca rincian di atas dan menyetujui penggunaan data untuk pendaftaran dan verifikasi lomba.',
        'security_note' => 'Password akun tidak pernah ditampilkan kepada panitia. Data sensitif hanya digunakan oleh petugas yang berwenang untuk pemeriksaan pendaftaran.',
        'items' => [
            ['title'=>'Identitas peserta','description'=>'Nama, NISN, tempat/tanggal lahir, kelas, dan nama ibu kandung untuk verifikasi.'],
            ['title'=>'Kontak dan sekolah','description'=>'Email, WhatsApp, asal/alamat sekolah, serta data guru pendamping.'],
            ['title'=>'Data tim','description'=>'Biodata anggota dan official sesuai format lomba.'],
            ['title'=>'Dokumen','description'=>'Kartu pelajar, pas foto, logo sekolah, surat pernyataan, Surat Rekomendasi Sekolah, dan bukti pembayaran bila diwajibkan.'],
            ['title'=>'Proses verifikasi','description'=>'Status kelengkapan, validasi NISN, pembayaran, catatan panitia, dan keputusan pendaftaran.'],
        ],
    ];

    public function hero()
    {
        return SiteContent::where('key', self::KEY)->value('content') ?? self::DEFAULT_CONTENT;
    }

    public function manageHero()
    {
        return $this->hero();
    }

    public function landingExtras()
    {
        $content = array_replace(self::DEFAULT_EXTRAS, SiteContent::where('key', self::EXTRAS_KEY)->value('content') ?? []);
        $content['activity_slides'] = array_values(array_map(
            fn ($slide) => ['image_url'=>$slide['image_url'] ?? ''],
            $content['activity_slides'] ?? []
        ));

        return $content;
    }

    public function manageLandingExtras()
    {
        return $this->landingExtras();
    }

    public function dataConsent()
    {
        return array_replace(self::DEFAULT_CONSENT, SiteContent::where('key', self::CONSENT_KEY)->value('content') ?? []);
    }

    public function manageDataConsent()
    {
        return $this->dataConsent();
    }

    public function updateDataConsent(Request $request)
    {
        $data = $request->validate([
            'title'=>'required|string|max:150',
            'checkbox_label'=>'required|string|max:1000',
            'security_note'=>'required|string|max:1000',
            'items'=>'required|array|min:1|max:20',
            'items.*.title'=>'required|string|max:150',
            'items.*.description'=>'required|string|max:2000',
        ]);

        return SiteContent::updateOrCreate(['key'=>self::CONSENT_KEY], [
            'content'=>$data,
            'updated_by'=>$request->user()->id,
        ])->content;
    }

    public function generalDocuments()
    {
        return SiteContent::where('key', self::GENERAL_DOCUMENTS_KEY)->value('content') ?? ['documents'=>[]];
    }

    public function manageGeneralDocuments()
    {
        return $this->generalDocuments();
    }

    public function updateGeneralDocuments(Request $request)
    {
        $data = $request->validate([
            'documents'=>'nullable|array|max:20',
            'documents.*.title'=>'required|string|max:150',
            'documents.*.description'=>'nullable|string|max:500',
            'documents.*.file_path'=>'nullable|string|max:1000',
            'documents.*.original_name'=>'nullable|string|max:255',
            'document_files'=>'nullable|array|max:20',
            'document_files.*'=>'nullable|file|mimes:pdf,doc,docx,xls,xlsx,jpg,jpeg,png,zip|max:10240',
        ]);
        $current = $this->generalDocuments()['documents'] ?? [];
        $currentPaths = collect($current)->pluck('file_path')->filter();
        $documents = [];
        foreach ($data['documents'] ?? [] as $index => $document) {
            $path = $document['file_path'] ?? null;
            $name = $document['original_name'] ?? null;
            if ($request->hasFile("document_files.$index")) {
                $file = $request->file("document_files.$index");
                $path = $file->store('site-content/general-documents', 'public');
                $name = $file->getClientOriginalName();
            } elseif (! $path || ! $currentPaths->contains($path)) {
                return response()->json(['message'=>"Pilih file untuk dokumen ke-".($index + 1).'.'], 422);
            }
            $documents[] = [
                'title'=>$document['title'], 'description'=>$document['description'] ?? '',
                'file_path'=>$path, 'original_name'=>$name ?: basename($path),
            ];
        }
        $retained = collect($documents)->pluck('file_path');
        $currentPaths->diff($retained)->each(fn ($path) => Storage::disk('public')->delete($path));

        return SiteContent::updateOrCreate(['key'=>self::GENERAL_DOCUMENTS_KEY], [
            'content'=>['documents'=>$documents], 'updated_by'=>$request->user()->id,
        ])->content;
    }

    public function updateLandingExtras(Request $request)
    {
        $data = $request->validate([
            'activity_title'=>'required|string|max:120', 'activity_description'=>'required|string|max:500',
            'activity_interval'=>'required|integer|min:2|max:30', 'activity_slides'=>'sometimes|array|max:12',
            'activity_slides.*.image_url'=>['required','string','max:1000','regex:#^https?://#i'],
            'sponsor_title'=>'required|string|max:120', 'sponsors'=>'sometimes|array|max:20',
            'sponsors.*.name'=>'required|string|max:120', 'sponsors.*.logo_url'=>'nullable|string|max:1000',
            'sponsors.*.website_url'=>['nullable','string','max:1000','regex:#^https?://#i'],
            'sponsor_logos'=>'nullable|array|max:20', 'sponsor_logos.*'=>'nullable|image|mimes:jpg,jpeg,png,webp|max:5120',
            'media_partner_title'=>'required|string|max:120', 'media_partners'=>'sometimes|array|max:20',
            'media_partners.*.name'=>'required|string|max:120', 'media_partners.*.logo_url'=>'nullable|string|max:1000',
            'media_partners.*.website_url'=>['nullable','string','max:1000','regex:#^https?://#i'],
            'media_partner_logos'=>'nullable|array|max:20', 'media_partner_logos.*'=>'nullable|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        $activities = [];
        foreach ($data['activity_slides'] ?? [] as $index => $slide) {
            $activities[] = ['image_url'=>$slide['image_url']];
        }

        $sponsors = [];
        foreach ($data['sponsors'] ?? [] as $index => $sponsor) {
            $logoUrl = $sponsor['logo_url'] ?? null;
            if ($request->hasFile("sponsor_logos.$index")) {
                $logoUrl = '/storage/'.$request->file("sponsor_logos.$index")->store('site-content/sponsors', 'public');
            }
            if (!$logoUrl || !preg_match('#^(/|https?://)#', $logoUrl)) {
                throw ValidationException::withMessages(["sponsors.$index.logo_url"=>'Pilih file atau masukkan URL logo sponsor yang valid.']);
            }
            $sponsors[] = array_merge($sponsor, ['logo_url'=>$logoUrl]);
        }

        $mediaPartners = [];
        foreach ($data['media_partners'] ?? [] as $index => $partner) {
            $logoUrl = $partner['logo_url'] ?? null;
            if ($request->hasFile("media_partner_logos.$index")) {
                $logoUrl = '/storage/'.$request->file("media_partner_logos.$index")->store('site-content/media-partners', 'public');
            }
            if (!$logoUrl || !preg_match('#^(/|https?://)#', $logoUrl)) {
                throw ValidationException::withMessages(["media_partners.$index.logo_url"=>'Pilih file atau masukkan URL logo media partner yang valid.']);
            }
            $mediaPartners[] = array_merge($partner, ['logo_url'=>$logoUrl]);
        }

        $content = [
            'activity_title'=>$data['activity_title'], 'activity_description'=>$data['activity_description'],
            'activity_interval'=>(int) $data['activity_interval'], 'activity_slides'=>$activities,
            'sponsor_title'=>$data['sponsor_title'], 'sponsors'=>$sponsors,
            'media_partner_title'=>$data['media_partner_title'], 'media_partners'=>$mediaPartners,
        ];
        return SiteContent::updateOrCreate(['key'=>self::EXTRAS_KEY], [
            'content'=>$content, 'updated_by'=>$request->user()->id,
        ])->content;
    }

    public function updateHero(Request $request)
    {
        $data = $request->validate([
            'badge'=>'required|string|max:80', 'title_primary'=>'required|string|max:100',
            'title_accent'=>'required|string|max:100', 'description'=>'required|string|max:500',
            'primary_button_label'=>'required|string|max:50',
            'primary_button_url'=>['required','string','max:255','regex:#^(/|https?://)#'],
            'secondary_button_label'=>'required|string|max:50',
            'secondary_button_url'=>['required','string','max:255','regex:#^(/|https?://)#'],
            'hashtag'=>'required|string|max:50', 'slide_interval'=>'required|integer|min:2|max:30',
            'slides'=>'required|array|min:1|max:10', 'slides.*.image_url'=>'nullable|string|max:1000',
            'slides.*.alt_text'=>'required|string|max:150', 'slide_images'=>'nullable|array|max:10',
            'slide_images.*'=>'nullable|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        $slides = [];
        foreach ($data['slides'] as $index => $slide) {
            $imageUrl = $slide['image_url'] ?? null;
            if ($request->hasFile("slide_images.$index")) {
                $path = $request->file("slide_images.$index")->store('site-content/hero', 'public');
                $imageUrl = '/storage/'.$path;
            }
            if (!$imageUrl || !preg_match('#^(/|https?://)#', $imageUrl)) {
                throw ValidationException::withMessages(["slides.$index.image_url"=>'Pilih file gambar atau masukkan URL gambar yang valid.']);
            }
            $slides[] = ['image_url'=>$imageUrl, 'alt_text'=>$slide['alt_text']];
        }

        unset($data['slide_images']);
        $data['slides'] = $slides;
        $content = SiteContent::updateOrCreate(['key'=>self::KEY], [
            'content'=>$data,
            'updated_by'=>$request->user()->id,
        ]);

        return $content->content;
    }
}
