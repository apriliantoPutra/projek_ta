<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class InputDetailSetor extends Model
{
    protected $fillable = [
        'pengajuan_id',
        'petugas_id',
        'setoran_sampah',
        'total_berat',
        'total_harga',
        'status_setor',
    ];
}
