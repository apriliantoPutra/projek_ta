<?php

namespace App\Http\Controllers\Api;

use App\Models\Profil;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Saldo;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ProfilController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama_pengguna' => 'required|string|max:255|unique:profil,nama_pengguna',
            'alamat_pengguna' => 'required|string',
            'no_hp_pengguna' => 'required|string|unique:profil,no_hp_pengguna',
            'gambar_pengguna' => 'nullable|image|mimes:jpg,png,jpeg|max:5096',
            'koordinat_pengguna' => 'required|string'
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
            $gambar_path = null;
            if ($request->hasFile('gambar_pengguna')) {
                $filaname = time() . '_' . uniqid() . '.' . $request->file('gambar_pengguna')->getClientOriginalExtension();
                $gambar_path = $request->file('gambar_pengguna')->storeAs('img/profil', $filaname, 'public');
            }

            $akun_id = Auth::user()->id;
            $cek_role = Auth::user()->role;
            if ($cek_role == 'warga') {
                Saldo::create(
                    [
                        'warga_id' => $akun_id,
                        'total_saldo' => 0,
                    ]
                );
            }

            $profil = Profil::create([
                'akun_id' => $akun_id,
                'nama_pengguna' => $request->nama_pengguna,
                'alamat_pengguna' => $request->alamat_pengguna,
                'no_hp_pengguna' => $request->no_hp_pengguna,
                'gambar_pengguna' => $gambar_path,
                'koordinat_pengguna' => $request->koordinat_pengguna,
            ]);

            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Tambah Profil ' . $cek_role,
                'data' => $profil
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

    public function show()
    {
        $akun_id = Auth::user()->id;
        $item = Profil::where('akun_id', '=', $akun_id)->first();

        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Profil tidak ditemukan'
            ], 404);
        }

        $koordinat = str_replace(' ', '', $item->koordinat_pengguna);
        $koordinatParts = explode(',', $koordinat);
        $latitude = $koordinatParts[0] ?? null;
        $longitude = $koordinatParts[1] ?? null;

        $profil = [
            'nama_pengguna' => $item->nama_pengguna,
            'no_hp_pengguna' => $item->no_hp_pengguna,
            'alamat_pengguna' => $item->alamat_pengguna,
            'koordinat_pengguna' => $koordinat,
            'latitude' => $latitude,
            'longitude' => $longitude,
            'gambar_pengguna' => $item->gambar_pengguna,
            'gambar_url' => asset('storage/' . $item->gambar_pengguna)
        ];

        return response()->json([
            'success' => true,
            'data' => $profil
        ]);
    }

    public function update(Request $request)
    {
        $akun_id = Auth::user()->id;
        $profil = Profil::where('akun_id', '=', $akun_id)->first();

        $validator = Validator::make($request->all(), [
            'nama_pengguna' => 'required|string|max:255|unique:profil,nama_pengguna,' . $profil->id,
            'alamat_pengguna' => 'required|string',
            'no_hp_pengguna' => 'required|string|unique:profil,no_hp_pengguna,' . $profil->id,
            'gambar_pengguna' => 'nullable|image|mimes:jpg,png,jpeg|max:5096',
            'koordinat_pengguna' => 'required|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }
        $gambar_path = $profil->gambar_pengguna;

        DB::beginTransaction();
        try {

            if ($request->hasFile('gambar_pengguna')) {
                if ($profil->gambar_pengguna) {
                    Storage::disk('public')->delete($profil->gambar_pengguna);
                }

                $filename = time() . '_' . uniqid() . '.' . $request->file('gambar_pengguna')->getClientOriginalExtension();
                $gambar_path = $request->file('gambar_pengguna')->storeAs('img/profil', $filename, 'public');
            }

            $profil->update([
                'nama_pengguna' => $request->nama_pengguna,
                'alamat_pengguna' => $request->alamat_pengguna,
                'no_hp_pengguna' => $request->no_hp_pengguna,
                'gambar_pengguna' => $gambar_path,
                'koordinat_pengguna' => $request->koordinat_pengguna,
            ]);

            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Berhasil Edit Profil',
                'data' => $profil
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
