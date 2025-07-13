@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-article-line"></i> Edukasi Artikel
                </h1>
                <a href="/artikel-tambah" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">+
                    Tambah
                    Artikel</a>
            </div>


            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4 gap-4">
                <form method="GET" action="{{ route('Artikel') }}" class="flex w-full md:w-1/2 gap-2">
                    <input type="text" name="search" value="{{ request('search') }}" placeholder="Cari Judul Artikel"
                        class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    <button type="submit"
                        class="bg-gray-200 text-sm px-4 py-2 rounded hover:bg-green-600 hover:text-white transition">
                        Search
                    </button>
                </form>
            </div>


            <!-- Tabel Akun -->
            <div class="overflow-x-auto">
                <table class="min-w-full text-sm text-left text-gray-700 border border-gray-200 rounded-lg">
                    <thead class="bg-green-600 text-white">
                        <tr>
                            <th class="px-5 py-3">#</th>
                            <th class="px-5 py-3">Judul</th>
                            <th class="px-5 py-3">Tanggal Rilis</th>
                            <th class="px-5 py-3">Gambar</th>
                            <th class="px-5 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse ($data as $artikel)
                            <tr class="hover:bg-gray-50">
                                <td class="px-5 py-3">{{ $loop->iteration }}</td>

                                {{-- Judul Artikel --}}
                                <td class="px-5 py-3">{{ $artikel->judul_artikel }}</td>

                                {{-- Tanggal Rilis --}}
                                <td class="px-5 py-3">
                                    {{ \Carbon\Carbon::parse($artikel->created_at)->translatedFormat('j F Y') }}
                                </td>

                                {{-- Gambar Artikel --}}
                                <td class="px-5 py-3">
                                    <img src="{{ asset('storage/' . $artikel->gambar_artikel) }}" alt="Gambar Artikel"
                                        class="w-16 h-16 object-cover rounded shadow">
                                </td>

                                {{-- Aksi --}}
                                <td class="px-5 py-3 space-x-2">
                                    <a href="{{ route('Artikel-Edit', $artikel->id) }}"
                                        class="text-yellow-600 hover:underline">Edit</a>
                                    <a href="{{ route('Artikel-Detail', $artikel->id) }}"
                                        class="text-blue-600 hover:underline">Detail</a>
                                    <form action="{{ route('Artikel-Hapus', $artikel->id) }}" method="POST" class="inline">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit"
                                            onclick="return confirm('Yakin ingin menghapus artikel ini?')"
                                            class="text-red-600 cursor-pointer hover:underline">
                                            Hapus
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="5" class="px-5 py-8 text-center text-gray-500 italic">
                                    Tidak ada data akun.
                                </td>
                            </tr>
                        @endforelse


                    </tbody>
                </table>
                <div class="mt-4 flex justify-end">
                    {{ $data->links('vendor.pagination.tailwind') }}
                </div>
            </div>

        </div>
    </div>
@endsection
