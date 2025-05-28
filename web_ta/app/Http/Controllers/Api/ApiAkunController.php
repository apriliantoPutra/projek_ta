<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ApiAkunController extends Controller
{
    public function show()
    {
        $akun_id = Auth::user()->id;
        $akun = User::find($akun_id);

        if (!$akun) {
            return response()->json([
                'success' => false,
                'message' => 'Akun tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $akun
        ]);
    }
}
