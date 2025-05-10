@extends('layout.template')

@section('main')
    <div class="p-4">
        <div class="p-6 bg-white rounded-lg shadow-md overflow-hidden">
            <!-- Judul Video -->
            <div class="px-6 pt-6">
                <h1 class="text-2xl md:text-3xl font-bold text-gray-800 text-center">
                    {{ $data->judul_video }}
                </h1>
            </div>

            <!-- Video -->
            <div class="w-full flex justify-center mt-6 px-4">
                <div class="w-full flex justify-center mt-6 px-4">
                    <div class="w-full max-w-2xl h-[400px]">
                        <iframe class="rounded-lg shadow-md w-full h-full" src="{{ asset('storage/' . $data->video) }}"
                            title="Video Edukasi" frameborder="0"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowfullscreen>
                        </iframe>
                    </div>
            </div>


        </div>

        <!-- Deskripsi -->
        <div class="px-6 py-6 space-y-4">
            <p class="text-gray-700 text-justify leading-relaxed">
                {!! $data->deskripsi_video !!}
            </p>

            <div class="flex justify-end text-sm text-gray-500 pt-2 border-t">
                <span>Rilis: {{ \Carbon\Carbon::parse($data->created_at)->translatedFormat('j F Y') }}</span>
            </div>
        </div>
    </div>
    </div>
@endsection
