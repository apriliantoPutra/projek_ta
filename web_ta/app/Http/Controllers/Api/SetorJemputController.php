<?php

namespace App\Http\Controllers\Api;

use App\Models\DetailSetor;
use Illuminate\Http\Request;
use App\Models\PengajuanSetor;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Web\NotificationController;
use App\Models\InputDetailSetor;
use App\Models\Saldo;
use App\Models\TotalSampah;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
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

        DB::beginTransaction();
        try {

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
                'status_setor' => 'proses'

            ]);

            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Tambah Pengajuan Setor Jemput',
                'pengajuan' => $pengajuan_setor,
                'detail' => $detail_setor
            ]);
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

    // petugas melihat list pengajuan jemput
    public function listPengajuanBaru()
    {
        $pengajuan_setor = PengajuanSetor::with(['user.profil'])->where('jenis_setor', '=', 'jemput')->where('status_pengajuan', 'menunggu')->get()->map(function ($item) {
            $profil = $item->user->profil;
            return [
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
                ]
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }
    public function listPengajuanProses()
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
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }

    public function listPengajuanSelesai()
    {
        $petugasId = Auth::id(); // Ambil ID petugas yang sedang login

        $pengajuan_setor = PengajuanSetor::with(['user.profil', 'inputdetail.user'])
            ->where('jenis_setor', 'jemput')
            ->where('status_pengajuan', 'diterima')
            ->whereHas('inputdetail', function ($query) use ($petugasId) {
                $query->where('status_setor', 'selesai')
                    ->whereHas('user', function ($q) use ($petugasId) {
                        $q->where('petugas_id', $petugasId);
                    });
            })
            ->get()
            ->map(function ($item) {
                $profil = $item->user->profil;
                return [
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
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ]);
    }



    // petugas melihat detail pengajuan jemput
    public function showPengajuan($id)
    {
        $item = PengajuanSetor::with('user.profil', 'inputdetail')->find($id);
        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Pengajuan tidak ditemukan',
            ], 404);
        }
        $profil = $item->user->profil;

        $koordinat = str_replace(' ', '', $profil->koordinat_pengguna); // Hilangkan spasi
        $koordinatParts = explode(',', $koordinat);
        $latitude = $koordinatParts[0] ?? null;
        $longitude = $koordinatParts[1] ?? null;

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
                    'koordinat_pengguna' => $koordinat,
                    'latitude' => $latitude,
                    'longitude' => $longitude
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
    // edit dan menyetujui
    public function terimaPengajuan(Request $request, $id)
    {
        $pengajuan_setor = PengajuanSetor::find($id);
        $detail_setor = InputDetailSetor::where('pengajuan_id', '=', $id)->first();

        DB::beginTransaction();
        try {
            $pengajuan_setor->update([
                'status_pengajuan' => 'diterima',
            ]);

            $detail_setor->update([
                'petugas_id' => Auth::id(), // id petugas
            ]);

            app(NotificationController::class)->sendNotificationToUser(
                $pengajuan_setor->warga_id,
                'Permintaan Setor Jemput!',
                'Permintaan setor jemput Anda di proses.'
            );
            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Terima Pengajuan Setor Jemput',
                'pengajuan' => $pengajuan_setor,
            ]);
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

    public function batalPengajuan(Request $request, $id)
    {

        $pengajuan_setor = PengajuanSetor::find($id);
        $detail_setor = InputDetailSetor::where('pengajuan_id', '=', $id)->first();

        DB::beginTransaction();
        try {
            $pengajuan_setor->update([
                'status_pengajuan' => 'batalkan',
            ]);

            $detail_setor->delete();

            app(NotificationController::class)->sendNotificationToUser(
                $pengajuan_setor->warga_id,
                'Permintaan Setor Jemput!',
                'Permintaan setor jemput Anda di tolak.'
            );
            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Batalkan Pengajuan Setor Jemput',

            ]);
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
    public function konfirmasiPengajuan(Request $request, $id)
    {

        $pengajuan_setor = PengajuanSetor::find($id);
        $detail_setor = InputDetailSetor::where('pengajuan_id', '=', $id)->first();

        DB::beginTransaction();
        try {
            $detail_setor->update([
                'setoran_sampah' => json_encode($request->setoran_sampah),
                'total_berat' => $request->total_berat,
                'total_harga' => $request->total_harga,
                'status_setor' => 'selesai'

            ]);
            // perulangan update tiap jenis sampah
            foreach ($request->setoran_sampah as $item) {
                $jenisId = $item['jenis_sampah_id'];
                $berat = $item['berat'];

                $total_sampah = TotalSampah::where('sampah_id', $jenisId)->first();

                if ($total_sampah) {
                    $total_sampah->update([
                        'total_berat' => $total_sampah->total_berat + $berat
                    ]);
                }
            }

            // Update jumlah saldo
            $saldo = Saldo::where('warga_id', '=', $pengajuan_setor->warga_id)->first();
            $saldo->update([
                "total_saldo" => $saldo->total_saldo + $request->total_harga
            ]);

            app(NotificationController::class)->sendNotificationToUser(
                $pengajuan_setor->warga_id,
                'Konfirmasi Setor Jemput!',
                'Permintaan setor jemput Anda telah selesai.'
            );

            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Edit Pengajuan Setor Jemput',
                'data' => $detail_setor
            ]);
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
}
