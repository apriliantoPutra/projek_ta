<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{
    public function detailNotifikasi()
    {
        $akunId = Auth::id();

        $notifs = Notification::where(function ($q) use ($akunId) {
            $q->whereNull('akun_id') // notifikasi umum
                ->orWhere('akun_id', '=', $akunId); // notifikasi khusus user
        })
            ->orderBy('sent_at', 'desc')
            ->limit(6)
            ->get();


        return response()->json([
            'success' => true,
            'data' => $notifs,
        ]);
    }
}
