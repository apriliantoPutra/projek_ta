<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProfilController extends Controller
{
    public function index(){
        $userId= Auth::user()->id;
        
        return view('profil.admin.index', ['headerTitle' => 'Profil', ]);
    }
}
