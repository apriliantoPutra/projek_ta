<?php

namespace App\Http\Controllers\Api;

use App\Models\TotalSampah;
use Illuminate\Http\Request;

class TotalSampahController
{
    public function totalSampah()
    {
        $total_berat = TotalSampah::sum('total_berat');

        $total_sampah = number_format($total_berat, 2, ',', '');

        return response()->json([
            'success' => true,
            'data' => $total_sampah,
        ]);
    }
}
