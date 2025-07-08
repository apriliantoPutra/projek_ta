@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">

            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-search-line"></i> Setoran Sampah Warga
                </h1>
                {{-- <a href="#" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">+ Tambah
                    Data</a> --}}
            </div>


            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4 gap-4">
                <!-- Input & Tombol Search -->
                <div class="flex w-full md:w-1/2 gap-2">
                    <input type="text" placeholder="Cari nama warga"
                        class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    <button class="bg-gray-200 text-sm px-4 py-2 rounded hover:bg-green-600 hover:text-white transition">
                        Search
                    </button>
                </div>

                <!-- Filter Role -->
                <div>
                    <span class="font-medium mr-2">Filter Status:</span>
                    <button class=" text-sm px-3 py-1 rounded bg-green-500 text-white">Langsung</button>
                    <button class="bg-gray-200 text-sm px-3 py-1 rounded hover:bg-green-500 hover:text-white transition">
                        Jemput</button>

                </div>
            </div>


            <!-- Tabel Akun -->
            <div class="overflow-x-auto">
                <table class="min-w-full text-sm text-left text-gray-700 border border-gray-200 rounded-lg">
                    <thead class="bg-green-600 text-white">
                        <tr>
                            <th class="px-5 py-3">#</th>
                            <th class="px-5 py-3">Username</th>
                            <th class="px-5 py-3">Tanggal Pengajuan</th>
                            <th class="px-5 py-3">Status</th>
                            <th class="px-5 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse ($datas as $data)
                            <tr class="hover:bg-gray-50">
                                <td class="px-5 py-3">{{ $loop->iteration }}</td>
                                <td class="px-5 py-3">{{ $data['user']['username'] }}</td>
                                <td class="px-5 py-3">{{ $data['waktu_pengajuan'] }}</td>
                                <td
                                    class="px-5 py-3 font-semibold
                                        @if ($data['status_pengajuan'] === 'menunggu') text-yellow-600
                                        @elseif ($data['status_pengajuan'] === 'diterima') text-green-600
                                        @elseif ($data['status_pengajuan'] === 'batalkan') text-red-600 @endif
                                    ">
                                    @if ($data['status_pengajuan'] === 'menunggu')
                                        Proses
                                    @elseif ($data['status_pengajuan'] === 'diterima')
                                        Diterima
                                    @elseif ($data['status_pengajuan'] === 'batalkan')
                                        Ditolak
                                    @endif
                                </td>

                                <td class="px-5 py-3 space-x-2">
                                    @if ($data['status_pengajuan'] === 'batalkan')
                                        <span class="text-gray-400 cursor-not-allowed">Detail</span>
                                    @else
                                        <a href="{{ route('Setor-Langsung-Detail', $data['id']) }}"
                                            class="text-blue-600 hover:underline">Detail</a>
                                    @endif
                                </td>

                            </tr>
                        @empty
                            <tr>
                                <td colspan="6" class="px-5 py-8 text-center text-gray-500 italic">
                                    Tidak ada data setor langsung.
                                </td>
                            </tr>
                        @endforelse

                    </tbody>
                </table>
            </div>

        </div>
    </div>
@endsection
