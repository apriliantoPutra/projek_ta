<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\PengajuanSetor;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class SetorLangsungController extends Controller
{
    public function store(Request $request)
    {
        $akun_id = Auth::user()->id;

        $validator = Validator::make($request->all(), [
            'waktu_pengajuan' => 'required|string',
            'catatan_petugas' => 'nullable|string',

        ]);
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $pengajuan_setor = PengajuanSetor::create([
            'warga_id' => $akun_id,
            'jenis_setor' => 'langsung',
            'waktu_pengajuan' => $request->waktu_pengajuan,
            'status_pengajuan' => 'menunggu',
            'catatan_petugas' => $request->catatan_petugas

        ]);

        return response()->json([
            'success' => true,
            'message' => 'Berhasil Tambah Pengajuan Setor Langsung',
            'data' => $pengajuan_setor
        ]);
    }
}
