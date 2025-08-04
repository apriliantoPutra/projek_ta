<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Web\NotificationController;
use App\Models\InputDetailSetor;
use App\Models\PengajuanSetor;
use App\Models\Saldo;
use App\Models\TotalSampah;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class SetorLangsungController extends Controller
{
    // Warga melakukan pengajuan
    public function tambahPengajuan(Request $request)
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
            ], 400);
        }

        DB::beginTransaction();
        try {

            $pengajuan_setor = PengajuanSetor::create([
                'warga_id' => $akun_id,
                'jenis_setor' => 'langsung',
                'waktu_pengajuan' => $request->waktu_pengajuan,
                'status_pengajuan' => 'menunggu',
                'catatan_petugas' => $request->catatan_petugas

            ]);

            app(NotificationController::class)->sendNotificationToAllUsers(
                'Pengajuan Setor Sampah Langsung Baru!',
                'Ada permintaan Setor Langsung sampah dari warga yang baru masuk'
            );

            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Tambah Pengajuan Setor Langsung',
                'data' => $pengajuan_setor
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



    // petugas melihat detail pengajuan berdasarkan id
    public function detailPengajuan($id)
    {
        $item = PengajuanSetor::with('user.profil')->find($id);
        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Data pengajuan tidak ditemukan',
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
            ]
        ];
        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ], 200);
    }



    // input detail sampah oleh petugas by id pengajuan
    public function tambahDetailSetor(Request $request, $id)
    {
        $petugas_id = Auth::id();
        $pengajuan = PengajuanSetor::find($id);
        DB::beginTransaction();
        try {

            $pengajuan->update([
                'status_pengajuan' => 'diterima',
            ]);

            $detail_setor = InputDetailSetor::create([
                "pengajuan_id" => $id,
                "petugas_id" => $petugas_id,
                "setoran_sampah" => json_encode($request->setoran_sampah),
                "total_berat" => $request->total_berat,
                "total_harga" => $request->total_harga,
                "status_setor" => "selesai"
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

            $saldo = Saldo::where('warga_id', '=', $pengajuan->warga_id)->first();
            $saldo->update([
                "total_saldo" => $saldo->total_saldo + $request->total_harga
            ]);

            app(NotificationController::class)->sendNotificationToUser(
                $pengajuan->warga_id,
                'Konfirmasi Setor Langsung!',
                'Permintaan setor langsung Anda telah selesai.'
            );
            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Menambah Detail Setor Langsung',
                'data' => $detail_setor
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

    public function detailSetorSelesai($id)
    {
        $item = PengajuanSetor::with('user.profil', 'inputdetail')->find($id);
        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Data detail setor tidak ditemukan',
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
            ]
        ];
        return response()->json([
            'success' => true,
            'data' => $pengajuan_setor
        ], 200);
    }



    // Tidak digunakan
    public function listPengajuanBaru()
    {
        $pengajuan_setor = PengajuanSetor::with(['user.profil'])->where('jenis_setor', '=', 'langsung')->where('status_pengajuan', 'menunggu')->get()->map(function ($item) {
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
    public function listPengajuanSelesai()
    {
        $userId = Auth::id();

        $pengajuan_setor = PengajuanSetor::with(['user.profil', 'inputdetail.user'])->where('jenis_setor', '=', 'langsung')->where('status_pengajuan', 'diterima')->whereHas('inputdetail.user', function ($query) use ($userId) {
            $query->where('petugas_id', $userId);
        })->get()->map(function ($item) {
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
        DB::beginTransaction();
        try {

            $pengajuan_setor->update([
                'waktu_pengajuan' => $request->waktu_pengajuan,
                'status_pengajuan' => 'diterima',
                'catatan_petugas' => $request->catatan_petugas
            ]);

            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Edit Pengajuan Setor Langsung',
                'data' => $pengajuan_setor
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
        $pengajuan_setor->update([
            'status_pengajuan' => 'batalkan',
        ]);
        return response()->json([
            'success' => true,
            'message' => 'Berhasil Batal Pengajuan Setor Langsung',
            'data' => $pengajuan_setor
        ]);
    }
}
