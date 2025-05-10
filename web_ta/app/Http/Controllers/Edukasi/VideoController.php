<?php

namespace App\Http\Controllers\Edukasi;

use Illuminate\Http\Request;
use App\Models\Edukasi\Video;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Storage;

class VideoController extends Controller
{
    public function index()
    {
        $datas = Video::all();

        return view('edukasi/video/index', ['headerTitle' => 'Manajemen Edukasi', 'data' => $datas]);
    }
    public function show($id)
    {
        $datas = Video::find($id);

        return view('edukasi/video/show', ['headerTitle' => 'Manajemen Edukasi', 'data' => $datas]);
    }
    public function create()
    {
        return view('edukasi/video/create', ['headerTitle' => 'Manajemen Edukasi']);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'judul_video' => 'required|string',
            'deskripsi_video' => 'required|string',
            'video' => 'nullable|file|mimes:mp4,mov,avi,mpeg|max:51200',


        ]);
        if ($request->hasFile('video')) {
            $filaname = time() . '_' . uniqid() . '.' . $request->file('video')->getClientOriginalExtension();
            $validated['video'] = $request->file('video')->storeAs('video', $filaname, 'public');
        }

        Video::create($validated);
        return redirect()->route('Video');
    }
    public function edit($id)
    {
        $datas = Video::find($id);
        return view('edukasi/video/edit', ['headerTitle' => 'Manajemen Edukasi', 'data' => $datas]);
    }
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'judul_video' => 'required|string',
            'deskripsi_video' => 'required|string',
            'video' => 'nullable|file|mimes:mp4,mov,avi,mpeg|max:51200',
        ]);
        $datas = Video::find($id);
        if ($request->hasFile('video')) {

            if ($datas->video) {
                Storage::disk('public')->delete($datas->video);
            }

            $filaname = time() . '_' . uniqid() . '.' . $request->file('video')->getClientOriginalExtension();
            $validated['video'] = $request->file('video')->storeAs('video', $filaname, 'public');
        }

        $datas->update($validated);
        return redirect()->route('Video');
    }
    public function destroy($id)
    {
        $datas = Video::find($id);
        if ($datas->video) {
            Storage::disk('public')->delete($datas->video);
        }
        $datas->delete();
        return redirect()->back();
    }
}
