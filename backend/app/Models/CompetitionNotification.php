<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CompetitionNotification extends Model
{
    protected $guarded = [];

    protected function casts(): array
    {
        return ['published_at' => 'datetime'];
    }

    public function competition() { return $this->belongsTo(Competition::class); }
    public function author() { return $this->belongsTo(User::class, 'author_id'); }
}
