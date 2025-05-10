<?php

namespace App\Models\Edukasi;

use Illuminate\Database\Eloquent\Model;

class Artikel extends Model
{
    protected $table= 'edukasi_artikel';
    protected $fillable = [
        'judul_artikel',
        'deskripsi_artikel',
        'gambar_artikel',
        'nama_author'
    ];
}
