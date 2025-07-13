<?php

namespace App\Http\Controllers\Web\Master;

use App\Http\Controllers\Controller;

use App\Models\Master\JenisSampah;
use App\Models\TotalSampah;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class JenisSampahController extends Controller
{
    public function index(Request $request)
    {
        $query = JenisSampah::query();

        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('nama_sampah', 'like', '%' . $request->search . '%');
            });
        }


        $datas = $query->orderBy('nama_sampah')->paginate(10)->withQueryString();

        return view('masterData.jenisSampah.index', ['headerTitle' => 'Data Sampah', 'search' => $request->search, 'data' => $datas]);
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

        DB::beginTransaction();
        try {

            $jenis_sampah = JenisSampah::create($validated);
            TotalSampah::create([
                'sampah_id' => $jenis_sampah->id,
                'total_berat' => 0
            ]);

            DB::commit();
            return redirect()->route('Jenis-Sampah');
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

        DB::beginTransaction();
        try {

            $datas->update($validated);

            DB::commit();
            return redirect()->route('Jenis-Sampah');
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
    public function destroy($id)
    {
        $datas = JenisSampah::findOrFail($id);
        $total_sampah = TotalSampah::where('sampah_id', '=', $id)->first();

        DB::beginTransaction();
        try {

            $datas->delete();
            $total_sampah->delete();

            DB::commit();
            return redirect()->back();
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
