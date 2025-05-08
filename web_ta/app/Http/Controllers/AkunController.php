<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AkunController extends Controller
{
    public function index()
    {

        return view('akun/index', ['headerTitle' => 'Manajemen Akun']);
    }
    public function create()
    {

        return view('akun/create', ['headerTitle' => 'Manajemen Akun']);
    }
    public function edit()
    {

        return view('akun/edit', ['headerTitle' => 'Manajemen Akun']);
    }
}
