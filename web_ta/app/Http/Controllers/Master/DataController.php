<?php

namespace App\Http\Controllers\Master;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DataController extends Controller
{
    public function index(){

        return view('masterData.index', ['headerTitle'=> 'Master Data']);
    }
}
