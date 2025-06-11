<?php

namespace App\Http\Controllers\Api;

use App\Models\DetailSetor;
use Illuminate\Http\Request;
use App\Models\PengajuanSetor;
use App\Http\Controllers\Controller;
use App\Models\InputDetailSetor;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class SetorJemputController extends Controller
{
    // store pengajuan dan detail oleh warga
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
            'jenis_setor' => 'jemput',
            'waktu_pengajuan' => $request->waktu_pengajuan,
            'status_pengajuan' => 'menunggu',
            'catatan_petugas' => $request->catatan_petugas
        ]);

        $detail_setor = InputDetailSetor::create([
            'pengajuan_id' => $pengajuan_setor->id,
            'setoran_sampah' => json_encode($request->setoran_sampah),
            'total_berat' => $request->total_berat,
            'total_harga' => $request->total_harga,
            'status_setor' => 'Diproses'

        ]);

        return response()->json([
            'success' => true,
            'message' => 'Berhasil Tambah Pengajuan Setor Jemput',
            'pengajuan' => $pengajuan_setor,
            'detail' => $detail_setor
        ]);
    }

    // petugas melihat list pengajuan jemput
    public function listPengajuan()
    {
        $pengajuan_setor = PengajuanSetor::where('jenis_setor', '=', 'jemput')->get();

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }

    // petugas melihat detail pengajuan jemput
    public function showPengajuan($id)
    {
        $pengajuan_setor = PengajuanSetor::find($id);
        $detail_setor = InputDetailSetor::where('pengajuan_id', '=', $id)->first();

        return response()->json([
            'success' => true,
            'pengajuan' => $pengajuan_setor,
            'detail' => $detail_setor
        ]);
    }
    // edit dan menyetujui
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
        $detail_setor = InputDetailSetor::where('pengajuan_id', '=', $id)->first();

        $pengajuan_setor->update([
            'waktu_pengajuan' => $request->waktu_pengajuan,
            'status_pengajuan' => 'diterima',
            'catatan_petugas' => $request->catatan_petugas

        ]);

        $detail_setor->update([
            'petugas_id' => Auth::id(), // id petugas
            'setoran_sampah' => $request->setoran_sampah,
            'total_berat' => $request->total_berat,
            'total_harga' => $request->total_harga,
            'status_setor' => 'selesai'

        ]);

        return response()->json([
            'success' => true,
            'message' => 'Berhasil Edit Pengajuan Setor Jemput',
            'pengajuan' => $pengajuan_setor,
            'detail' => $detail_setor
        ]);
    }

    public function batalPengajuan(Request $request, $id)
    {

        $pengajuan_setor = PengajuanSetor::find($id);
        $detail_setor = InputDetailSetor::where('pengajuan_id', '=', $id)->first();

        $pengajuan_setor->update([
            'status_pengajuan' => 'dibatalkan',
        ]);

        $detail_setor->delete();

        return response()->json([
            'success' => true,
            'message' => 'Berhasil Batalkan Pengajuan Setor Jemput',

        ]);
    }
}
