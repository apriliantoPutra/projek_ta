<?php

namespace App\Models\Master;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;

class BankSampah extends Model
{
    protected $table = 'bank_sampah';
    protected $fillable = [
        'admin_id',
        'nama_bank_sampah',
        'deskripsi_bank_sampah',
        'alamat_bank_sampah',
        'koordinat_bank_sampah',
    ];
    // BankSampah.php
    public function user()
    {
        return $this->belongsTo(User::class, 'admin_id'); // bank_sampah.admin_id mengarah ke user.id
    }
    /**
     * Get the layananJemput associated with the BankSampah
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    
    public function layananJemput(): HasOne
    {
        return $this->hasOne(LayananJemput::class, 'bank_sampah_id', 'id');
    }
}
