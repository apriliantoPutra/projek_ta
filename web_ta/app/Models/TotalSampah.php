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
    protected $casts = [
        'total_berat' => 'float',
    ];
}
