@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-search-line"></i> Edit Edukasi Video
                </h1>
            </div>

            <!-- Form -->
            <form action="{{ route('Video-Update', $data->id) }}" method="POST" enctype="multipart/form-data" class="space-y-6">
                @csrf
                @method('put')
                <!-- Judul -->
                <div>
                    <label for="judul" class="block text-sm font-medium text-gray-700 mb-1">Judul</label>
                    <input type="text" name="judul_video" id="judul"
                        value="{{ old('judul_video', $data->judul_video) }}"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <!-- Deskripsi -->
                <div>
                    <label for="deskripsi" class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                    <textarea id="deskripsi" name="deskripsi_video" rows="4"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>{{ old('deskripsi_video', $data->deskripsi_video) }}</textarea>
                </div>

                <!-- Upload Video -->
                <div>
                    <label for="video" class="block text-sm font-medium text-gray-700 mb-1">Upload Video</label>
                    <input type="file" name="video" id="video" accept="video/*"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 bg-white focus:outline-none focus:ring-2 focus:ring-blue-500">

                    @if ($data->video)
                        <div class="mt-4">
                            <label class="block text-sm text-gray-600 mb-2">Video Sebelumnya:</label>
                            <video controls class="rounded shadow w-full max-w-md">
                                <source src="{{ asset('storage/' . $data->video) }}" type="video/mp4">
                                Browser Anda tidak mendukung video tag.
                            </video>
                        </div>
                    @endif
                </div>


                <!-- Tombol -->
                <div class="flex justify-end gap-4">
                    <a href="{{ route('Video') }}"
                        class="px-4 py-2 bg-gray-300 hover:bg-gray-400 text-gray-800 rounded-md transition">Batal</a>
                    <button type="submit"
                        class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md shadow transition">Simpan</button>
                </div>
            </form>
        </div>
    </div>
@endsection
