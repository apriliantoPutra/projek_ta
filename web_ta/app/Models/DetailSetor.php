<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class DetailSetor extends Model
{
    protected $table = 'detail_setor';
    protected $fillable = [
        'pengajuan_id',
        'petugas_id',
        'setoran_sampah',
        'total_berat',
        'total_harga',
        'status_setor',
    ];

    /**
     * The pengajuanPetugas that belong to the DetailSetor
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function pengajuanPetugas(): BelongsToMany
    {
        return $this->belongsToMany(PengajuanPetugas::class, 'detail_setoran_pengajuan_petugas', 'detail_setoran_id', 'pengajuan_petugas_id');
    }
}
