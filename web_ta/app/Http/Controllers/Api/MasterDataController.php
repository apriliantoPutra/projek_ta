<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Master\BankSampah;
use App\Models\Master\JenisSampah;
use Illuminate\Http\Request;

class MasterDataController extends Controller
{
    public function jenisSampahIndex()
    {
        $jenisSampah = JenisSampah::all();

        return response()->json([
            'success' => true,
            'data' => $jenisSampah
        ]);
    }
    public function jenisSampahShow($id)
    {
        $jenisSampah = JenisSampah::find($id);

        if (!$jenisSampah) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $jenisSampah
        ]);
    }

    public function bankSampahIndex()
    {
        $bankSampah = BankSampah::all();
        return response()->json([
            'success' => true,
            'data' => $bankSampah
        ]);
    }
    public function bankSampahShow($id)
    {
        $bankSampah = BankSampah::with(['user.profil']) // eager load user dan profil user
            ->find($id);

        if (!$bankSampah) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $bankSampah
        ]);
    }
}
