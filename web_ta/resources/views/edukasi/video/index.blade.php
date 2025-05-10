@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-video-line"></i> Edukasi Video
                </h1>
                <a href="/video-tambah" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">+
                    Tambah
                    Video</a>
            </div>


            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4 gap-4">
                <!-- Input & Tombol Search -->
                <div class="flex w-full md:w-1/2 gap-2">
                    <input type="text" placeholder="Cari judul video"
                        class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    <button
                        class="bg-gray-200 text-sm px-4 py-2 rounded cursor-pointer hover:bg-green-600 hover:text-white transition">
                        Search
                    </button>
                </div>

                <!-- Filter Role -->
                <div>
                    <span class="font-medium mr-2">Jenis Edukasi:</span>
                    <a href="/artikel"
                        class="bg-gray-200 text-sm px-3 py-1 rounded hover:bg-green-500 hover:text-white transition">Artikel</a>
                    <button
                        class="bg-green-500 text-white text-sm px-3 py-1 rounded hover:bg-green-500 hover:text-white transition">Video</button>

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
                            <th class="px-5 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse ($data as $video)
                            <tr class="hover:bg-gray-50">
                                <td class="px-5 py-3">{{ $loop->iteration }}</td>
                                <td class="px-5 py-3">{{ $video->judul_video }}</td>
                                <td class="px-5 py-3">
                                    {{ \Carbon\Carbon::parse($video->created_at)->translatedFormat('j F Y') }}</td>
                                <td class="px-5 py-3 space-x-2">
                                    <a href="{{ route('Video-Edit', $video->id) }}"
                                        class="text-yellow-600 hover:underline">Edit</a>
                                    <a href="{{ route('Video-Detail', $video->id) }}"
                                        class="text-blue-600 hover:underline">Detail</a>
                                    <form action="{{ route('Video-Hapus', $video->id) }}" method="POST" class="inline">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit"
                                            onclick="return confirm('Yakin ingin menghapus video ini?')"
                                            class="text-red-600 hover:underline">
                                            Hapus
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="4" class="px-5 py-8 text-center text-gray-500 italic">
                                    Tidak ada data Edukasi Video.
                                </td>
                            </tr>
                        @endforelse


                    </tbody>
                </table>
            </div>

        </div>
    </div>
@endsection
