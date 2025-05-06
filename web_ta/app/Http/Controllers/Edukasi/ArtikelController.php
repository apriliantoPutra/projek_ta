<?php

namespace App\Http\Controllers\Edukasi;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ArtikelController extends Controller
{
    public function index()
    {

        return view('edukasi/artikel/index', ['headerTitle' => 'Manajemen Edukasi']);
    }
}
