<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Profil extends Model
{
    protected $table= 'profil';
    protected $fillable = [
        'akun_id',
        'nama_pengguna',
        'alamat_pengguna',
        'no_hp_pengguna',
        'gambar_pengguna',
        'koordinat_pengguna',
    ];
}
