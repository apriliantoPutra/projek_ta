@extends('layout.template')

@section('main')
    <div class="p-2">
        <h1 class="text-2xl font-bold text-green-700 mb-4">Dashboard Admin Bank Sampah</h1>

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

        <!-- Grafik & Info Tambahan -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Placeholder Grafik -->
            <div class="bg-white rounded-xl shadow-md p-5">
                <h3 class="text-lg font-semibold text-gray-700 mb-2">Grafik Penarikan Saldo Diterima</h3>
                <div>
                    <canvas id="grafikTarikSaldo" height="250"></canvas>
                </div>
            </div>


            <!-- Info Ringkasan -->
            <div class="bg-white rounded-xl shadow-md p-5">
                <h3 class="text-lg font-semibold text-gray-700 mb-2">Grafik Setor Sampah Diterima</h3>
                <div>
                    <canvas id="grafikSetorSampah" height="250"></canvas>
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
