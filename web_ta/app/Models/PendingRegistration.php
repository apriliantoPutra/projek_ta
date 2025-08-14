<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PendingRegistration extends Model
{
    protected $fillable = [
        'username',
        'email',
        'password',
        'token',
        'expires_at',
    ];
}
