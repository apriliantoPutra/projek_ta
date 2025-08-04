<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Edukasi\Artikel;
use Illuminate\Http\Request;

class ArtikelController extends Controller
{
    public function kumpulan()
    {
        $artikels = Artikel::orderBy('created_at', 'desc')->get()->map(function ($artikel) {
            $artikel->gambar_url = $artikel->gambar_artikel ? asset('storage/' . $artikel->gambar_artikel) : 'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg';
            $artikel->tanggal_format = \Carbon\Carbon::parse($artikel->created_at)->translatedFormat('j F Y');
            return $artikel;
        });

        return response()->json([
            'success' => true,
            'data' => $artikels
        ], 200);
    }
    public function limaTerbaru()
    {
        $artikels = Artikel::orderBy('created_at', 'desc')->take(5)->get()->map(function ($artikel) {
            $artikel->gambar_url = $artikel->gambar_artikel ? asset('storage/' . $artikel->gambar_artikel) : 'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg';
            $artikel->tanggal_format = \Carbon\Carbon::parse($artikel->created_at)->translatedFormat('j F Y');
            return $artikel;
        });

        return response()->json([
            'success' => true,
            'data' => $artikels
        ], 200);
    }



    public function detail($id)
    {
        $artikel = Artikel::find($id);

        if (!$artikel) {
            return response()->json([
                'success' => false,
                'message' => 'Data artikel tidak ditemukan'
            ], 404);
        }

        $artikel->gambar_url = $artikel->gambar_artikel ? asset('storage/' . $artikel->gambar_artikel) : 'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg';
        $artikel->tanggal_format = \Carbon\Carbon::parse($artikel->created_at)->translatedFormat('j F Y');

        return response()->json([
            'success' => true,
            'data' => $artikel
        ], 200);
    }
}
