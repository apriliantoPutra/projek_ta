<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AkunController extends Controller
{
    public function index(Request $request)
    {
        $query = User::where('id', '!=', Auth::user()->id);
        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('username', 'like', '%' . $request->search . '%')
                    ->orWhere('email', 'like', '%' . $request->search . '%');
            });
        }
        if ($request->filled('role')) {
            $query->where('role', $request->role);
        }

        $datas = $query->orderBy('username')->paginate(10)->withQueryString();

        return view('akun/index', ['headerTitle' => 'Manajemen Akun', 'search' => $request->search, 'data' => $datas, 'role' => $request->role]);
    }
    public function create()
    {

        return view('akun/create', ['headerTitle' => 'Manajemen Akun']);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'username' => 'required|max:255|unique:akun,username',
            'email' => 'required|email:dns|unique:akun,email',
            'password' => 'required|min:6',
            'role' => 'required|string|in:warga,petugas,admin',
        ]);

        $validated['password'] = bcrypt($validated['password']);
        User::create($validated);
        return redirect()->route('Akun');
    }

    public function edit($id)
    {
        $datas = User::find($id);
        return view('akun/edit', ['headerTitle' => 'Manajemen Akun', 'data' => $datas]);
    }
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'username' => 'required|max:255|unique:akun,username,' . $id,
            'email' => 'required|email:dns|unique:akun,email,' . $id,
            'password' => 'nullable|min:6',
            'role' => 'required|string|in:warga,petugas,admin',
        ]);

        if ($request->filled('password')) {
            $validated['password'] = bcrypt($validated['password']);
        } else {
            unset($validated['password']);
        }
        $datas = User::find($id);
        $datas->update($validated);
        return redirect()->route('Akun');
    }
    public function destroy($id)
    {
        $datas = User::find($id);
        $datas->delete();
        return redirect()->back();
    }
}
