<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PenarikanSaldo extends Model
{
    protected $table = 'penarikan_saldo';
    protected $fillable = [
        'warga_id',
        'metode_penarikan',
        'jumlah_penarikan',
        'status_penarikan',
        'catatan_penarikan',
    ];
    protected $casts = [
        'jumlah_penarikan' => 'integer',
    ];
}
