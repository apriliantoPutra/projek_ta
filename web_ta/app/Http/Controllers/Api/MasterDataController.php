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
    public function bankSampahIndex()
    {
        $bankSampah = BankSampah::all();
        return response()->json([
            'success' => true,
            'data' => $bankSampah
        ]);
    }
    public function bankSampahDetail() {}
}
