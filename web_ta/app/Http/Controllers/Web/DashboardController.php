<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\PengajuanSetor;
use App\Models\TarikSaldo;
use App\Models\TotalSampah;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        // Data total, seperti sebelumnya
        $dataSampah = TotalSampah::sum('total_berat');
        $total_sampah = number_format($dataSampah, 2, ',', '');

        $totalNasabah = User::where('role', 'warga')->count();
        $totalPetugas = User::where('role', 'petugas')->count();

        $totalSaldoMenunggu = TarikSaldo::where('status', 'menunggu')->sum('jumlah_saldo');
        $formatSaldoMenunggu = number_format($totalSaldoMenunggu, 0, '', '.');

        // Ambil awal dan akhir bulan ini
        $startOfMonth = Carbon::now()->startOfMonth();
        $endOfMonth = Carbon::now()->endOfMonth();

        // Grafik Harian bulan ini
        $grafikTarikSaldo = TarikSaldo::where('status', 'terima')
            ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
            ->select(
                DB::raw("DATE(created_at) as tanggal"),
                DB::raw("DATE_FORMAT(created_at, '%d %b') as label"),
                DB::raw("SUM(jumlah_saldo) as total_saldo")
            )
            ->groupBy('tanggal', 'label')
            ->orderBy('tanggal')
            ->get();

        $grafikSetorSampah = DB::table('pengajuan_setor as ps')
            ->join('input_detail_setors as ids', 'ids.pengajuan_id', '=', 'ps.id')
            ->where('ps.status_pengajuan', 'diterima')
            ->where('ids.status_setor', 'selesai')
            ->whereBetween('ps.waktu_pengajuan', [$startOfMonth, $endOfMonth])
            ->select(
                DB::raw("DATE(ps.waktu_pengajuan) as tanggal"),
                DB::raw("DATE_FORMAT(ps.waktu_pengajuan, '%d %b') as label"),
                DB::raw("SUM(ids.total_berat) as total_berat")
            )
            ->groupBy('tanggal', 'label')
            ->orderBy('tanggal')
            ->get();

        
        return view('dashboard/index', [
            'headerTitle' => 'Dashboard',
            'total_sampah' => $total_sampah,
            'total_nasabah' => $totalNasabah,
            'total_petugas' => $totalPetugas,
            'total_saldo_menunggu' => $formatSaldoMenunggu,
            'grafikTarikSaldo' => $grafikTarikSaldo,
            'grafikSetorSampah' => $grafikSetorSampah,

        ]);
    }
}
