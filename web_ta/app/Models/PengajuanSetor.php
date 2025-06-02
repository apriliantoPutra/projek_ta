<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PengajuanSetor extends Model
{
    protected $table= 'pengajuan_setor';
    protected $fillable = [
        'warga_id',
        'jenis_setor',
        'waktu_pengajuan',
        'status_pengajuan',
        'catatan_petugas',
    ];
}
