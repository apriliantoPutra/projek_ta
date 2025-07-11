<?php

namespace App\Http\Controllers\Web\Setoran;
use App\Http\Controllers\Controller;

use Illuminate\Http\Request;
use App\Models\PengajuanSetor;
use App\Models\InputDetailSetor;
use App\Models\Master\JenisSampah;
use Carbon\Carbon;

class SetorJemputController extends Controller
{
    public function index()
    {
        $pengajuan_setor = PengajuanSetor::with(['user.profil'])
            ->where('jenis_setor', '=', 'jemput')
            ->orderBy('waktu_pengajuan', 'desc')     // urut berdasarkan waktu terbaru
            ->orderBy('id', 'asc')                   // jika waktu sama, ambil yang lebih dulu
            ->get()
            ->map(function ($item) {
                $profil = $item->user->profil;
                return [
                    'id' => $item->id,
                    'jenis_setor' => $item->jenis_setor,
                    'waktu_pengajuan' => Carbon::parse($item->waktu_pengajuan)->isoFormat('dddd, DD/MM/YYYY'),
                    'status_pengajuan' => $item->status_pengajuan,
                    'catatan_petugas' => $item->catatan_petugas,
                    'user' => [
                        'username' => $item->user->username,
                        'email' => $item->user->email,
                        'profil' => [
                            'nama_pengguna' => $profil->nama_pengguna,
                            'alamat_pengguna' => $profil->alamat_pengguna,
                            'no_hp_pengguna' => $profil->no_hp_pengguna,
                            'gambar_pengguna' => $profil->gambar_pengguna,
                            'gambar_url' => asset('storage/' . $profil->gambar_pengguna),
                        ]
                    ]
                ];
            });

        return view('setoranSampah.jemput.index', ['headerTitle' => 'Setoran Jemput', 'datas' => $pengajuan_setor]);
    }

    public function show($id)
    {
        $item = PengajuanSetor::with('user.profil')->find($id);
        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Pengajuan tidak ditemukan',
            ], 404);
        }
        $profil = $item->user->profil;

        // Pengecekan gambar pengguna
        $gambar = $profil?->gambar_pengguna;
        $gambar_url = $gambar ? asset('storage/' . $gambar) : 'https://i.pravatar.cc/150?img=12';

        // Format no HP (jika 08... → ubah ke +62)
        $no_hp = $profil?->no_hp_pengguna;
        if ($no_hp && str_starts_with($no_hp, '0')) {
            $no_hp = '+62 ' . substr($no_hp, 1);
        }

        $pengajuan_setor = [
            'id' => $item->id,
            'jenis_setor' => $item->jenis_setor,
            'waktu_pengajuan' => Carbon::parse($item->waktu_pengajuan)->isoFormat('dddd, DD/MM/YYYY'),
            'status_pengajuan' => $item->status_pengajuan,
            'catatan_petugas' => $item->catatan_petugas,
            'user' => [
                'username' => $item->user->username,
                'email' => $item->user->email,
                'profil' => [
                    'nama_pengguna' => $profil->nama_pengguna,
                    'alamat_pengguna' => $profil->alamat_pengguna,
                    'no_hp_pengguna' => $no_hp,
                    'gambar_pengguna' => $gambar,
                    'gambar_url' => $gambar_url,
                    'koordinat_pengguna'=> $profil->koordinat_pengguna
                ]
            ],

        ];
        $item_detail = InputDetailSetor::with('user')->where('pengajuan_id', '=', $pengajuan_setor['id'])->first();

        $detail_setor = null; // Default null

        if ($item_detail) {
            $decoded_sampah = json_decode($item_detail->setoran_sampah, true);

            // Gabungkan dengan nama_sampah dari tabel jenis_sampah
            $setoran_detail = [];
            foreach ($decoded_sampah as $sampah) {
                $jenis = JenisSampah::find($sampah['jenis_sampah_id']);
                $setoran_detail[] = [
                    'jenis_sampah_id' => $sampah['jenis_sampah_id'],
                    'nama_sampah' => $jenis ? $jenis->nama_sampah : 'Tidak diketahui',
                    'berat' => $sampah['berat'],
                ];
            }

            $detail_setor = [
                'id' => $item_detail->id,
                'setoran_sampah' => $setoran_detail,
                'total_berat' => $item_detail->total_berat,
                'total_harga' => $item_detail->total_harga,
                'status_setor' => $item_detail->status_setor,
            ];
        }



        return view('setoranSampah.jemput.show', [
            'headerTitle' => 'Setoran Langsung',
            'pengajuan' => $pengajuan_setor,
            'detail' => $detail_setor
        ]);
    }
}
