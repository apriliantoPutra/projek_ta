<?php

namespace App\Models;

use App\Models\Master\JenisSampah;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PengajuanPetugas extends Model
{
    protected $table = 'pengajuan_petugas';
    protected $guarded = ['id'];
    /**
     * Get the jenisSampah that owns the PengajuanPetugas
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function jenisSampah(): BelongsTo
    {
        return $this->belongsTo(JenisSampah::class, 'jenis_sampah_id', 'id');
    }
}
