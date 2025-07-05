<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Edukasi\Video;
use Illuminate\Http\Request;

class VideoController extends Controller
{
    public function index()
    {
        $videos = Video::orderBy('created_at', 'desc')->get()->map(function ($videos) {
            $videos->video_url = asset('storage/' . $videos->video);
            return $videos;
        });

        return response()->json([
            'success' => true,
            'data' => $videos
        ]);
    }
    public function terbaru()
    {
        $videos = Video::orderBy('created_at', 'desc')->take(5)->get()->map(function ($videos) {
            $videos->video_url = asset('storage/' . $videos->video);
            return $videos;
        });

        return response()->json([
            'success' => true,
            'data' => $videos
        ]);
    }

    public function show($id)
    {
        $video = Video::find($id);

        if (!$video) {
            return response()->json([
                'success' => false,
                'message' => 'Video tidak ditemukan'
            ], 404);
        }

        $video->video_url = asset('storage/' . $video->video);

        return response()->json([
            'success' => true,
            'data' => $video
        ]);
    }
}
