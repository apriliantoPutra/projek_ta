@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-search-line"></i> Tambah Edukasi Artikel
                </h1>
            </div>

            <!-- Form -->
            <form action="{{ route('Artikel-Update', $data->id) }}" method="POST" enctype="multipart/form-data" class="space-y-6">
                @csrf
                @method('put')
                <!-- Judul -->
                <div>
                    <label for="judul" class="block text-sm font-medium text-gray-700 mb-1">Judul</label>
                    <input type="text" name="judul_artikel" id="judul"
                        value="{{ old('email', $data->judul_artikel) }}"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <!-- Deskripsi (Trix Editor) -->
                <div>
                    <label for="deskripsi" class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                    <input id="deskripsi" type="hidden" name="deskripsi_artikel"
                        value="{{ old('deskripsi_artikel', $data->deskripsi_artikel) }}">
                    <trix-editor input="deskripsi"
                        class="trix-content bg-white border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"></trix-editor>
                </div>

                <!-- Gambar -->
                <div>
                    <label for="gambar" class="block text-sm font-medium text-gray-700 mb-1">Gambar</label>
                    <input type="file" name="gambar_artikel" id="gambar" accept="image/*"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 bg-white focus:outline-none focus:ring-2 focus:ring-blue-500">

                    @if ($data->gambar_artikel)
                        <div class="mt-3">
                            <p class="text-sm text-gray-500 mb-1">Gambar Saat Ini:</p>
                            <img src="{{ asset('storage/' . $data->gambar_artikel) }}" alt="Gambar Artikel"
                                class="w-48 rounded shadow-md border border-gray-200">
                        </div>
                    @endif
                </div>

                <!-- Author -->
                <div>
                    <label for="author" class="block text-sm font-medium text-gray-700 mb-1">Nama Author</label>
                    <input type="text" name="nama_author" id="author" value="{{ old('nama_author', $data->nama_author) }}"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <!-- Tombol -->
                <div class="flex justify-end gap-4">
                    <a href="{{ route('Artikel') }}"
                        class="px-4 py-2 bg-gray-300 hover:bg-gray-400 text-gray-800 rounded-md transition">Batal</a>
                    <button type="submit"
                        class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md shadow transition">Simpan</button>
                </div>
            </form>
        </div>
    </div>
@endsection
