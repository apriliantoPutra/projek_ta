<?php

namespace App\Models\Master;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class LayananJemput extends Model
{
    protected $table= 'layanan_jemput';
    protected $fillable = [
        'bank_sampah_id',
        'ongkir_per_jarak',
    ];

    /**
     * Get the bankSampah that owns the LayananJemput
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function bankSampah(): BelongsTo
    {
        return $this->belongsTo(BankSampah::class, 'bank_sampah_id');
    }
}
