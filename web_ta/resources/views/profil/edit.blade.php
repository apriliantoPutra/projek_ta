@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-search-line"></i> Edit Data Profil
                </h1>
            </div>

            <form action="{{ route('Profil-Update', $profil->id) }}" method="POST" enctype="multipart/form-data" class="space-y-6">
                @csrf
                @method('put')
                <div>
                    <label for="nama_pengguna" class="block text-sm font-medium text-gray-700 mb-1">Nama Pengguna</label>
                    <input type="text" name="nama_pengguna" id="nama_pengguna"
                        value="{{ old('nama_pengguna', $profil->nama_pengguna) }}"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <div>
                    <label for="alamat_pengguna" class="block text-sm font-medium text-gray-700 mb-1">Alamat
                        Pengguna</label>
                    <input type="text" name="alamat_pengguna" id="alamat_pengguna"
                        value="{{ old('alamat_pengguna', $profil->alamat_pengguna) }}"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <div>
                    <label for="no_hp_pengguna" class="block text-sm font-medium text-gray-700 mb-1">No HP Pengguna</label>
                    <input type="text" name="no_hp_pengguna" id="no_hp_pengguna"
                        value="{{ old('no_hp_pengguna', $profil->no_hp_pengguna) }}"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <div>
                    <label for="gambar_pengguna" class="block text-sm font-medium text-gray-700 mb-1">Gambar Profil</label>
                    <div class="mb-2">
                        <img src="{{ $profil->gambar_pengguna ? asset('storage/' . $profil->gambar_pengguna) : asset('img/profile.jpeg') }}"
                            alt="Foto Sebelumnya" class="w-32 h-32 rounded-full object-cover border shadow">
                    </div>
                    <input type="file" name="gambar_pengguna" id="gambar_pengguna" accept="image/*"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 bg-white focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="koordinat_pengguna" class="block text-sm font-medium text-gray-700 mb-1">Koordinat
                        Pengguna</label>
                    <input type="text" name="koordinat_pengguna" id="koordinat_pengguna"
                        value="{{ old('koordinat_pengguna', $profil->koordinat_pengguna) }}"
                        placeholder="-7.051354290226383, 110.4374793951377"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>
                <div class="flex justify-end gap-4">
                    <a href="{{ route('Profil') }}"
                        class="px-4 py-2 bg-gray-300 hover:bg-gray-400 text-gray-800 rounded-md transition">Batal</a>
                    <button type="submit"
                        class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md shadow transition">Simpan</button>
                </div>
            </form>
        </div>
    </div>
@endsection
