@extends('layout.template')
@section('main')
    <div class="py-8 px-4">
        <div class="max-w-7xl mx-auto bg-white rounded-2xl shadow-xl p-8">

            <!-- Header -->
            <div class="text-center mb-10">
                <h2 class="text-2xl font-bold text-gray-800">Detail Setoran Jemput</h2>
                <p class="text-gray-500">Informasi pengguna dan detail sampah yang disetorkan</p>
            </div>

            <!-- Profil dan Lokasi -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start mb-12">
                <!-- Foto & Nama -->
                <div class="flex flex-col items-center">
                    <img src="{{ $pengajuan['user']['profil']['gambar_url'] }}" alt="Foto Profil"
                        class="rounded-full w-44 h-44 shadow-lg object-cover border-4 border-green-100">
                    <h3 class="mt-4 text-xl font-semibold text-gray-700">{{ $pengajuan['user']['profil']['nama_pengguna'] }}
                    </h3>
                    <h3
                        class="mt-4 text-xl font-semibold
                            @if ($detail['status_setor'] === 'proses') text-yellow-600
                            @elseif ($detail['status_setor'] === 'selesai')
                                text-green-600 @endif">
                        {{ ucfirst($detail['status_setor']) }}
                    </h3>

                </div>

                <!-- Info Akun -->
                <div class="lg:col-span-2 space-y-4">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="text-sm font-medium text-gray-600">Username</label>
                            <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                                {{ $pengajuan['user']['username'] }}
                            </div>
                        </div>
                        <div>
                            <label class="text-sm font-medium text-gray-600">Email</label>
                            <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                                {{ $pengajuan['user']['email'] }}
                            </div>
                        </div>
                    </div>

                    <div>
                        <label class="text-sm font-medium text-gray-600">Alamat</label>
                        <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                            {{ $pengajuan['user']['profil']['alamat_pengguna'] }}
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="text-sm font-medium text-gray-600">No HP</label>
                            <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                                {{ $pengajuan['user']['profil']['no_hp_pengguna'] }}

                            </div>
                        </div>
                        <div>
                            <label class="text-sm font-medium text-gray-600">Koordinat</label>
                            <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                                {{ $pengajuan['user']['profil']['koordinat_pengguna'] }}

                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <!-- Tanggal dan Catatan -->
            <div class="mb-10 grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="text-sm font-medium text-gray-600">Tanggal Pengajuan</label>
                    <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                        {{ $pengajuan['waktu_pengajuan'] }}
                    </div>
                </div>
                <div>
                    <label class="text-sm font-medium text-gray-600">Catatan Petugas</label>
                    <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                        {{ $pengajuan['catatan_petugas'] }}
                    </div>
                </div>
            </div>


            <!-- Detail Sampah -->
            @if (!empty($detail) && isset($detail['setoran_sampah']) && is_array($detail['setoran_sampah']))
                <div class="mb-8">
                    <h4 class="text-lg font-semibold text-gray-700 mb-4">Detail Sampah</h4>
                    <div class="overflow-x-auto">
                        <table class="min-w-full bg-white border border-gray-200 rounded-lg shadow">
                            <thead class="bg-gray-100 text-left text-gray-600">
                                <tr>
                                    <th class="py-3 px-4">No</th>
                                    <th class="py-3 px-4">Jenis Sampah</th>
                                    <th class="py-3 px-4">Berat (kg)</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                @foreach ($detail['setoran_sampah'] as $setoran)
                                    <tr>
                                        <td class="py-3 px-4">{{ $loop->iteration }}.</td>
                                        <td class="py-3 px-4">{{ $setoran['nama_sampah'] }}</td>
                                        <td class="py-3 px-4">{{ $setoran['berat'] }} kg</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Total Berat dan Harga -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="text-sm font-medium text-gray-600">Total Berat</label>
                        <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                            {{ $detail['total_berat'] ?? '-' }} kg
                        </div>
                    </div>
                    <div>
                        <label class="text-sm font-medium text-gray-600">Total Harga</label>
                        <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                            Rp {{ $detail['total_harga'] ?? '0' }}
                        </div>
                    </div>
                </div>
            @else
                <div class="text-center py-6 text-gray-500 italic">
                    Belum ada data setoran sampah.
                </div>
            @endif

            <!-- Peta -->
            <div class="mt-10">
                <h4 class="text-lg font-semibold text-gray-700 mb-3">Peta Lokasi</h4>
                <div class="rounded-xl overflow-hidden shadow-lg border border-gray-200">
                    <iframe
                        src="https://www.google.com/maps?q={{ $pengajuan['user']['profil']['koordinat_pengguna'] }}&output=embed"
                        class="w-full h-96 border-0" allowfullscreen loading="lazy"></iframe>
                </div>
            </div>
        </div>
    </div>
@endsection
