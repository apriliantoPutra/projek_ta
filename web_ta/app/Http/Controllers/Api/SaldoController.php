<?php

namespace App\Http\Controllers\Api;

use App\Models\Saldo;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class SaldoController extends Controller
{
    public function detail()
    {
        $akun_id = Auth::user()->id;
        $saldo = Saldo::where('warga_id', '=', $akun_id)->first();

        if (!$saldo) {
            return response()->json([
                'success' => false,
                'message' => 'Data saldo tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $saldo
        ], 200);
    }
}
