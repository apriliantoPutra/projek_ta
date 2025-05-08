<?php

namespace App\Http\Controllers\Edukasi;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class VideoController extends Controller
{
    public function index()
    {

        return view('edukasi/video/index', ['headerTitle' => 'Manajemen Edukasi']);
    }
    public function create()
    {

        return view('edukasi/video/create', ['headerTitle' => 'Manajemen Edukasi']);
    }
    public function edit()
    {

        return view('edukasi/video/edit', ['headerTitle' => 'Manajemen Edukasi']);
    }
}
