<?php

namespace App\Models\Master;

use Illuminate\Database\Eloquent\Model;

class LayananJemput extends Model
{
    protected $table= 'layanan_jemput';
    protected $fillable = [
        'bank_sampah_id',
        'ongkir_per_jarak',
    ];
}
