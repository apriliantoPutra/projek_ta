<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class InputDetailSetor extends Model
{
    protected $fillable = [
        'pengajuan_id',
        'petugas_id',
        'setoran_sampah',
        'koordinat_warga',
        'total_berat',
        'total_harga',
        'status_setor',
    ];
    
    protected $casts = [
        'total_berat' => 'float',
        'total_harga' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'petugas_id');
    }
}
