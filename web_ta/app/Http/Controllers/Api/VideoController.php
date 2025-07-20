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
            $videos->thumbnail_url = $videos->thumbnail
                ? asset('storage/' . $videos->thumbnail)
                : 'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg';

            $videos->tanggal_format = \Carbon\Carbon::parse($videos->created_at)->translatedFormat('j F Y');
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
            $videos->thumbnail_url = $videos->thumbnail
                ? asset('storage/' . $videos->thumbnail)
                : 'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg';
            $videos->tanggal_format = \Carbon\Carbon::parse($videos->created_at)->translatedFormat('j F Y');
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
        $video->thumbnail_url = $video->thumbnail
            ? asset('storage/' . $video->thumbnail)
            : 'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg';
        $video->tanggal_format = \Carbon\Carbon::parse($video->created_at)->translatedFormat('j F Y');

        return response()->json([
            'success' => true,
            'data' => $video
        ]);
    }
}
