<?php

namespace App\Models\Master;

use Illuminate\Database\Eloquent\Model;

class JenisSampah extends Model
{
    protected $table= 'jenis_sampah';
    protected $fillable = [
        'nama_sampah',
        'satuan',
        'harga_per_satuan',
        'warna_indikasi',
    ];
}
