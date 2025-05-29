@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">

            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-search-line"></i> Data Akun
                </h1>
                <a href="/akun-tambah" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">+
                    Tambah
                    Akun</a>
            </div>


            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4 gap-4">
                <!-- Input & Tombol Search -->
                <div class="flex w-full md:w-1/2 gap-2">
                    <input type="text" placeholder="Cari nama atau email..."
                        class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    <button
                        class="bg-gray-200 cursor-pointer text-sm px-4 py-2 rounded hover:bg-green-600 hover:text-white transition">
                        Search
                    </button>
                </div>

                <!-- Filter Role -->
                <div>
                    <span class="font-medium mr-2">Filter Role:</span>
                    <button
                        class="bg-gray-200 text-sm px-3 py-1 rounded hover:bg-green-500 hover:text-white transition">Admin</button>
                    <button
                        class="bg-gray-200 text-sm px-3 py-1 rounded hover:bg-green-500 hover:text-white transition">Petugas</button>
                    <button
                        class="bg-gray-200 text-sm px-3 py-1 rounded hover:bg-green-500 hover:text-white transition">Nasabah</button>
                </div>
            </div>


            <!-- Tabel Akun -->
            <div class="overflow-x-auto">
                <table class="min-w-full text-sm text-left text-gray-700 border border-gray-200 rounded-lg">
                    <thead class="bg-green-600 text-white">
                        <tr>
                            <th class="px-5 py-3">#</th>
                            <th class="px-5 py-3">Nama</th>
                            <th class="px-5 py-3">Email</th>
                            <th class="px-5 py-3">Role</th>
                            <th class="px-5 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse ($data as $akun)
                            <tr class="hover:bg-gray-50">
                                <td class="px-5 py-3">{{ $loop->iteration }}.</td>
                                <td class="px-5 py-3">{{ $akun->username }}</td>
                                <td class="px-5 py-3">{{ $akun->email }}</td>
                                <td class="px-5 py-3">{{ $akun->role }}</td>
                                <td class="px-5 py-3 space-x-2">
                                    <a href="{{ route('Akun-Edit', $akun->id) }}"
                                        class="text-yellow-600 hover:underline">Edit</a>
                                    <a href="{{ route('Profil-Akun', $akun->id) }}"
                                        class="text-blue-600 hover:underline">Profil</a>
                                    <form action="{{ route('Akun-Hapus', $akun->id) }}" method="POST" class="inline">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" onclick="return confirm('Yakin ingin menghapus akun ini?')"
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
            </div>

        </div>
    </div>
@endsection
