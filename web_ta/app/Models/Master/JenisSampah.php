<?php

namespace App\Models\Master;

use App\Models\TotalSampah;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;

class JenisSampah extends Model
{
    protected $table= 'jenis_sampah';
    protected $fillable = [
        'nama_sampah',
        'satuan',
        'harga_per_satuan',
        'warna_indikasi',
    ];
      protected $casts = [
        'harga_per_satuan' => 'integer',
    ];

    /**
     * Get the user associated with the JenisSampah
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function totalSampah(): HasOne
    {
        return $this->hasOne(TotalSampah::class, 'sampah_id', 'id');
    }
}
