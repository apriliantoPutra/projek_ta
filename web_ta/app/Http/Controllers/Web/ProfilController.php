<?php
namespace App\Http\Controllers\Web;
use App\Http\Controllers\Controller;

use App\Models\User;
use App\Models\Profil;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class ProfilController extends Controller
{
    // Profil Admin
    public function index()
    {
        $userId = Auth::user()->id;
        $profil = Profil::where('akun_id', $userId)->first();
        if (!$profil) {

            return redirect()->route('Profil-Tambah');
        }

        $akun = User::find($userId);
        return view('profil.index', ['headerTitle' => 'Profil', 'profil' => $profil, 'akun' => $akun]);
    }
    public function create()
    {
        return view('profil.create', ['headerTitle' => 'Tambah Profil']);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_pengguna' => 'required|string|max:255|unique:profil,nama_pengguna',
            'alamat_pengguna' => 'required|string',
            'no_hp_pengguna' => 'required|string|unique:profil,no_hp_pengguna',
            'gambar_pengguna' => 'nullable|image|mimes:jpg,png,jpeg|max:5096',
            'koordinat_pengguna' => 'required|string'
        ]);

        $gambar_path = null;
        if ($request->hasFile('gambar_pengguna')) {
            $filaname = time() . '_' . uniqid() . '.' . $request->file('gambar_pengguna')->getClientOriginalExtension();
            $gambar_path = $request->file('gambar_pengguna')->storeAs('img/profil', $filaname, 'public');
        }

        $akun_id = Auth::user()->id;

        Profil::create([
            'akun_id' => $akun_id,
            'nama_pengguna' => $request->nama_pengguna,
            'alamat_pengguna' => $request->alamat_pengguna,
            'no_hp_pengguna' => $request->no_hp_pengguna,
            'gambar_pengguna' => $gambar_path,
            'koordinat_pengguna' => $request->koordinat_pengguna,
        ]);

        return redirect()->route('Profil');
    }
    public function edit()
    {
        $admin_id = Auth::user()->id;

        $datas = Profil::where('akun_id', $admin_id)->first();
        return view('profil.edit', ['headerTitle' => 'Edit Profil', 'profil' => $datas]);
    }
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'nama_pengguna' => 'required|string|max:255|unique:profil,nama_pengguna,' . $id,
            'alamat_pengguna' => 'required|string',
            'no_hp_pengguna' => 'required|string|unique:profil,no_hp_pengguna,' . $id,
            'gambar_pengguna' => 'nullable|image|mimes:jpg,png,jpeg|max:5096',
            'koordinat_pengguna' => 'required|string'
        ]);
        $profil = Profil::find($id);

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

        return redirect()->route('Profil');
    }

    // Profil Akun
    public function show($id)
    {
        $profil = Profil::where('akun_id', $id)->first();

        $akun = User::find($id);
        return view('profil.user.index', ['headerTitle' => 'Profil', 'profil' => $profil, 'akun' => $akun]);
    }
}
