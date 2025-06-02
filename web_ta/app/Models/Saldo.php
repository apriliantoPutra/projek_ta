<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Saldo extends Model
{
    protected $table= 'saldo';
    protected $fillable = [
        'warga_id',
        'total_saldo',
    ];
}
