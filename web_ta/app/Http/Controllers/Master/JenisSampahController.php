<?php

namespace App\Http\Controllers\Master;

use App\Http\Controllers\Controller;
use App\Models\Master\JenisSampah;
use Illuminate\Http\Request;

class JenisSampahController extends Controller
{
    public function index()
    {
        $datas = JenisSampah::all();

        return view('masterData.jenisSampah.index', ['headerTitle' => 'Data Sampah', 'datas' => $datas]);
    }
    public function create()
    {

        return view('masterData.jenisSampah.create', ['headerTitle' => 'Tambah Data Sampah']);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_sampah' => 'required|string|unique:jenis_sampah,nama_sampah',
            'satuan' => 'required|string',
            'harga_per_satuan' => 'required|integer',
            'warna_indikasi' => 'required|string',
        ]);

        JenisSampah::create($validated);
        return redirect()->route('Jenis-Sampah');
    }
    public function edit($id)
    {
        $datas = JenisSampah::find($id);

        return view('masterData.jenisSampah.edit', ['headerTitle' => 'Edit Data Sampah', 'jenis_sampah' => $datas]);
    }
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'nama_sampah' => 'required|string|unique:jenis_sampah,nama_sampah,' . $id,
            'satuan' => 'required|string',
            'harga_per_satuan' => 'required|integer',
            'warna_indikasi' => 'required|string',
        ]);
        $datas = JenisSampah::find($id);

        $datas->update($validated);
        return redirect()->route('Jenis-Sampah');
    }
    public function destroy($id)
    {
        $datas = JenisSampah::findOrFail($id);
        $datas->delete();
        return redirect()->back();
    }
}
