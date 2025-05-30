@extends('layout.template')
@section('main')
    <div class="py-8 px-4">
        <div class="max-w-7xl mx-auto bg-white rounded-2xl shadow-xl p-8">
            @if ($profil)
                <!-- Header -->
                <div class="text-center mb-10">
                    <h2 class="text-2xl font-bold text-gray-800">Detail Profil Pengguna</h2>
                    <p class="text-gray-500">Informasi akun dan lokasi pengguna</p>
                </div>

                <!-- Isi Profil -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
                    <!-- Foto & Nama -->
                    <div class="flex flex-col items-center">
                        <img src="{{ $profil->gambar_pengguna ? asset('storage/' . $profil->gambar_pengguna) : 'https://i.pravatar.cc/150?img=12' }}"
                            alt="Foto Profil" class="rounded-full w-52 h-52 shadow-lg object-cover border-4 border-green-100">
                        <h3 class="mt-4 text-xl font-semibold text-gray-700">
                            {{ $profil->nama_pengguna ?? 'Nama Tidak Diketahui' }}</h3>
                        <p class="text-sm text-gray-500">{{ ucfirst($akun->role) }}</p>
                    </div>

                    <!-- Informasi Akun -->
                    <div class="lg:col-span-2 space-y-4">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="text-sm font-medium text-gray-600">Username</label>
                                <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                                    {{ $akun->username }}</div>
                            </div>
                            <div>
                                <label class="text-sm font-medium text-gray-600">Email</label>
                                <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                                    {{ $akun->email }}</div>
                            </div>
                        </div>

                        <div>
                            <label class="text-sm font-medium text-gray-600">Alamat</label>
                            <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                                {{ $profil->alamat_pengguna }}</div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="text-sm font-medium text-gray-600">No HP</label>
                                <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                                    {{ $profil->no_hp_pengguna }}</div>
                            </div>
                            <div>
                                <label class="text-sm font-medium text-gray-600">Koordinat Lokasi</label>
                                <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                                    {{ $profil->koordinat_pengguna }}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Peta Lokasi -->
                <div class="mt-10">
                    <h4 class="text-lg font-semibold text-gray-700 mb-3">Peta Lokasi</h4>
                    <div class="rounded-xl overflow-hidden shadow-lg border border-gray-200">
                        <iframe src="https://www.google.com/maps?q={{ $profil->koordinat_pengguna }}&output=embed"
                            allowfullscreen loading="lazy" class="w-full h-96 border-0"
                            referrerpolicy="no-referrer-when-downgrade"></iframe>
                    </div>
                </div>
            @else
                <div class="p-6 bg-yellow-100 text-yellow-800 rounded-md shadow text-center font-medium">
                    Tidak Ada Data Profil
                </div>
            @endif
        </div>
    </div>
@endsection
