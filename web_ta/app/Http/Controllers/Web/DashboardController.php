<?php
namespace App\Http\Controllers\Web;
use App\Http\Controllers\Controller;

use App\Models\TarikSaldo;
use App\Models\TotalSampah;
use App\Models\User;
use Illuminate\Http\Request;

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

        return view('dashboard/index', [
            'headerTitle' => 'Dashboard',
            'total_sampah' => $total_sampah,
            'total_nasabah' => $totalNasabah,
            'total_petugas' => $totalPetugas,
            'total_saldo_menunggu' => $formatSaldoMenunggu,
        ]);
    }
}
