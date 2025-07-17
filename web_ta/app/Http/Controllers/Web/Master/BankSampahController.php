<?php

namespace App\Http\Controllers\Web\Master;
use App\Http\Controllers\Controller;

use App\Models\Master\BankSampah;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class BankSampahController extends Controller
{
    public function index()
    {
        $akun_admin_id = Auth::user()->id;
        $datas = BankSampah::with(['user.profil']) // eager load user dan profil user
            ->where('admin_id', $akun_admin_id)
            ->first();

        if (!$datas) {
            return redirect()->route('Bank-Sampah-Tambah');
        }
        return view('masterData.bankSampah.index', ['headerTitle' => 'Data Bank Sampah', 'bank_sampah' => $datas]);
    }
    public function create()
    {


        return view('masterData.bankSampah.create', ['headerTitle' => 'Tambah Data Bank Sampah']);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_bank_sampah' => 'required|string',
            'deskripsi_bank_sampah' => 'required|string',
            'alamat_bank_sampah' => 'required|string',
            'koordinat_bank_sampah' => 'required|string',
        ]);
        $akun_id = Auth::user()->id;


        BankSampah::create([
            'admin_id' => $akun_id,
            'nama_bank_sampah' => $request->nama_bank_sampah,
            'deskripsi_bank_sampah' => $request->deskripsi_bank_sampah,
            'alamat_bank_sampah' => $request->alamat_bank_sampah,
            'koordinat_bank_sampah' => $request->koordinat_bank_sampah,
        ]);

        return redirect()->route('Bank-Sampah');
    }
    public function edit()
    {
        $akun_id = Auth::user()->id;
        $datas = BankSampah::where('admin_id', $akun_id)->first();

        return view('masterData.bankSampah.edit', ['headerTitle' => 'Edit Data Bank Sampah', 'bank_sampah' => $datas]);
    }
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'nama_bank_sampah' => 'required|string',
            'deskripsi_bank_sampah' => 'required|string',
            'alamat_bank_sampah' => 'required|string',
            'koordinat_bank_sampah' => 'required|string',
        ]);
        $datas = BankSampah::find($id);

        $datas->update($validated);

        return redirect()->route('Bank-Sampah');
    }
}
