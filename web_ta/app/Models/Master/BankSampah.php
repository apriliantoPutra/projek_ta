<?php

namespace App\Models\Master;

use Illuminate\Database\Eloquent\Model;

class BankSampah extends Model
{
    protected $table = 'bank_sampah';
    protected $fillable = [
        'nama_bank_sampah',
        'deskripsi_bank_sampah',
        'alamat_bank_sampah',
        'koordinat_bank_sampah',
    ];
}
