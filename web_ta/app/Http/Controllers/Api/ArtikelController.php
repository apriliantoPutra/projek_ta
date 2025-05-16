<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Edukasi\Artikel;
use Illuminate\Http\Request;

class ArtikelController extends Controller
{
    public function index()
    {
        $artikels = Artikel::all()->map(function ($artikels) {
            $artikels->gambar_url = asset('storage/' . $artikels->gambar_artikel);
            return $artikels;
        });

        return response()->json([
            'success' => true,
            'data' => $artikels
        ]);
    }

    public function show($id)
    {
        $artikel = Artikel::find($id);

        if (!$artikel) {
            return response()->json([
                'success' => false,
                'message' => 'Artikel tidak ditemukan'
            ], 404);
        }

        $artikel->gambar_url = asset('storage/' . $artikel->gambar_artikel);

        return response()->json([
            'success' => true,
            'data' => $artikel
        ]);
    }
}
