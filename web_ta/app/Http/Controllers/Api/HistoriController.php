<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PengajuanSetor;
use App\Models\TarikSaldo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class HistoriController extends Controller
{
    // warga
    public function listSetorBaru()
    {
        $warga_id = Auth::id();
        $pengajuan_setor = PengajuanSetor::with('user.profil')->where('warga_id', '=', $warga_id)->where('status_pengajuan', 'menunggu')->get()->map(function ($item) {
            $profil = $item->user->profil;
            return [
                'id' => $item->id,
                'jenis_setor' => 'Setor ' . ucfirst($item->jenis_setor),
                'waktu_pengajuan' => $item->waktu_pengajuan,
                'status_pengajuan' => $item->status_pengajuan,
                'catatan_petugas' => $item->catatan_petugas,

            ];
        });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }
    public function listSetorProses()
    {
        $warga_id = Auth::id();
        $pengajuan_setor = PengajuanSetor::with(['user.profil', 'inputdetail'])
            ->where('warga_id', '=', $warga_id)
            ->where('jenis_setor', 'jemput')
            ->where('status_pengajuan', 'diterima')
            ->whereHas('inputdetail', function ($query) {
                $query->where('status_setor', 'proses');
            })
            ->get()
            ->map(function ($item) {
                $profil = $item->user->profil;
                return [
                    'id' => $item->id,
                    'jenis_setor' => 'Setor ' . ucfirst($item->jenis_setor),
                    'waktu_pengajuan' => $item->waktu_pengajuan,
                    'status_pengajuan' => $item->status_pengajuan,
                    'catatan_petugas' => $item->catatan_petugas,

                ];
            });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }

    public function listSetorSelesai()
    {
        $warga_id = Auth::id();
        $pengajuan_setor = PengajuanSetor::with(['user.profil', 'inputdetail'])
            ->where('warga_id', '=', $warga_id)
            ->where('status_pengajuan', 'diterima')
            ->whereHas('inputdetail', function ($query) {
                $query->where('status_setor', 'selesai');
            })
            ->get()
            ->map(function ($item) {
                $profil = $item->user->profil;
                return [
                    'id' => $item->id,
                    'jenis_setor' => 'Setor ' . ucfirst($item->jenis_setor),
                    'waktu_pengajuan' => $item->waktu_pengajuan,
                    'status_pengajuan' => $item->status_pengajuan,
                    'catatan_petugas' => $item->catatan_petugas,

                ];
            });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }
    public function listSetorBatal()
    {
        $warga_id = Auth::id();
        $pengajuan_setor = PengajuanSetor::with(['user.profil'])
            ->where('warga_id', '=', $warga_id)
            ->where('status_pengajuan', 'batalkan')
            ->get()
            ->map(function ($item) {
                $profil = $item->user->profil;
                return [
                    'id' => $item->id,
                    'jenis_setor' => 'Setor ' . ucfirst($item->jenis_setor),
                    'waktu_pengajuan' => $item->waktu_pengajuan,
                    'status_pengajuan' => $item->status_pengajuan,
                    'catatan_petugas' => $item->catatan_petugas,

                ];
            });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }

    public function detailSetor($id)
    {
        $item = PengajuanSetor::with('user.profil', 'inputdetail')->find($id);
        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Pengajuan tidak ditemukan',
            ], 404);
        }
        $profil = $item->user->profil;

        $pengajuan_setor = [
            'id' => $item->id,
            'jenis_setor' => $item->jenis_setor,
            'waktu_pengajuan' => $item->waktu_pengajuan,
            'status_pengajuan' => $item->status_pengajuan,
            'catatan_petugas' => $item->catatan_petugas,
            'user' => [
                'username' => $item->user->username,
                'email' => $item->user->email,
                'profil' => [
                    'nama_pengguna' => $profil->nama_pengguna,
                    'alamat_pengguna' => $profil->alamat_pengguna,
                    'no_hp_pengguna' => $profil->no_hp_pengguna,
                    'gambar_pengguna' => $profil->gambar_pengguna,
                    'gambar_url' => asset('storage/' . $profil->gambar_pengguna),
                ]
            ],
            'input_detail' => [
                'setoran_sampah' => json_decode($item->inputdetail->setoran_sampah, true),
                'total_berat' => $item->inputdetail->total_berat,
                'total_harga' => $item->inputdetail->total_harga,
                'status_setor' => $item->inputdetail->status_setor,
            ]
        ];

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor,
        ]);
    }

    public function listSaldo()
    {
        $warga_id = Auth::id();
        $histori_saldo = TarikSaldo::with('user.profil')->where('warga_id', '=', $warga_id)->get()->map(function ($item) {
            $profil = $item->user->profil;

            return [
                'id' => $item->id,
                'jumlah_saldo' => $item->jumlah_saldo,
                'status' => $item->status,
                'metode' => $item->metode,
                'nomor_tarik_saldo' => $item->nomor_tarik_saldo,
                'pesan' => $item->pesan ?? '',
                'tanggal_format' => \Carbon\Carbon::parse($item->created_at)
                    ->locale('id')
                    ->isoFormat('dddd, DD/MM/YYYY'),

            ];
        });

        return response()->json([
            'success' => true,
            'data' => $histori_saldo,
        ]);
    }

    public function detailSaldo($id)
    {
        $item = TarikSaldo::with('user.profil')->find($id);
        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Histori saldo tidak ditemukan',
            ], 404);
        }



        $histori_saldo = [
            'id' => $item->id,
            'jumlah_saldo' => $item->jumlah_saldo,
            'status' => $item->status,
            'metode' => $item->metode,
            'nomor_tarik_saldo' => $item->nomor_tarik_saldo,
            'pesan' => $item->pesan,
            'tanggal_format' => \Carbon\Carbon::parse($item->created_at)
                ->locale('id')
                ->isoFormat('dddd, DD/MM/YYYY'),

        ];

        return response()->json([
            'success' => true,
            'data' => $histori_saldo,
        ]);
    }
}
