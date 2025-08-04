<?php

namespace App\Http\Controllers\Api;

use App\Models\Master\JenisSampah;
use App\Models\TotalSampah;
use Illuminate\Http\Request;

class TotalSampahController
{
    public function semuaSampah()
    {
        $total_berat = TotalSampah::sum('total_berat');

        $total_sampah = number_format($total_berat, 2, ',', '');

        return response()->json([
            'success' => true,
            'data' => $total_sampah,
        ], 200);
    }
    public function sampahBotolPlastik()
    {
        $item = JenisSampah::where('nama_sampah', 'botol plastik')->first();
        $total_berat_botol = TotalSampah::where('sampah_id', $item->id)->value('total_berat');

        $total_sampah_botol = number_format($total_berat_botol, 2, ',', '');

        return response()->json([
            'success' => true,
            'data' => $total_sampah_botol,
        ], 200);
    }
}
