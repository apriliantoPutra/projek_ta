<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function sendNotificationToAllUsers($title, $body)
    {
        Notification::create([
            'akun_id' => null, // null = umum
            'title' => $title,
            'body' => $body,
            'sent_at' => now(),
        ]);
    }

    public function sendNotificationToUser($userId, $title, $body)
    {
        Notification::create([
            'akun_id' => $userId,
            'title' => $title,
            'body' => $body,
            'sent_at' => now(),
        ]);
    }
}
