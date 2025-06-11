<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\InputDetailSetor;
use App\Models\PengajuanSetor;
use App\Models\Saldo;
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
    public function terimaPengajuan(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'waktu_pengajuan' => 'nullable|string',
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
    public function batalPengajuan(Request $request, $id)
    {

        $pengajuan_setor = PengajuanSetor::find($id);
        $pengajuan_setor->update([
            'status_pengajuan' => 'batalkan',
        ]);
        return response()->json([
            'success' => true,
            'message' => 'Berhasil Batal Pengajuan Setor Langsung',
            'data' => $pengajuan_setor
        ]);
    }

    // input detail sampah oleh petugas by id pengajuan
    public function storeDetail(Request $request, $id)
    {
        $petugas_id = Auth::id();
        $pengajuan = PengajuanSetor::find($id);
        $detail_setor = InputDetailSetor::create([
            "pengajuan_id" => $id,
            "petugas_id" => $petugas_id,
            "setoran_sampah" => json_encode($request->setoran_sampah),
            "total_berat" => $request->total_berat,
            "total_harga" => $request->total_harga,
            "status_setor" => "selesai"
        ]);

        $saldo = Saldo::where('warga_id', '=', $pengajuan->warga_id)->first();
        $saldo->update([
            "total_saldo" => $saldo->total_saldo + $request->total_harga
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Berhasil Menambah Detail Setor Langsung',
            'data' => $detail_setor
        ]);
    }
}
