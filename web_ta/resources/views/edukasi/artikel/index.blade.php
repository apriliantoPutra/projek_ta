@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-article-line"></i> Edukasi Artikel
                </h1>
                <a href="/artikel-tambah" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">+ Tambah
                    Artikel</a>
            </div>


            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4 gap-4">
                <!-- Input & Tombol Search -->
                <div class="flex w-full md:w-1/2 gap-2">
                    <input type="text" placeholder="Cari judul edukasi"
                        class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    <button class="bg-gray-200 text-sm px-4 py-2 rounded hover:bg-green-600 hover:text-white transition">
                        Search
                    </button>
                </div>

                <!-- Filter Role -->
                <div>
                    <span class="font-medium mr-2">Jenis Edukasi:</span>
                    <button
                        class="bg-gray-200 text-sm px-3 py-1 rounded hover:bg-green-500 hover:text-white transition">Artikel</button>
                    <a
                        href="/video" class="bg-gray-200 text-sm px-3 py-1 rounded hover:bg-green-500 hover:text-white transition">Video</a>

                </div>
            </div>


            <!-- Tabel Akun -->
            <div class="overflow-x-auto">
                <table class="min-w-full text-sm text-left text-gray-700 border border-gray-200 rounded-lg">
                    <thead class="bg-green-600 text-white">
                        <tr>
                            <th class="px-5 py-3">#</th>
                            <th class="px-5 py-3">Judul</th>
                            <th class="px-5 py-3">Tanggal</th>
                            <th class="px-5 py-3">Gambar</th>
                            <th class="px-5 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr class="hover:bg-gray-50">
                            <td class="px-5 py-3">1</td>
                            <td class="px-5 py-3">Pelihara Lingkungan</td>
                            <td class="px-5 py-3">6 Maret 2025</td>
                            <td class="px-5 py-3">Foto</td>
                            <td class="px-5 py-3 space-x-2">
                                <a href="#" class="text-yellow-600 hover:underline">Edit</a>
                                <a href="#" class="text-blue-600 hover:underline">Detail</a>
                                <a href="#" class="text-red-600 hover:underline">Hapus</a>
                            </td>
                        </tr>
                        <tr class="hover:bg-gray-50">
                            <td class="px-5 py-3">2</td>
                            <td class="px-5 py-3">Sampah Anorganik</td>
                            <td class="px-5 py-3">6 Maret 2025</td>
                            <td class="px-5 py-3">Foto</td>
                            <td class="px-5 py-3 space-x-2">
                                <a href="#" class="text-yellow-600 hover:underline">Edit</a>
                                <a href="#" class="text-blue-600 hover:underline">Detail</a>
                                <a href="#" class="text-red-600 hover:underline">Hapus</a>
                            </td>
                        </tr>
                        <tr class="hover:bg-gray-50">
                            <td class="px-5 py-3">3</td>
                            <td class="px-5 py-3">Sampah Organik</td>
                            <td class="px-5 py-3">6 Maret 2025</td>
                            <td class="px-5 py-3">Foto</td>
                            <td class="px-5 py-3 space-x-2">
                                <a href="#" class="text-yellow-600 hover:underline">Edit</a>
                                <a href="#" class="text-blue-600 hover:underline">Detail</a>
                                <a href="#" class="text-red-600 hover:underline">Hapus</a>
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>

        </div>
    </div>
@endsection
