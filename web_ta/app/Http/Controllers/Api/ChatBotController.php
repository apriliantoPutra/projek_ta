<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ChatBotController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'message' => 'required|string|max:1000',
        ]);

        $apiKey = env('OPENAI_API_KEY');
        try {
            $response = Http::withHeaders([
                'Authorization' => "Bearer $apiKey",
                'Content-Type' => 'application/json',
            ])->post('https://api.openai.com/v1/chat/completions', [
                'model' => 'gpt-3.5-turbo',
                'messages' => [
                    ['role' => 'user', 'content' => $validated['message']],
                ],
                'max_tokens' => 300,
                'temperature' => 0.7,
                'top_p' => 1.0,
            ]);

            $data = $response->json();

            return response()->json([
                'reply' => $data
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Gagal terhubung ke AI: ' . $e->getMessage(),
            ], 500);
        }
    }
}
