<?php

namespace App\Models\Master;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;

class BankSampah extends Model
{
    protected $table = 'bank_sampah';
    protected $fillable = [
        'admin_id',
        'nama_bank_sampah',
        'deskripsi_bank_sampah',
        'alamat_bank_sampah',
        'koordinat_bank_sampah',
    ];
    // BankSampah.php
    public function user()
    {
        return $this->belongsTo(User::class, 'admin_id'); // bank_sampah.admin_id mengarah ke user.id
    }
}
