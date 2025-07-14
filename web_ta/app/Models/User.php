<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use App\Models\Master\BankSampah;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $table = 'akun';
    protected $fillable = [
        'username',
        'email',
        'password',
        'role',
        'fcm_token'
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function profil()
    {
        return $this->hasOne(Profil::class, 'akun_id'); // profil.akun_id mengarah ke user.id
    }

    public function bankSampah()
    {
        return $this->hasOne(BankSampah::class, 'admin_id'); // bank_sampah.admin_id = user.id
    }
    /**
     * Get all of the PengajuanSetor for the User
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function pengajuansetor(): HasMany
    {
        return $this->hasMany(PengajuanSetor::class, 'warga_id');
    }
    public function inputdetailsetor(): HasMany
    {
        return $this->hasMany(InputDetailSetor::class, 'petugas_id');
    }
}
