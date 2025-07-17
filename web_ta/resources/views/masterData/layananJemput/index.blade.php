@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="max-w-7xl mx-auto bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-truck-line text-green-600 text-2xl"></i>Data Layanan Jemput
                </h1>

                <a href="{{ route('Layanan-Jemput-Edit', $layanan['id']) }}"
                    class="inline-flex items-center px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 transition">
                    <i class="ri-edit-line mr-2"></i>Edit
                </a>
            </div>

            <!-- Detail Data -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <p class="text-sm text-gray-500">Nama Bank Sampah</p>
                    <p class="font-semibold text-gray-800">{{ $layanan['nama_bank_sampah'] }}</p>
                </div>
                <div>
                    <p class="text-sm text-gray-500">Alamat Bank Sampah</p>
                    <p class="font-semibold text-gray-800">{{ $layanan['alamat_bank_sampah'] }}</p>
                </div>
                <div>
                    <p class="text-sm text-gray-500">Latitude</p>
                    <p class="font-semibold text-gray-800">{{ $layanan['latitude'] }}</p>
                </div>
                <div>
                    <p class="text-sm text-gray-500">Longitude</p>
                    <p class="font-semibold text-gray-800">{{ $layanan['longitude'] }}</p>
                </div>
                <div class="md:col-span-2">
                    <p class="text-sm text-gray-500">Biaya Layanan Jemput (per Km)</p>
                    <p class="font-semibold text-gray-800">Rp {{ $layanan['ongkir_per_jarak'] }}</p>
                </div>
            </div>

            <div class="mt-10">
                <h4 class="text-lg font-semibold text-gray-700 mb-3">Peta Lokasi</h4>
                <div class="rounded-xl overflow-hidden shadow-lg border border-gray-200">
                    <iframe src="https://www.google.com/maps?q={{ $layanan['koordinat_bank_sampah'] }}&output=embed"
                        allowfullscreen loading="lazy" class="w-full h-96 border-0"
                        referrerpolicy="no-referrer-when-downgrade"></iframe>

                </div>
            </div>
        </div>
    </div>
@endsection
