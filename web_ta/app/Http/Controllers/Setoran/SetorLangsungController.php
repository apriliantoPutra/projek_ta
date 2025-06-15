<?php

namespace App\Http\Controllers\Setoran;

use Illuminate\Http\Request;
use App\Models\PengajuanSetor;
use App\Http\Controllers\Controller;

class SetorLangsungController extends Controller
{
    public function index(){
        $pengajuan_setor = PengajuanSetor::where('jenis_setor', '=', 'langsung')->get();

        return view('setoranSampah.langsung.index', ['headerTitle'=> 'Setoran Langsung', 'datas'=> $pengajuan_setor]);
    }
}
