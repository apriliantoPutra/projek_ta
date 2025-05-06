<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AkunController extends Controller
{
    public function index()
    {

        return view('akun/index', ['headerTitle' => 'Manajemen Akun']);
    }
}
