<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PengajuanSetor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class KumpulanSetorController extends Controller
{
    public function baru()
    {
        $pengajuan_setor = PengajuanSetor::with(['user.profil'])->where('status_pengajuan', 'menunggu')->get()->map(function ($item) {
            $profil = $item->user->profil;
            return [
                'id' => $item->id,
                'jenis_setor' => 'Setor ' . ucfirst($item->jenis_setor),
                'waktu_pengajuan' => $item->waktu_pengajuan,
                'status_pengajuan' => 'Setor ' . ucfirst($item->status_pengajuan),
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
                ]
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }
    public function proses()
    {
        $petugasId = Auth::id(); // Ambil ID petugas yang sedang login

        $pengajuan_setor = PengajuanSetor::with(['user.profil', 'inputdetail'])
            ->where('jenis_setor', 'jemput')
            ->where('status_pengajuan', 'diterima')
            ->whereHas('inputdetail', function ($query) use ($petugasId) {
                $query->where('status_setor', 'proses')
                    ->where('petugas_id', $petugasId); // Tambahan kondisi sesuai permintaan
            })
            ->get()
            ->map(function ($item) {
                $profil = $item->user->profil;
                return [
                    'id' => $item->id,
                    'jenis_setor' => 'Setor ' . ucfirst($item->jenis_setor),
                    'waktu_pengajuan' => $item->waktu_pengajuan,
                    'status_pengajuan' => 'Setor ' . ucfirst($item->status_pengajuan),
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
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }
    public function selesai()
    {
        $petugasId = Auth::id();

        $pengajuan_setor = PengajuanSetor::with(['user.profil', 'inputdetail.user'])->where('status_pengajuan', 'diterima')->whereHas('inputdetail.user', function ($query) use ($petugasId) {
            $query->where('petugas_id', '=', $petugasId);
        })->get()->map(function ($item) {
            $profil = $item->user->profil;
            return [
                'id' => $item->id,
                'jenis_setor' => 'Setor ' . ucfirst($item->jenis_setor),
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
                ]
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }
}
