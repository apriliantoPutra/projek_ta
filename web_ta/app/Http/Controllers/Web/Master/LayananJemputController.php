<?php

namespace App\Http\Controllers\Web\Master;

use App\Http\Controllers\Controller;
use App\Models\Master\BankSampah;
use App\Models\Master\LayananJemput;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LayananJemputController extends Controller
{
    public function index()
    {
        $adminId = Auth::id();
        $data = LayananJemput::whereHas('bankSampah', function ($query) use ($adminId) {
            $query->where('admin_id', $adminId);
        })->with('bankSampah')->first();
        if (!$data) {
            return redirect()->route('Layanan-Jemput-Tambah');
        }

        $koordinat = str_replace(' ', '', $data->bankSampah->koordinat_bank_sampah); // Hilangkan spasi
        $koordinatParts = explode(',', $koordinat);
        $latitude = $koordinatParts[0] ?? null;
        $longitude = $koordinatParts[1] ?? null;

        $layananJemput = [
            'id'=> $data->id,
            'ongkir_per_jarak' => $data->ongkir_per_jarak,
            'nama_bank_sampah' => $data->bankSampah->nama_bank_sampah,
            'alamat_bank_sampah' => $data->bankSampah->alamat_bank_sampah,
            'koordinat_bank_sampah' => $koordinat,
            'latitude'=> $latitude,
            'longitude'=> $longitude
        ];

        return view('masterData.layananJemput.index', ['headerTitle' => 'Data Layanan Jemput', 'layanan' => $layananJemput]);
    }

    public function create()
    {
        $bankSampah = BankSampah::all();

        return view('masterData.layananJemput.create', ['headerTitle' => 'Tambah Layanan Jemput', 'bankSampah' => $bankSampah]);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'bank_sampah_id' => 'required|integer',
            'ongkir_per_jarak' => 'required|integer'
        ]);

        LayananJemput::create($validated);

        return redirect()->route('Layanan-Jemput');
    }
    public function edit($id)
    {
        $bankSampah = BankSampah::all();
        $layananJemput = LayananJemput::find($id);

        return view('masterData.layananJemput.edit', ['headerTitle' => 'Edit Layanan Jemput',  'bankSampah' => $bankSampah, 'layananJemput' => $layananJemput]);
    }
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'bank_sampah_id' => 'required|integer',
            'ongkir_per_jarak' => 'required|integer'
        ]);

        $layananJemput = LayananJemput::find($id);
        $layananJemput->update($validated);
        return redirect()->route('Layanan-Jemput');
    }
}
