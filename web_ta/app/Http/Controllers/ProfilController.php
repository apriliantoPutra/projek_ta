<?php

namespace App\Http\Controllers;

use App\Models\Profil;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProfilController extends Controller
{
    public function index(){
        $userId= Auth::user()->id;
        $profil= Profil::where('akun_id', $userId)->first();

        $akun= User::find($userId);
        return view('profil.index', ['headerTitle' => 'Profil', 'profil'=> $profil, 'akun'=>$akun]);
    }
    public function show($id){
        $profil= Profil::where('akun_id', $id)->first();

        $akun= User::find($id);
        return view('profil.index', ['headerTitle' => 'Profil', 'profil'=> $profil, 'akun'=>$akun]);
    }
}
