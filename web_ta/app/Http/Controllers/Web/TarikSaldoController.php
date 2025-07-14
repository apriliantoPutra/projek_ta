<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;

use App\Models\Saldo;
use App\Models\TarikSaldo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TarikSaldoController extends Controller
{
    // admin
    public function index(Request $request)
    {
        $query = TarikSaldo::with('user');

        if ($request->filled('search')) {
            $query->whereHas('user', function ($q) use ($request) {
                $q->where('username', 'like', '%' . $request->search . '%');
            });
        }
        $tarik_saldo = $query->latest()->paginate(10)->withQueryString();
        $datas = $tarik_saldo->map(function ($item) {
            return [
                'id' => $item->id,
                'jumlah_saldo' => $item->jumlah_saldo,
                'status' => $item->status,
                'metode' => $item->metode,
                'nomor_tarik_saldo' => $item->nomor_tarik_saldo,
                'pesan' => $item->pesan ?? '',
                'user' => [
                    'username' => $item->user->username,
                    'email' => $item->user->email,
                ]
            ];
        });

        return view('tarikSaldo.index', [
            'headerTitle' => 'Tarik Saldo',
            'datas' => $datas,
            'paginated' => $tarik_saldo,
            'search' => $request->search,
        ]);
    }


    public function show($id)
    {
        $item = TarikSaldo::with('user.profil')->find($id);
        $profil = $item->user->profil;
        // Pengecekan gambar pengguna
        $gambar = $profil?->gambar_pengguna;
        $gambar_url = $gambar ? asset('storage/' . $gambar) : 'https://i.pravatar.cc/150?img=12';

        // Format no HP (jika 08... → ubah ke +62)
        $no_hp = $profil?->no_hp_pengguna;
        if ($no_hp && str_starts_with($no_hp, '0')) {
            $no_hp = '+62 ' . substr($no_hp, 1);
        }

        $tarik_saldo = [
            'id' => $item->id,
            'jumlah_saldo' => $item->jumlah_saldo,
            'status' => $item->status,
            'metode' => $item->metode,
            'nomor_tarik_saldo' => $item->nomor_tarik_saldo,
            'pesan' => $item->pesan,
            'user' => [
                'username' => $item->user->username,
                'email' => $item->user->email,
                'profil' => [
                    'nama_pengguna' => $profil->nama_pengguna,
                    'alamat_pengguna' => $profil->alamat_pengguna,
                    'no_hp_pengguna' => $no_hp,
                    'gambar_pengguna' => $gambar,
                    'gambar_url' => $gambar_url,
                ]
            ],
        ];

        return view('tarikSaldo.show', ['headerTitle' => 'Tarik Saldo', 'tarik_saldo' => $tarik_saldo]);
    }
    public function terimaTarikSaldo($id)
    {
        $tarik_saldo = TarikSaldo::find($id);
        $saldo = Saldo::where('warga_id', '=', $tarik_saldo->warga_id)->first();

        DB::beginTransaction();
        try {
            $tarik_saldo->update([
                'status' => 'terima',
            ]);


            $saldo->update([
                "total_saldo" => $saldo->total_saldo - $tarik_saldo->jumlah_saldo
            ]);
            app(NotificationController::class)->sendNotificationToUser(
                $tarik_saldo->warga_id,
                'Verifikasi Tarik Saldo!',
                'Permintaan tarik saldo Anda telah disetujui.'
            );

            DB::commit();
            return redirect()->back();
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(
                [
                    "success" => false,
                    "message" => $e->getMessage()

                ]
            );
        }
    }

    public function tolakTarikSaldo($id)
    {
        $tarik_saldo = TarikSaldo::find($id);

        DB::beginTransaction();
        try {
            $tarik_saldo->update([
                'status' => 'tolak',
            ]);

            app(NotificationController::class)->sendNotificationToUser(
                $tarik_saldo->warga_id,
                'Verifikasi Tarik Saldo!',
                'Permintaan tarik saldo Anda telah ditolak.'
            );

            DB::commit();
            return redirect()->back();
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(
                [
                    "success" => false,
                    "message" => $e->getMessage()

                ]
            );
        }
    }
}
