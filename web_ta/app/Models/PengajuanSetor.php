<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

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

    /**
     * Get the inputdetail associated with the PengajuanSetor
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function inputdetail(): HasOne
    {
        return $this->hasOne(InputDetailSetor::class, 'pengajuan_id', 'id');
    }

    /**
     * Get the user that owns the PengajuanSetor
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'warga_id');
    }


}
