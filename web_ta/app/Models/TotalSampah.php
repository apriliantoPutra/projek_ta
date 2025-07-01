<?php

namespace App\Models;

use App\Models\Master\JenisSampah;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class TotalSampah extends Model
{
    protected $fillable = [
        'sampah_id',
        'total_berat',
    ];
    /**
     * Get all of the JenisSampah for the TotalSampah
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function JenisSampah(): HasMany
    {
        return $this->hasMany(JenisSampah::class, 'sampah_id');
    }
}
