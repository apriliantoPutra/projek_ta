<?php

namespace App\Http\Controllers;

use App\Models\DetailSetor;
use App\Models\PengajuanPetugas;
use App\Models\PengajuanSetor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class PengajuanPetugasController extends Controller
{
    public function store(Request $request)
    {
        DB::beginTransaction();
        try {
            $pengajuan_petugas_ids = [];
            $totalBerat = 0;

            foreach ($request->jenis_sampah as $index => $jenis) {
                $berat = $request->berat_sampah[$index];

                $pengajuan_petugas = PengajuanPetugas::create([
                    'petugas_id' => Auth::user()->id,
                    'jenis_sampah_id' => $jenis,
                    'berat_sampah' => $berat
                ]);

                $pengajuan_petugas_ids[] = $pengajuan_petugas->id;
                $totalBerat += $berat;
            }

            $totalHarga = 0;
            foreach ($pengajuan_petugas_ids as $pengajuan_petugas_id) {

                $data = PengajuanPetugas::with('jenisSampah')->where('id', $pengajuan_petugas_id)->first();
                $totalHarga += $data->jenisSampah->harga_per_satuan;
            }

            $detailSetor = DetailSetor::create([
                'pengajuan_id' => 1,
                'petugas_id' => Auth::id(),
                'total_berat' => $totalBerat,
                'total_harga' => $totalHarga,
                'status_setor' => 'diproses'

            ]);
            $detailSetor->pengajuanPetugas()->attach($pengajuan_petugas_ids);

            DB::commit();
            return response()->json(
                [
                    "success" => true,

                ]
            );
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(
                [
                    "success" => false,
                    "message" => $e->getMessage()

                ]
            );
        }
    }
    public function show($id)
    {
        $data = DetailSetor::with('pengajuanPetugas.jenisSampah')->find($id);

        return response()->json(
            [
                "success" => true,
                "data" => $data

            ]
        );
    }
}
