<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Edukasi\Artikel;
use Illuminate\Http\Request;

class ArtikelController extends Controller
{
    public function index()
    {
        $artikels = Artikel::orderBy('created_at', 'desc')->get()->map(function ($artikel) {
            $artikel->gambar_url = asset('storage/' . $artikel->gambar_artikel);
            return $artikel;
        });

        return response()->json([
            'success' => true,
            'data' => $artikels
        ]);
    }
    public function terbaru()
    {
        $artikels = Artikel::orderBy('created_at', 'desc')->take(5)->get()->map(function ($artikel) {
            $artikel->gambar_url = asset('storage/' . $artikel->gambar_artikel);
            $artikel->tanggal_format = \Carbon\Carbon::parse($artikel->created_at)->translatedFormat('j F Y');
            return $artikel;
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
