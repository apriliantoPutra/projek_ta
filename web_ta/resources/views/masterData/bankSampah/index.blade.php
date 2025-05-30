@extends('layout.template')
@section('main')
    <div class="py-8 px-4">
        <div class="max-w-7xl mx-auto bg-white rounded-2xl shadow-xl p-8">

            <!-- Header -->
            <div class="text-center mb-10">
                <h2 class="text-2xl font-bold text-gray-800">Detail Bank Data</h2>
                <p class="text-gray-500">Informasi Seputar Bank Data</p>
            </div>

            <!-- Isi Profil -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
                <!-- Foto & Nama -->
                <div class="flex flex-col items-center">
                    <img src="{{ $bank_sampah->user->profil->gambar_pengguna ? asset('storage/' . $bank_sampah->user->profil->gambar_pengguna) : 'https://i.pravatar.cc/150?img=12' }}"
                        alt="Foto Profil" class="rounded-full w-52 h-52 shadow-lg object-cover border-4 border-green-100">
                    <h3 class="mt-4 text-xl font-semibold text-gray-700">
                        {{ $bank_sampah->user->profil->nama_pengguna }}</h3>
                    <p class="text-sm text-gray-500">{{ $bank_sampah->user->username }}</p>
                    <a href="{{ route('Bank-Sampah-Edit') }}"
                        class="mt-4 inline-block px-5 py-2 bg-blue-600 text-white text-sm font-semibold rounded-md shadow hover:bg-blue-700 transition">
                        Edit Data
                    </a>
                </div>

                <!-- Informasi Akun -->
                <div class="lg:col-span-2 space-y-4">

                    <div>
                        <label class="text-sm font-medium text-gray-600">Nama Bank Sampah</label>
                        <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                            {{ $bank_sampah->nama_bank_sampah }}</div>
                    </div>
                    <div>
                        <label class="text-sm font-medium text-gray-600">Deskripsi Bank Sampah</label>
                        <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                            {{ $bank_sampah->deskripsi_bank_sampah }}</div>
                    </div>

                    <div>
                        <label class="text-sm font-medium text-gray-600">Alamat Bank Sampah</label>
                        <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                            {{ $bank_sampah->alamat_bank_sampah }}</div>
                    </div>

                    <div>
                        <label class="text-sm font-medium text-gray-600">No HP Admin</label>
                        <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                            {{ $bank_sampah->user->profil->no_hp_pengguna }}</div>
                    </div>
                    <div>
                        <label class="text-sm font-medium text-gray-600">Koordinat Lokasi</label>
                        <div class="mt-1 p-3 bg-gray-50 rounded-md border shadow-sm text-gray-800">
                            {{ $bank_sampah->koordinat_bank_sampah }}</div>
                    </div>

                </div>
            </div>

            <!-- Peta Lokasi -->
            <div class="mt-10">
                <h4 class="text-lg font-semibold text-gray-700 mb-3">Peta Lokasi</h4>
                <div class="rounded-xl overflow-hidden shadow-lg border border-gray-200">
                    <iframe src="https://www.google.com/maps?q={{ $bank_sampah->koordinat_bank_sampah }}&output=embed"
                        allowfullscreen loading="lazy" class="w-full h-96 border-0"
                        referrerpolicy="no-referrer-when-downgrade"></iframe>
                    {{-- <iframe src="https://www.google.com/maps?q={{ $profil->koordinat_pengguna }}&output=embed"
                            allowfullscreen loading="lazy" class="w-full h-96 border-0"
                            referrerpolicy="no-referrer-when-downgrade"></iframe> --}}
                </div>
            </div>

        </div>
    </div>
@endsection
