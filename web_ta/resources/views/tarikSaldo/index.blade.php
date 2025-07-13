@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">

            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-search-line"></i> Tarik Saldo Warga
                </h1>
                {{-- <a href="#" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">+ Tambah
                    Data</a> --}}
            </div>


            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4 gap-4">
                <form method="GET" action="{{ route('Tarik-Saldo') }}" class="flex w-full md:w-1/2 gap-2">
                    <input type="text" name="search" value="{{ request('search') }}" placeholder="Cari nama warga"
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
                            <th class="px-5 py-3">Username</th>
                            <th class="px-5 py-3">Jumlah Saldo</th>
                            <th class="px-5 py-3">Metode</th>
                            <th class="px-5 py-3">No Rekening</th>
                            <th class="px-5 py-3">Status</th>
                            <th class="px-5 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse ($datas as $data)
                            <tr class="hover:bg-gray-50">
                                <td class="px-5 py-3">{{ $loop->iteration }}</td>
                                <td class="px-5 py-3">{{ $data['user']['username'] }}</td>
                                <td class="px-5 py-3">{{ $data['jumlah_saldo'] }}</td>
                                <td class="px-5 py-3">{{ $data['metode'] }}</td>
                                <td class="px-5 py-3">{{ $data['nomor_tarik_saldo'] }}</td>
                                <td
                                    class="px-5 py-3 font-semibold
                                        @if ($data['status'] === 'menunggu') text-yellow-600
                                        @elseif ($data['status'] === 'terima') text-green-600
                                        @elseif ($data['status'] === 'tolak') text-red-600 @endif
                                    ">
                                    @if ($data['status'] === 'menunggu')
                                        Proses
                                    @elseif ($data['status'] === 'terima')
                                        Diterima
                                    @elseif ($data['status'] === 'tolak')
                                        Ditolak
                                    @endif
                                </td>

                                <td class="px-5 py-3 space-x-2">
                                    @if ($data['status'] === 'tolak')
                                        <span class="text-gray-400 cursor-not-allowed">Detail</span>
                                    @elseif ($data['status'] === 'menunggu')
                                        <a href="{{ route('Tarik-Saldo-Detail', $data['id']) }}"
                                            class="text-blue-600 hover:underline">Detail</a>

                                        <form action="{{ route('Tarik-Saldo-Terima', $data['id']) }}" method="POST"
                                            class="inline">
                                            @csrf
                                            @method('PUT')
                                            <button type="submit"
                                                class="text-green-600 hover:underline bg-transparent border-none p-0 m-0 cursor-pointer">
                                                Terima
                                            </button>
                                        </form>

                                        <form action="{{ route('Tarik-Saldo-Tolak', $data['id']) }}" method="POST"
                                            class="inline">
                                            @csrf
                                            @method('PUT')
                                            <button type="submit"
                                                class="text-red-600 hover:underline bg-transparent border-none p-0 m-0 cursor-pointer">
                                                Tolak
                                            </button>
                                        </form>
                                    @else
                                        <a href="{{ route('Tarik-Saldo-Detail', $data['id']) }}"
                                            class="text-blue-600 hover:underline">Detail</a>
                                    @endif
                                </td>


                            </tr>
                        @empty
                            <tr>
                                <td colspan="6" class="px-5 py-8 text-center text-gray-500 italic">
                                    Tidak ada data tarik saldo.
                                </td>
                            </tr>
                        @endforelse

                    </tbody>
                </table>
                <div class="mt-4 flex justify-end">
                    {{ $paginated->links('vendor.pagination.tailwind') }}
                </div>

            </div>

        </div>
    </div>
@endsection
