<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;

use App\Models\TarikSaldo;
use App\Models\TotalSampah;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        $dataSampah = TotalSampah::sum('total_berat');
        $total_sampah = number_format($dataSampah, 2, ',', '');

        $totalNasabah = User::where('role', 'warga')->count();
        $totalPetugas = User::where('role', 'petugas')->count();

        $totalSaldoMenunggu = TarikSaldo::where('status', 'menunggu')->sum('jumlah_saldo');
        $formatSaldoMenunggu = number_format($totalSaldoMenunggu, 0, '', '.');

        $grafikTarikSaldo = TarikSaldo::where('status', '=', 'terima')->select(
            DB::raw("DATE_FORMAT(created_at, '%Y-%m') as bulan"),
            DB::raw("DATE_FORMAT(created_at, '%M %Y') as label"),
            DB::raw("SUM(jumlah_saldo) as total_saldo")
        )
            ->groupBy('bulan', 'label')
            ->orderBy('bulan')
            ->get();


        return view('dashboard/index', [
            'headerTitle' => 'Dashboard',
            'total_sampah' => $total_sampah,
            'total_nasabah' => $totalNasabah,
            'total_petugas' => $totalPetugas,
            'total_saldo_menunggu' => $formatSaldoMenunggu,
            'grafikTarikSaldo' => $grafikTarikSaldo,
        ]);
    }
}
