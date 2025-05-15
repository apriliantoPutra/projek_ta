@extends('layout.template')

@section('main')
    <div class="p-4">
        <div class="p-6 bg-white rounded-lg shadow-md overflow-hidden">
            <!-- Gambar Artikel -->
            <div class="w-full flex justify-center p-4">
                <img src="{{ asset('storage/' . $data->gambar_artikel) }}" alt="Gambar Artikel"
                    class="rounded-lg shadow-md w-2xl h-auto">
            </div>

            <!-- Konten -->
            <div class="p-6 space-y-4">
                <h1 class="text-3xl font-bold text-gray-800 text-center">
                    {{ $data->judul_artikel }}
                </h1>

                <p class="text-gray-700 text-justify leading-relaxed">
                    {!! $data->deskripsi_artikel !!}
                </p>

                <div class="flex justify-between items-center text-sm text-gray-500 pt-4 border-t">
                    <span>Author: <strong>{{ $data->nama_author }}</strong></span>
                    <span>Rilis: {{ \Carbon\Carbon::parse($data->created_at)->translatedFormat('j F Y') }}</span>
                </div>
            </div>
        </div>
    </div>
@endsection
