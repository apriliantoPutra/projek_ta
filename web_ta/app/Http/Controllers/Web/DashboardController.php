<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Master\JenisSampah;
use App\Models\PengajuanSetor;
use App\Models\TarikSaldo;
use App\Models\TotalSampah;
use App\Models\User;
use Barryvdh\DomPDF\Facade\Pdf;
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
    
    public function pdf()
    {
        $startOfMonth = Carbon::now()->startOfMonth();
        $endOfMonth = Carbon::now()->endOfMonth();

        // Get setor sampah data
        $query1 = PengajuanSetor::where('status_pengajuan', 'diterima')
            ->whereBetween('waktu_pengajuan', [$startOfMonth, $endOfMonth])
            ->with(['user.profil', 'inputdetail' => function ($query) {
                $query->where('status_setor', 'selesai');
            }])
            ->get();

        // Get tarik saldo data
        $query2 = TarikSaldo::with('user.profil')
            ->where('status', 'terima')
            ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
            ->get();

        // Process setor sampah data and calculate totals
        $totalBerat = 0;
        $totalHarga = 0;

        $setorSampah = $query1->map(function ($item) use (&$totalBerat, &$totalHarga) {
            $inputDetail = $item->inputdetail;

            $setoran_detail = null;

            if ($inputDetail) {
                $decoded_sampah = json_decode($inputDetail->setoran_sampah, true);

                $setoran_detail = collect($decoded_sampah)->map(function ($sampah) {
                    $jenis = JenisSampah::find($sampah['jenis_sampah_id']);
                    return [
                        'jenis_sampah_id' => $sampah['jenis_sampah_id'],
                        'nama_sampah' => $jenis ? $jenis->nama_sampah : 'Tidak diketahui',
                        'berat' => $sampah['berat'],
                    ];
                })->toArray();

                // Add to totals
                $totalBerat += $inputDetail->total_berat;
                $totalHarga += $inputDetail->total_harga;
            }

            return [
                'id' => $item->id,
                'jenis_setor' => $item->jenis_setor,
                'waktu_pengajuan' => Carbon::parse($item->waktu_pengajuan)->isoFormat('dddd, DD/MM/YYYY'),
                'status_pengajuan' => $item->status_pengajuan,
                'catatan_petugas' => $item->catatan_petugas,
                'user' => [
                    'username' => $item->user->username,
                    'email' => $item->user->email,
                    'profil' => $item->user->profil ? [
                        'nama_pengguna' => $item->user->profil->nama_pengguna,
                        'alamat_pengguna' => $item->user->profil->alamat_pengguna,
                        'no_hp_pengguna' => $item->user->profil->no_hp_pengguna,
                        'gambar_pengguna' => $item->user->profil->gambar_pengguna,
                        'gambar_url' => $item->user->profil->gambar_url,
                        'koordinat_pengguna' => $item->user->profil->koordinat_pengguna
                    ] : null
                ],
                'input_detail' => $inputDetail ? [
                    'id' => $inputDetail->id,
                    'setoran_sampah' => $setoran_detail,
                    'total_berat' => $inputDetail->total_berat,
                    'total_harga' => $inputDetail->total_harga,
                    'status_setor' => $inputDetail->status_setor,
                ] : null
            ];
        });

        // Process tarik saldo data and calculate total
        $totalSaldo = $query2->sum('jumlah_saldo');

        $tarikSaldo = $query2->map(function ($item) {
            return [
                'id' => $item->id,
                'jumlah_saldo' => $item->jumlah_saldo,
                'waktu_pengajuan' => Carbon::parse($item->waktu_pengajuan)->isoFormat('dddd, DD/MM/YYYY'),
                'status' => $item->status,
                'user' => [
                    'username' => $item->user->username,
                    'email' => $item->user->email,
                    'profil' => $item->user->profil ? [
                        'nama_pengguna' => $item->user->profil->nama_pengguna,
                        'alamat_pengguna' => $item->user->profil->alamat_pengguna,
                        'no_hp_pengguna' => $item->user->profil->no_hp_pengguna,
                        'gambar_pengguna' => $item->user->profil->gambar_pengguna,
                        'gambar_url' => $item->user->profil->gambar_url,
                        'koordinat_pengguna' => $item->user->profil->koordinat_pengguna
                    ] : null
                ]
            ];
        });

        $currentMonth = Carbon::now()->isoFormat('MMMM YYYY');

        $pdf = Pdf::loadView('dashboard.pdf', [
            'setor_sampah' => $setorSampah,
            'tarik_saldo' => $tarikSaldo,
            'monthYear' => $currentMonth,
            'logoPath' => public_path('img/green.png'),
            'total_berat' => $totalBerat,
            'total_harga' => $totalHarga,
            'total_saldo' => $totalSaldo,
            'has_setor_data' => $query1->count() > 0,
            'has_tarik_data' => $query2->count() > 0
        ]);

        // Set paper to landscape
        return $pdf->setPaper('a4', 'landscape')
            ->download('laporan-bank-sampah-' . Carbon::now()->format('Y-m-d') . '.pdf');

        }
}
