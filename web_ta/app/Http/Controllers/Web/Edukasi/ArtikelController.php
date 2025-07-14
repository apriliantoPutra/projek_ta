<?php

namespace App\Http\Controllers\Web\Edukasi;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Web\NotificationController;
use Illuminate\Http\Request;
use App\Models\Edukasi\Artikel;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class ArtikelController extends Controller
{
    public function index(Request $request)
    {
        $query = Artikel::query();
        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('judul_artikel', 'like', '%' . $request->search . '%');
            });
        }
        $datas = $query->orderBy('judul_artikel')->paginate(10)->withQueryString();

        return view('edukasi/artikel/index', ['headerTitle' => 'Manajemen Edukasi', 'search' => $request->search, 'data' => $datas]);
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

        try {
            if ($request->hasFile('gambar_artikel')) {
                $filaname = time() . '_' . uniqid() . '.' . $request->file('gambar_artikel')->getClientOriginalExtension();
                $validated['gambar_artikel'] = $request->file('gambar_artikel')->storeAs('img/artikel', $filaname, 'public');
            }

            Artikel::create($validated);
            app(NotificationController::class)->sendNotificationToAllUsers(
                'Konten Edukasi Baru!',
                'Yuk cek artikel edukasi terbaru yang baru saja ditambahkan.'
            );

            return redirect()->route('Artikel');
        } catch (\Exception $e) {
            DB::rollback();
            Log::error('Gagal menambahkan artikel: ' . $e->getMessage());

            return redirect()->back()->withErrors(['msg' => 'Terjadi kesalahan saat menyimpan data.']);
        }
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
