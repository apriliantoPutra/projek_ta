<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    protected $fillable = [
        'akun_id',
        'title',
        'body',
        'sent_at',
    ];
}
