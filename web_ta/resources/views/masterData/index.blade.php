@extends('layout.template')

@section('main')
    <div class="py-8 px-4">
        <div class="max-w-7xl mx-auto bg-white rounded-2xl shadow-xl p-8">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8 gap-3">
                <h1 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-database-2-line text-green-600 text-3xl"></i>
                    Manajemen Master Data
                </h1>
            </div>

            <!-- Card Container -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Card 1: Jenis Sampah -->
                <div class="bg-green-50 border border-green-200 rounded-xl shadow p-6 flex flex-col justify-between">
                    <div class="flex flex-col items-center text-center space-y-3">
                        <i class="ri-recycle-fill text-4xl text-green-600"></i>
                        <h2 class="text-lg font-semibold text-gray-800">Jenis Sampah</h2>
                        <p class="text-sm text-gray-600">Kelola data kategori jenis sampah yang tersedia dalam sistem.</p>
                    </div>
                    <div class="mt-4 text-center">
                        <a href="{{ route('Jenis-Sampah') }}"
                            class="inline-block bg-green-600 hover:bg-green-700 text-white text-sm font-semibold px-4 py-2 rounded-lg shadow">
                            Kelola
                        </a>
                    </div>
                </div>

                <!-- Card 2: Bank Sampah -->
                <div class="bg-blue-50 border border-blue-200 rounded-xl shadow p-6 flex flex-col justify-between">
                    <div class="flex flex-col items-center text-center space-y-3">
                        <i class="ri-bank-fill text-4xl text-blue-600"></i>
                        <h2 class="text-lg font-semibold text-gray-800">Bank Sampah</h2>
                        <p class="text-sm text-gray-600">Atur informasi bank sampah aktif di berbagai lokasi.</p>
                    </div>
                    <div class="mt-4 text-center">
                        <a href="{{ route('Bank-Sampah') }}"
                            class="inline-block bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-4 py-2 rounded-lg shadow">
                            Kelola
                        </a>
                    </div>
                </div>

                <!-- Card 3: Layanan Jemput -->
                <div class="bg-yellow-50 border border-yellow-200 rounded-xl shadow p-6 flex flex-col justify-between">
                    <div class="flex flex-col items-center text-center space-y-3">
                        <i class="ri-truck-line text-4xl text-yellow-600"></i>
                        <h2 class="text-lg font-semibold text-gray-800">Layanan Jemput</h2>
                        <p class="text-sm text-gray-600">Manajemen layanan penjemputan sampah dari pengguna.</p>
                    </div>
                    <div class="mt-4 text-center">
                        <a href="#"
                            class="inline-block bg-yellow-500 hover:bg-yellow-600 text-white text-sm font-semibold px-4 py-2 rounded-lg shadow">
                            Kelola
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
