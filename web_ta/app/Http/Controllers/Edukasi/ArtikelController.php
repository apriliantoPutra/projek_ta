<?php

namespace App\Http\Controllers\Edukasi;

use Illuminate\Http\Request;
use App\Models\Edukasi\Artikel;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Storage;

class ArtikelController extends Controller
{
    public function index()
    {
        $datas = Artikel::all();

        return view('edukasi/artikel/index', ['headerTitle' => 'Manajemen Edukasi', 'data' => $datas]);
    }
    public function show($id)
    {
        $datas = Artikel::find($id);

        return view('edukasi/artikel/show', ['headerTitle' => 'Manajemen Edukasi', 'data' => $datas]);
    }


    public function create()
    {

        return view('edukasi/artikel/create', ['headerTitle' => 'Manajemen Edukasi']);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'judul_artikel' => 'required|string',
            'deskripsi_artikel' => 'required|string',
            'gambar_artikel' => 'nullable|image|mimes:jpg,png,jpeg|max:5096',
            'nama_author' => 'required|string',
        ]);

        if ($request->hasFile('gambar_artikel')) {
            $filaname = time() . '_' . uniqid() . '.' . $request->file('gambar_artikel')->getClientOriginalExtension();
            $validated['gambar_artikel'] = $request->file('gambar_artikel')->storeAs('img/artikel', $filaname, 'public');
        }

        Artikel::create($validated);
        return redirect()->route('Artikel');
    }
    public function edit($id)
    {
        $datas = Artikel::find($id);
        return view('edukasi/artikel/edit', ['headerTitle' => 'Manajemen Edukasi', 'data' => $datas]);
    }
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'judul_artikel' => 'required|string',
            'deskripsi_artikel' => 'required|string',
            'gambar_artikel' => 'nullable|image|mimes:jpg,png,jpeg|max:5096',
            'nama_author' => 'required|string',
        ]);

        $datas = Artikel::findOrFail($id);

        if ($request->hasFile('gambar_artikel')) {
            // Hapus gambar lama jika ada
            if ($datas->gambar_artikel) {
                Storage::disk('public')->delete($datas->gambar_artikel);
            }

            // Simpan gambar baru
            $filaname = time() . '_' . uniqid() . '.' . $request->file('gambar_artikel')->getClientOriginalExtension();
            $validated['gambar_artikel'] = $request->file('gambar_artikel')->storeAs('img/artikel', $filaname, 'public');
        }

        $datas->update($validated);
        return redirect()->route('Artikel');
    }
    public function destroy($id)
    {
        $datas = Artikel::findOrFail($id);
        if ($datas->gambar_artikel) {
            Storage::disk('public')->delete($datas->gambar_artikel);
        }
        $datas->delete();
        return redirect()->back();
    }
}
