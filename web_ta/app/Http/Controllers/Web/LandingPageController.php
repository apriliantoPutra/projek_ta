<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Master\BankSampah;
use App\Models\Master\JenisSampah;
use App\Models\User;
use Illuminate\Http\Request;

class LandingPageController extends Controller
{
    public function index()
    {
        $akun_admin= User::with('profil')->where('role', 'admin')->first();
        $bank_sampah= BankSampah::first();
        $data_sampah= JenisSampah::all();

        return view('index', compact('akun_admin', 'bank_sampah', 'data_sampah'));
    }
}
