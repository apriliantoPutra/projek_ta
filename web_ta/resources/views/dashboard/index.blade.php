@extends('layout.template')

@section('main')
<div class="p-2">
    <h1 class="text-2xl font-bold text-green-700 mb-4">Dashboard Admin Bank Sampah</h1>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
        <!-- Kartu Total Sampah -->
        <div class="bg-white shadow-md rounded-xl p-5 border-l-4 border-green-500">
            <h2 class="text-gray-700 font-semibold text-lg">Total Sampah</h2>
            <p class="text-2xl font-bold text-green-600 mt-2">1.250 kg</p>
        </div>

        <!-- Kartu Total Nasabah -->
        <div class="bg-white shadow-md rounded-xl p-5 border-l-4 border-blue-500">
            <h2 class="text-gray-700 font-semibold text-lg">Jumlah Nasabah</h2>
            <p class="text-2xl font-bold text-blue-600 mt-2">342</p>
        </div>

        <!-- Kartu Total Transaksi -->
        <div class="bg-white shadow-md rounded-xl p-5 border-l-4 border-yellow-500">
            <h2 class="text-gray-700 font-semibold text-lg">Total Transaksi</h2>
            <p class="text-2xl font-bold text-yellow-600 mt-2">Rp 4.500.000</p>
        </div>

        <!-- Kartu Saldo Sistem -->
        <div class="bg-white shadow-md rounded-xl p-5 border-l-4 border-red-500">
            <h2 class="text-gray-700 font-semibold text-lg">Saldo Sistem</h2>
            <p class="text-2xl font-bold text-red-600 mt-2">Rp 1.750.000</p>
        </div>
    </div>

    <!-- Grafik & Info Tambahan -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Placeholder Grafik -->
        <div class="bg-white rounded-xl shadow-md p-5">
            <h3 class="text-lg font-semibold text-gray-700 mb-2">Grafik Setoran Sampah</h3>
            <div class="h-64 flex items-center justify-center text-gray-400">
                <span>📊 Grafik akan ditampilkan di sini</span>
            </div>
        </div>

        <!-- Info Ringkasan -->
        <div class="bg-white rounded-xl shadow-md p-5">
            <h3 class="text-lg font-semibold text-gray-700 mb-2">Info Terbaru</h3>
            <ul class="list-disc list-inside text-gray-600 space-y-2">
                <li>Setoran sampah tertinggi minggu ini dari <strong>Nasabah A</strong>.</li>
                <li>Penyetoran terakhir: 5 Mei 2025 pukul 10.22 WIB.</li>
                <li>Penyuluhan daur ulang dijadwalkan 10 Mei 2025.</li>
            </ul>
        </div>
    </div>
</div>
@endsection
