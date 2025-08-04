<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Saldo;
use App\Models\TarikSaldo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class TarikSaldoController extends Controller
{
    // warga
    public function pengajuanTarikSaldo(Request $request)
    {
        DB::beginTransaction();
        try {
            $tarik_saldo = TarikSaldo::create([
                'warga_id' => Auth::id(),
                'jumlah_saldo' => $request->jumlah_saldo,
                'metode' => $request->metode,
                'nomor_tarik_saldo' => $request->nomor_tarik_saldo,
                'status' => 'menunggu',
                'pesan' => $request->pesan,
            ]);

            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Tambah Pengajuan Tarik Saldo',
                'data' => $tarik_saldo
            ], 201);
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

    public function permintaanTarikSaldo()
    {
        $warga_id = Auth::id();

        $jumlah_saldo = TarikSaldo::where('warga_id', $warga_id)
            ->where('status', 'menunggu')
            ->sum('jumlah_saldo');

        return response()->json([
            'success' => true,
            'data' => (int) $jumlah_saldo,
        ], 200);
    }
}
