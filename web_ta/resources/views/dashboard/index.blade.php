@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="flex justify-between items-center mb-4">
            <h1 class="text-2xl font-bold text-green-700">Dashboard Admin Bank Sampah</h1>

            <!-- PDF Export Button -->
            <form action="{{ route('PDF') }}" method="POST" class="flex items-center">
                @csrf
                <button type="submit"
                    class="flex items-center bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition-colors duration-200 shadow-md">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24"
                        stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M9 19l3 3m0 0l3-3m-3 3V10" />
                    </svg>
                    Export Laporan Bulanan
                </button>
            </form>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
            <!-- Kartu Total Sampah -->
            <div class="bg-white shadow-md rounded-xl p-5 border-l-4 border-green-500">
                <h2 class="text-gray-700 font-semibold text-lg">Total Sampah</h2>
                <p class="text-2xl font-bold text-green-600 mt-2">{{ $total_sampah }} kg</p>
            </div>

            <!-- Kartu Total Nasabah -->
            <div class="bg-white shadow-md rounded-xl p-5 border-l-4 border-blue-500">
                <h2 class="text-gray-700 font-semibold text-lg">Jumlah Nasabah</h2>
                <p class="text-2xl font-bold text-blue-600 mt-2">{{ $total_nasabah }}</p>
            </div>

            <!-- Kartu Total Transaksi -->
            <div class="bg-white shadow-md rounded-xl p-5 border-l-4 border-yellow-500">
                <h2 class="text-gray-700 font-semibold text-lg">Jumlah Petugas</h2>
                <p class="text-2xl font-bold text-yellow-600 mt-2">{{ $total_petugas }}</p>
            </div>

            <!-- Kartu Saldo Sistem -->
            <div class="bg-white shadow-md rounded-xl p-5 border-l-4 border-red-500">
                <h2 class="text-gray-700 font-semibold text-lg">Tarik Saldo yang diproses</h2>
                <p class="text-2xl font-bold text-red-600 mt-2">Rp {{ $total_saldo_menunggu }}</p>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div class="bg-white rounded-xl shadow-md p-5">
                <h3 class="text-lg font-semibold text-gray-700 mb-2">Grafik Setor Sampah Diterima</h3>
                <div>
                    <canvas id="grafikSetorSampah" height="250"></canvas>
                </div>

            </div>
            <div class="bg-white rounded-xl shadow-md p-5">
                <h3 class="text-lg font-semibold text-gray-700 mb-2">Grafik Penarikan Saldo Diterima</h3>
                <div>
                    <canvas id="grafikTarikSaldo" height="250"></canvas>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const ctx = document.getElementById('grafikTarikSaldo').getContext('2d');
        const chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: {!! json_encode($grafikTarikSaldo->pluck('label')) !!},
                datasets: [{
                    label: 'Jumlah Saldo Ditarik per Hari (Rp)',
                    data: {!! json_encode($grafikTarikSaldo->pluck('total_saldo')) !!},
                    backgroundColor: 'rgba(34,197,94,0.7)',
                    borderColor: 'rgba(34,197,94,1)',
                    borderWidth: 1,
                    borderRadius: 8,
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return 'Rp ' + value.toLocaleString('id-ID');
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: true,
                        labels: {
                            color: '#4B5563'
                        }
                    }
                }
            }
        });
    </script>
    <script>
        const ctxSetor = document.getElementById('grafikSetorSampah').getContext('2d');

        const chartSetor = new Chart(ctxSetor, {
            type: 'bar',
            data: {
                labels: {!! json_encode($grafikSetorSampah->pluck('label')) !!},
                datasets: [{
                    label: 'Berat Sampah Disetor per Hari (kg)',
                    data: {!! json_encode($grafikSetorSampah->pluck('total_berat')) !!},
                    backgroundColor: 'rgba(59,130,246,0.7)', // warna biru
                    borderColor: 'rgba(59,130,246,1)',
                    borderWidth: 1,
                    borderRadius: 8,
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value + ' kg';
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: true,
                        labels: {
                            color: '#4B5563'
                        }
                    }
                }
            }
        });
    </script>
@endsection
