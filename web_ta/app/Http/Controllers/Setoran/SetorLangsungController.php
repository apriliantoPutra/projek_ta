<?php

namespace App\Http\Controllers\Setoran;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class SetorLangsungController extends Controller
{
    public function index(){
        return view('setoranSampah.langsung.index', ['headerTitle'=> 'Setoran Langsung']);
    }
}
