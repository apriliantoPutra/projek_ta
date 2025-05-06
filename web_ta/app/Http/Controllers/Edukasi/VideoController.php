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
}
