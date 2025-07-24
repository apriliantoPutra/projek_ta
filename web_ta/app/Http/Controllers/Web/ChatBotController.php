<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\ApiKey;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use Illuminate\Http\Request;

class ChatBotController extends Controller
{
    public function index()
    {
        $apikey = ApiKey::where('nama_api', 'chatbot')->first();

        return view('chatbot.index', [
            'headerTitle' => 'Chatbot',
            'apikey' => $apikey ? $apikey->api : null,
            'maxSendCount' => 3 // Sesuai dengan Flutter
        ]);
    }

    public function updateApiKey(Request $request)
    {
        $request->validate(['api_key' => 'required|string']);

        try {
            ApiKey::updateOrCreate(
                ['nama_api' => 'chatbot'],
                ['api' => $request->api_key]
            );

            return back()->with('success', 'API Key updated successfully');
        } catch (\Exception $e) {
            return back()->with('error', 'Failed to update API Key');
        }
    }

    public function chat(Request $request)
    {
        $request->validate([
            'message' => 'required|string',
            'sendCount' => 'required|integer',
            'maxSendCount' => 'required|integer'
        ]);

        $apiKey = ApiKey::where('nama_api', 'chatbot')->value('api');

        if (!$apiKey) {
            return response()->json([
                'error' => 'API Key not configured',
                'remaining' => $request->maxSendCount - $request->sendCount
            ], 400);
        }

        if ($request->sendCount >= $request->maxSendCount) {
            return response()->json([
                'error' => 'Message limit reached',
                'remaining' => 0
            ], 429);
        }

        $client = new Client();

        try {
            $response = $client->post('https://openrouter.ai/api/v1/chat/completions', [
                'headers' => [
                    'Authorization' => 'Bearer ' . $apiKey,
                    'Content-Type' => 'application/json',
                    'HTTP-Referer' => url('/'),
                    'X-Title' => config('app.name')
                ],
                'json' => [
                    'model' => 'deepseek/deepseek-r1:free',
                    'messages' => [
                        ['role' => 'user', 'content' => $request->message]
                    ]
                ],
                'timeout' => 30
            ]);

            $data = json_decode($response->getBody(), true);

            // More robust response checking
            if (!isset($data['choices'][0]['message']['content'])) {
                throw new \Exception('Invalid API response format');
            }

            $reply = $data['choices'][0]['message']['content'];
            $newSendCount = $request->sendCount + 1;
            $remaining = $request->maxSendCount - $newSendCount;

            return response()->json([
                'reply' => $reply,
                'remaining' => $remaining,
                'sendCount' => $newSendCount // Tambahkan ini untuk sync client
            ]);
        } catch (RequestException $e) {
            $response = $e->getResponse();
            $errorBody = $response ? json_decode($response->getBody(), true) : null;

            return response()->json([
                'error' => 'API Error: ' . $e->getMessage(),
                'details' => $errorBody,
                'remaining' => $request->maxSendCount - $request->sendCount,
                'sendCount' => $request->sendCount // Jangan ubah count jika error
            ], $response ? $response->getStatusCode() : 500);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Error: ' . $e->getMessage(),
                'remaining' => $request->maxSendCount - $request->sendCount,
                'sendCount' => $request->sendCount
            ], 500);
        }
    }
}
