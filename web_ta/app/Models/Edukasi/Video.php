<?php

namespace App\Models\Edukasi;

use Illuminate\Database\Eloquent\Model;

class Video extends Model
{
    protected $table= 'edukasi_video';
    protected $fillable = [
        'judul_video',
        'deskripsi_video',
        'video',
        'thumbnail',
    ];
}
