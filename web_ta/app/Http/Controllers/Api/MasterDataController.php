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
        $item = BankSampah::with(['user.profil'])
            ->find($id);

        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }
        $profil = $item->user->profil;

        $bankSampah = [
            'id' => $item->id,
            'admin_id' => $item->admin_id,
            'nama_bank_sampah' => $item->nama_bank_sampah,
            'deskripsi_bank_sampah' => $item->deskripsi_bank_sampah,
            'alamat_bank_sampah' => $item->alamat_bank_sampah,
            'koordinat_bank_sampah' => $item->koordinat_bank_sampah,
            'user' => [
                'username' => $item->user->username,
                'email' => $item->user->email,
                'role' => $item->user->role,
                'profil' => [
                    'nama_pengguna' => $profil->nama_pengguna,
                    'no_hp_pengguna' => $profil->no_hp_pengguna,
                    'gambar_pengguna' => $profil->gambar_pengguna,
                    'gambar_url' => asset('storage/' . $profil->gambar_pengguna),
                ]
            ],
        ];


        return response()->json([
            'success' => true,
            'data' => $bankSampah
        ]);
    }
}
