<?php

namespace App\Http\Controllers\Api;

use App\Models\Profil;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
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
        $gambar_path = null;
        if ($request->hasFile('gambar_pengguna')) {
            $filaname = time() . '_' . uniqid() . '.' . $request->file('gambar_pengguna')->getClientOriginalExtension();
            $gambar_path = $request->file('gambar_pengguna')->storeAs('img/profil', $filaname, 'public');
        }

        $akun_id = Auth::user()->id;

        $profil = Profil::create([
            'akun_id' => $akun_id,
            'nama_pengguna' => $request->nama_pengguna,
            'alamat_pengguna' => $request->alamat_pengguna,
            'no_hp_pengguna' => $request->no_hp_pengguna,
            'gambar_pengguna' => $gambar_path,
            'koordinat_pengguna' => $request->koordinat_pengguna,
        ]);
        return response()->json([
            'success' => true,
            'message' => 'Berhasil Tambah Profil',
            'data' => $profil
        ]);
    }

    public function show()
    {
        $akun_id = Auth::user()->id;
        $profil = Profil::where('akun_id', '=', $akun_id)->first();

        if (!$profil) {
            return response()->json([
                'success' => false,
                'message' => 'Profil tidak ditemukan'
            ], 404);
        }

        $profil->gambar_url = asset('storage/' . $profil->gambar_pengguna);

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

        // Default null jika tidak upload gambar
        $gambar_path = $profil->gambar_pengguna;

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

        return response()->json([
            'success' => true,
            'message' => 'Berhasil Edit Profil',
            'data' => $profil
        ]);
    }
}
