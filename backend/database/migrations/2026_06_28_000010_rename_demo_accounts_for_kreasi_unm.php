<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration {
    public function up(): void
    {
        $this->renameEmail('admin@novaarena.id', 'admin@kreasiunm.id');
        $this->renameEmail('pic@novaarena.id', 'pic@kreasiunm.id');
    }

    public function down(): void
    {
        $this->renameEmail('admin@kreasiunm.id', 'admin@novaarena.id');
        $this->renameEmail('pic@kreasiunm.id', 'pic@novaarena.id');
    }

    private function renameEmail(string $from, string $to): void
    {
        if (DB::table('users')->where('email', $from)->exists() && !DB::table('users')->where('email', $to)->exists()) {
            DB::table('users')->where('email', $from)->update(['email'=>$to, 'updated_at'=>now()]);
        }
    }
};
