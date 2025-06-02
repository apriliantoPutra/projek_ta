<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DetailSetor extends Model
{
    protected $table= 'detail_setor';
    protected $fillable = [
        'pengajuan_id',
        'petugas_id',
        'setoran_sampah',
        'total_berat',
        'total_harga',
        'status_setor',
    ];
}
