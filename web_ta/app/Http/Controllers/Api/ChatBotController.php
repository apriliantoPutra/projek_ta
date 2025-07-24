<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ApiKey;
use Illuminate\Http\Request;

class ChatBotController extends Controller
{
    public function apiKey()
    {
        $apiKey = ApiKey::where('nama_api', 'chatbot')->value('api');

        if (!$apiKey) {
            return response()->json([
                'success' => false,
                'message' => 'Api Key chatbot tidak ditemukan',
            ], 404);
        }
        return response()->json([
            'success' => true,
            'data' => $apiKey,
        ]);
    }
}
