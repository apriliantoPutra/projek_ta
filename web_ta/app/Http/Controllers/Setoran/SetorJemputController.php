<?php

namespace App\Http\Controllers\Setoran;

use Illuminate\Http\Request;
use App\Models\PengajuanSetor;
use App\Http\Controllers\Controller;

class SetorJemputController extends Controller
{
    public function index(){
        $pengajuan_setor = PengajuanSetor::where('jenis_setor', '=', 'jemput')->get();

        return view('setoranSampah.jemput.index', ['headerTitle'=> 'Setoran Langsung', 'datas'=> $pengajuan_setor]);
    }
}
