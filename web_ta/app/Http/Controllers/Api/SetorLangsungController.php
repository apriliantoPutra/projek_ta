<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\PengajuanSetor;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class SetorLangsungController extends Controller
{
    // Warga melakukan pengajuan
    public function storePengajuan(Request $request)
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
    // petugas melihat list pengajuan langsung
    public function listPengajuan()
    {
        $pengajuan_setor = PengajuanSetor::where('jenis_setor', '=', 'langsung')->get();

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }

    // petugas melihat detail pengajuan berdasarkan id
    public function showPengajuan($id)
    {
        $pengajuan_setor = PengajuanSetor::find($id);

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }
    // petugas merubah status pengajuan berdasarkan id
    public function updatePengajuan(Request $request, $id)
    {
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

        $pengajuan_setor = PengajuanSetor::find($id);
        $pengajuan_setor->update([
            'waktu_pengajuan' => $request->waktu_pengajuan,
            'status_pengajuan' => 'diterima',
            'catatan_petugas' => $request->catatan_petugas
        ]);
        return response()->json([
            'success' => true,
            'message' => 'Berhasil Edit Pengajuan Setor Langsung',
            'data' => $pengajuan_setor
        ]);
    }

    public function storeDetail(Request $request) {}
    public function updateDetail(Request $request) {}
}
