<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TarikSaldo extends Model
{
    protected $fillable = [
        'warga_id',
        'jumlah_saldo',
        'status',
        'metode',
        'nomor_tarik_saldo',
        'pesan'
    ];
    protected $casts = [
        'jumlah_saldo' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'warga_id');
    }
}
