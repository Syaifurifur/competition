<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Competition;
use App\Models\AccessRole;
use App\Models\Registration;
use App\Models\RegistrationMember;
use App\Models\User;
use App\Services\RegistrationExcelExporter;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class ManagementController extends Controller
{
    private function scopeCompetitions(Request $request)
    {
        return $request->user()->role === 'super_admin' || $request->user()->hasPermission('competitions.manage')
            ? Competition::query()
            : Competition::whereKey($request->user()->competition_id);
    }

    public function dashboard(Request $request)
    {
        $competitionIds = $this->scopeCompetitions($request)->pluck('id');
        $regs = Registration::whereIn('competition_id', $competitionIds);
        return [
            'competitions' => $competitionIds->count(), 'registrations' => (clone $regs)->count(),
            'pending' => (clone $regs)->where('status','pending')->count(),
            'approved' => (clone $regs)->where('status','approved')->count(),
            'revenue' => Registration::whereIn('competition_id', $competitionIds)->where('status','approved')->join('competitions','competitions.id','=','registrations.competition_id')->sum('competitions.fee'),
            'recent' => Registration::with('competition:id,title')->whereIn('competition_id',$competitionIds)->latest()->limit(6)->get(),
        ];
    }

    public function competitions(Request $request) { return $this->scopeCompetitions($request)->withCount(['registrations','pics'])->latest()->get(); }

    public function storeCompetition(Request $request) { return response()->json(Competition::create($this->competitionData($request)), 201); }

    public function updateCompetition(Request $request, Competition $competition)
    {
        abort_unless($this->scopeCompetitions($request)->whereKey($competition->id)->exists(), 403);
        $competition->update($this->competitionData($request, $competition)); return $competition;
    }

    public function destroyCompetition(Competition $competition) { $competition->delete(); return response()->noContent(); }

    public function updateGuides(Request $request, Competition $competition)
    {
        abort_unless($this->scopeCompetitions($request)->whereKey($competition->id)->exists(), 403);
        $data = $request->validate([
            'guides'=>'required|array|min:1|max:30',
            'guides.*.title'=>'required|string|max:150',
            'guides.*.content'=>'required|string|max:10000',
        ]);
        $competition->update(['guides'=>$data['guides'], 'requirements'=>[]]);

        return $competition->fresh();
    }

    public function updateDownloadableDocuments(Request $request, Competition $competition)
    {
        abort_unless($this->scopeCompetitions($request)->whereKey($competition->id)->exists(), 403);
        $data = $request->validate([
            'documents'=>'nullable|array|max:20',
            'documents.*.title'=>'required|string|max:150',
            'documents.*.description'=>'nullable|string|max:500',
            'documents.*.file_path'=>'nullable|string|max:1000',
            'documents.*.original_name'=>'nullable|string|max:255',
            'document_files'=>'nullable|array|max:20',
            'document_files.*'=>'nullable|file|mimes:pdf,doc,docx,xls,xlsx,jpg,jpeg,png,zip|max:10240',
        ]);

        $currentPaths = collect($competition->downloadable_documents ?? [])->pluck('file_path')->filter();
        $documents = [];
        foreach ($data['documents'] ?? [] as $index => $document) {
            $path = $document['file_path'] ?? null;
            $name = $document['original_name'] ?? null;
            if ($request->hasFile("document_files.$index")) {
                $file = $request->file("document_files.$index");
                $path = $file->store('competitions/'.$competition->id.'/downloads', 'public');
                $name = $file->getClientOriginalName();
            } elseif (! $path || ! $currentPaths->contains($path)) {
                return response()->json(['message'=>"Pilih file untuk dokumen ke-".($index + 1).'.'], 422);
            }
            $documents[] = [
                'title'=>$document['title'],
                'description'=>$document['description'] ?? '',
                'file_path'=>$path,
                'original_name'=>$name ?: basename($path),
            ];
        }

        $retainedPaths = collect($documents)->pluck('file_path');
        $currentPaths->diff($retainedPaths)->each(fn ($path) => Storage::disk('public')->delete($path));
        $competition->update(['downloadable_documents'=>$documents]);

        return $competition->fresh();
    }

    private function competitionData(Request $request, ?Competition $competition = null): array
    {
        $data = $request->validate([
            'title'=>'required|string|max:180','category'=>'required|in:Sport Competition,Talent Competition,Science Competition','short_description'=>'required|string|max:300',
            'description'=>'required|string','quota'=>'required|integer|min:1','fee'=>'required|numeric|min:0',
            'location'=>'required|string|max:180',
            'team_update_deadline_at'=>'nullable|date',
            'document_upload_deadline_at'=>'nullable|date',
            'submission_start_at'=>'nullable|date|required_with:submission_end_at',
            'submission_end_at'=>'nullable|date|required_with:submission_start_at|after:submission_start_at',
            'poster_url'=>'nullable|url|max:500','requirements'=>'nullable|array',
            'guides'=>'nullable|array|max:30',
            'guides.*.title'=>'required|string|max:150',
            'guides.*.content'=>'required|string|max:10000',
            'timeline'=>'required|array|min:1|max:30','timeline.*.label'=>'required|string|max:120',
            'timeline.*.type'=>'nullable|in:single,range',
            'timeline.*.date'=>'exclude_if:timeline.*.type,range|required_if:timeline.*.type,single|date',
            'timeline.*.start_date'=>'exclude_if:timeline.*.type,single|required_if:timeline.*.type,range|date',
            'timeline.*.end_date'=>'exclude_if:timeline.*.type,single|required_if:timeline.*.type,range|date|after_or_equal:timeline.*.start_date',
            'is_featured'=>'boolean',
            'participation_type'=>'required|in:individual,team','team_size'=>'required|integer|min:1|max:20',
            'official_count'=>'required|integer|min:0|max:20','pic_slots'=>'required|integer|min:1|max:10',
        ]);
        $data['team_size'] = $data['participation_type'] === 'individual' ? 1 : $data['team_size'];
        $data['official_count'] = $data['participation_type'] === 'individual' ? 0 : $data['official_count'];
        if ($data['category'] === 'Sport Competition') {
            $data['submission_start_at'] = null;
            $data['submission_end_at'] = null;
        }
        $timeline = collect($data['timeline'])->map(function ($entry) {
            $type = $entry['type'] ?? 'single';
            return $type === 'range'
                ? ['label'=>$entry['label'],'type'=>'range','start_date'=>$entry['start_date'],'end_date'=>$entry['end_date'],'date'=>$entry['start_date'].'|'.$entry['end_date']]
                : ['label'=>$entry['label'],'type'=>'single','date'=>$entry['date']];
        })->sortBy(fn ($entry) => $entry['type'] === 'range' ? $entry['start_date'] : $entry['date'])->values();
        $data['timeline'] = $timeline->all();
        $data['registration_start'] = $timeline->map(fn ($entry) => $entry['type'] === 'range' ? $entry['start_date'] : $entry['date'])->min();
        $lastDate = $timeline->map(fn ($entry) => $entry['type'] === 'range' ? $entry['end_date'] : $entry['date'])->max();
        $data['registration_end'] = $lastDate;
        $data['event_date'] = $lastDate;
        $fallbackDeadline = \Carbon\Carbon::parse($lastDate, 'Asia/Jakarta')->endOfDay()->utc();
        $data['team_update_deadline_at'] = $data['team_update_deadline_at'] ?? $fallbackDeadline;
        $data['document_upload_deadline_at'] = $data['document_upload_deadline_at'] ?? $fallbackDeadline;
        $data['slug'] = Str::slug($data['title']).($competition ? '' : '-'.strtolower(Str::random(4)));
        return $data;
    }

    public function pics() { return User::where('role','pic')->with('competition:id,title')->latest()->get(); }
    public function storePic(Request $request)
    {
        $data=$request->validate(['name'=>'required|string|max:120','email'=>'required|email|unique:users,email','whatsapp'=>['required','regex:/^[0-9+]{10,15}$/'],'password'=>'required|string|min:8','competition_id'=>'required|exists:competitions,id']);
        $competition=Competition::findOrFail($data['competition_id']);
        if($competition->pics()->count()>=$competition->pic_slots)return response()->json(['message'=>'Slot PIC pada lomba ini sudah penuh.'],422);
        $data['role']='pic'; return response()->json(User::create($data),201);
    }
    public function updatePic(Request $request, User $user)
    {
        $data=$request->validate(['name'=>'required|string|max:120','email'=>'required|email|unique:users,email,'.$user->id,'whatsapp'=>['required','regex:/^[0-9+]{10,15}$/'],'password'=>'nullable|string|min:8','competition_id'=>'required|exists:competitions,id']);
        $competition=Competition::findOrFail($data['competition_id']);
        if($competition->pics()->where('id','!=',$user->id)->count()>=$competition->pic_slots)return response()->json(['message'=>'Slot PIC pada lomba ini sudah penuh.'],422);
        if(empty($data['password'])) unset($data['password']); $user->update($data); return $user;
    }
    public function destroyPic(User $user) { abort_if($user->role !== 'pic',422); $user->delete(); return response()->noContent(); }

    public function accounts(Request $request)
    {
        $query=User::with('competition:id,title')->withCount('registrations');
        if($request->filled('role')&&$request->role!=='all')$query->where('role',$request->role);
        if($request->filled('search'))$query->where(fn($q)=>$q->where('name','like','%'.$request->search.'%')->orWhere('email','like','%'.$request->search.'%'));
        return $query->latest()->paginate(20);
    }

    public function storeAccount(Request $request)
    {
        $data=$request->validate([
            'name'=>'required|string|max:120','email'=>'required|email|unique:users,email','whatsapp'=>['nullable','regex:/^[0-9+]{10,15}$/'],'password'=>'required|string|min:8',
            'role'=>['required',Rule::in(array_merge(['super_admin','pic','judge','participant'],AccessRole::pluck('slug')->all()))],'competition_id'=>'nullable|exists:competitions,id','is_active'=>'boolean',
        ]);
        if($data['role']==='pic'&&empty($data['whatsapp']))return response()->json(['message'=>'Nomor WhatsApp aktif wajib diisi untuk PIC.'],422);
        if($data['role']==='pic'&&!empty($data['competition_id'])&&Competition::find($data['competition_id'])->pics()->count()>=Competition::find($data['competition_id'])->pic_slots)return response()->json(['message'=>'Slot PIC pada lomba ini sudah penuh.'],422);
        if(in_array($data['role'],['super_admin','judge','participant'],true))$data['competition_id']=null;
        return response()->json(User::create($data),201);
    }

    public function updateAccount(Request $request, User $user)
    {
        $data=$request->validate([
            'name'=>'required|string|max:120','email'=>'required|email|unique:users,email,'.$user->id,'whatsapp'=>['nullable','regex:/^[0-9+]{10,15}$/'],'password'=>'nullable|string|min:8',
            'role'=>['required',Rule::in(array_merge(['super_admin','pic','judge','participant'],AccessRole::pluck('slug')->all()))],'competition_id'=>'nullable|exists:competitions,id','is_active'=>'required|boolean',
        ]);
        if($user->id===$request->user()->id&&($data['role']!=='super_admin'||!$data['is_active']))return response()->json(['message'=>'Anda tidak dapat menurunkan role atau menonaktifkan akun sendiri.'],422);
        if($data['role']==='pic'&&empty($data['whatsapp']))return response()->json(['message'=>'Nomor WhatsApp aktif wajib diisi untuk PIC.'],422);
        if($data['role']==='pic'&&!empty($data['competition_id'])&&Competition::find($data['competition_id'])->pics()->where('id','!=',$user->id)->count()>=Competition::find($data['competition_id'])->pic_slots)return response()->json(['message'=>'Slot PIC pada lomba ini sudah penuh.'],422);
        if(in_array($data['role'],['super_admin','judge','participant'],true))$data['competition_id']=null;
        if(empty($data['password']))unset($data['password']);
        $user->update($data);
        return $user->fresh('competition:id,title');
    }

    public function destroyAccount(Request $request, User $user)
    {
        if($user->id===$request->user()->id)return response()->json(['message'=>'Akun yang sedang digunakan tidak dapat dihapus.'],422);
        if($user->registrations()->exists())return response()->json(['message'=>'Akun peserta yang memiliki pendaftaran tidak dapat dihapus. Nonaktifkan akun sebagai gantinya.'],422);
        $user->delete(); return response()->noContent();
    }

    public function competitionPics(Competition $competition)
    {
        return ['competition'=>$competition->load('pics:id,name,email,whatsapp,competition_id'),'available'=>User::where('role','pic')->where('is_active',true)->orderBy('name')->get(['id','name','email','whatsapp','competition_id'])];
    }

    public function assignCompetitionPics(Request $request, Competition $competition)
    {
        $data=$request->validate(['pic_ids'=>'array|max:'.$competition->pic_slots,'pic_ids.*'=>'integer|exists:users,id']);
        $ids=collect($data['pic_ids']??[])->unique();
        $pics=User::whereIn('id',$ids)->get();
        if($pics->contains(fn($pic)=>$pic->role!=='pic'||!$pic->is_active||empty($pic->whatsapp)))return response()->json(['message'=>'Semua akun terpilih harus merupakan PIC aktif dengan nomor WhatsApp.'],422);
        User::where('competition_id',$competition->id)->where('role','pic')->whereNotIn('id',$ids)->update(['competition_id'=>null]);
        User::whereIn('id',$ids)->update(['competition_id'=>$competition->id]);
        return $competition->fresh()->load('pics:id,name,email,whatsapp,competition_id');
    }

    public function registrations(Request $request)
    {
        $request->validate(['competition_id'=>'nullable|integer|exists:competitions,id']);
        $ids=$this->scopeCompetitions($request)->pluck('id');
        $q=Registration::with('competition:id,title,category')->whereIn('competition_id',$ids);
        if($request->filled('status')&&$request->status!=='all')$q->where('status',$request->status);
        if($request->filled('competition_id'))$q->where('competition_id',$request->integer('competition_id'));
        if($request->filled('search'))$q->where(fn($x)=>$x->where('full_name','like','%'.$request->search.'%')->orWhere('team_name','like','%'.$request->search.'%')->orWhere('ticket_code','like','%'.$request->search.'%')->orWhere('school_name','like','%'.$request->search.'%'));
        return $q->latest()->paginate(20);
    }

    public function registrationCompetitions(Request $request)
    {
        return $this->scopeCompetitions($request)->orderBy('title')->get(['id','title']);
    }

    public function registration(Request $request, Registration $registration)
    {
        abort_unless($this->scopeCompetitions($request)->whereKey($registration->competition_id)->exists(),403);
        $registration->load('competition:id,title,category,participation_type,team_size,official_count,fee,submission_start_at,submission_end_at,team_update_deadline_at,document_upload_deadline_at', 'members', 'officials');
        if ($registration->competition->participation_type === 'team' && $registration->members->isEmpty()) {
            $registration->setRelation('members', collect([new RegistrationMember([
                'id'=>0, 'member_order'=>1, 'full_name'=>$registration->full_name, 'nisn'=>$registration->nisn,
                'email'=>$registration->email, 'whatsapp'=>$registration->whatsapp,
                'birth_place'=>$registration->birth_place, 'birth_date'=>$registration->birth_date,
                'grade'=>$registration->grade, 'mother_name'=>$registration->mother_name,
                'student_card_path'=>$registration->student_card_path, 'photo_path'=>$registration->photo_path,
            ])]));
        }
        if($request->user()->hasPermission('registrations.review')) {
            $registration->makeVisible('mother_name');
            $registration->members->each->makeVisible('mother_name');
        }
        return $registration;
    }

    public function destroyRegistration(Request $request, Registration $registration)
    {
        abort_unless($request->user()->role==='super_admin',403);
        $registration->delete();
        return response()->noContent();
    }

    public function updateFormat(Request $request, Competition $competition)
    {
        abort_unless($this->scopeCompetitions($request)->whereKey($competition->id)->exists(), 403);
        $data = $request->validate([
            'participation_type'=>'required|in:individual,team','team_size'=>'required|integer|min:1|max:20',
            'official_count'=>'required|integer|min:0|max:20',
        ]);
        $data['team_size'] = $data['participation_type'] === 'individual' ? 1 : $data['team_size'];
        $data['official_count'] = $data['participation_type'] === 'individual' ? 0 : $data['official_count'];
        if ($competition->registrations()->exists() && ($competition->participation_type !== $data['participation_type'] || $competition->team_size !== $data['team_size'] || $competition->official_count !== $data['official_count'])) {
            return response()->json(['message'=>'Format tidak dapat diubah karena lomba sudah memiliki pendaftar.'], 422);
        }
        $competition->update($data);
        return $competition;
    }

    public function review(Request $request, Registration $registration)
    {
        abort_unless($this->scopeCompetitions($request)->whereKey($registration->competition_id)->exists(),403);
        $data=$request->validate(['status'=>'required|in:approved,rejected,revision','review_note'=>'nullable|string|max:1000']);
        if(in_array($data['status'],['rejected','revision']) && empty($data['review_note'])) return response()->json(['message'=>'Catatan wajib diisi untuk penolakan atau revisi.'],422);
        if($data['status']==='approved' && (!$registration->team_completed_at || !$registration->documents_completed_at)) return response()->json(['message'=>'Data peserta dan seluruh dokumen wajib dilengkapi sebelum pendaftaran dapat diterima.'],422);
        if($data['status']==='approved' && (float) $registration->competition->fee > 0 && !$registration->payment_verified_at) return response()->json(['message'=>'Bukti pembayaran harus diperiksa dan ditandai valid sebelum peserta diterima.'],422);
        $registration->update($data+['reviewed_by'=>$request->user()->id,'reviewed_at'=>now()]); return $registration;
    }

    public function verifyPayment(Request $request, Registration $registration)
    {
        abort_unless($this->scopeCompetitions($request)->whereKey($registration->competition_id)->exists(), 403);
        $data = $request->validate(['is_valid'=>'required|boolean']);
        if ($data['is_valid'] && !$registration->payment_proof_path) {
            return response()->json(['message'=>'Peserta belum mengunggah bukti pembayaran.'], 422);
        }
        $registration->update($data['is_valid'] ? [
            'payment_verified_at'=>now(), 'payment_verified_by'=>$request->user()->id,
        ] : [
            'payment_verified_at'=>null, 'payment_verified_by'=>null,
        ]);
        return $registration->fresh();
    }

    public function verifyMemberNisn(Request $request, RegistrationMember $registrationMember)
    {
        abort_unless($this->scopeCompetitions($request)->whereKey($registrationMember->competition_id)->exists(), 403);
        $data = $request->validate(['is_valid' => 'required|boolean']);
        $registrationMember->update($data['is_valid'] ? [
            'nisn_verified_at' => now(),
            'nisn_verified_by' => $request->user()->id,
        ] : [
            'nisn_verified_at' => null,
            'nisn_verified_by' => null,
        ]);

        return $registrationMember->fresh();
    }

    public function export(Request $request, RegistrationExcelExporter $exporter)
    {
        $ids=$this->scopeCompetitions($request)->pluck('id');
        $rows=Registration::with(['competition:id,title,category,participation_type,team_size','officials'])->whereIn('competition_id',$ids)->where('status','approved')->get();
        $path=$exporter->create($rows);
        return response()->download($path,'pendaftar-tervalidasi.xlsx',['Content-Type'=>'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'])->deleteFileAfterSend(true);
    }
}
