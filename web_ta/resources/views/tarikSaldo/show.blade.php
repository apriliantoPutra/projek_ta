@extends('layout.template')
@section('main')
    <div class="py-8 px-4">
        <div class="max-w-5xl mx-auto bg-white rounded-2xl shadow-xl p-8">

            <!-- Header -->
            <div class="text-center mb-10">
                <h2 class="text-2xl font-bold text-gray-800">Detail Penarikan Saldo</h2>
                <p class="text-gray-500">Informasi pengguna dan rincian penarikan</p>
            </div>

            <!-- Profil -->
            <div class="flex flex-col items-center mb-10">
                <img src="{{ $tarik_saldo['user']['profil']['gambar_url'] }}" alt="Foto Profil"
                    class="rounded-full w-36 h-36 object-cover shadow-md border-4 border-green-100">
                <h3 class="mt-4 text-xl font-semibold text-gray-800">{{ $tarik_saldo['user']['username'] }}</h3>
                <p class="text-gray-600">{{ $tarik_saldo['user']['email'] }}</p>
                <p class="text-gray-500">{{ $tarik_saldo['user']['profil']['alamat_pengguna'] }}</p>
                <p class="text-gray-500">{{ $tarik_saldo['user']['profil']['no_hp_pengguna'] }}</p>
            </div>

            @php
                // Format jumlah saldo
                $formatted_saldo = 'Rp. ' . number_format($tarik_saldo['jumlah_saldo'], 0, ',', '.');

                // Status tampilan
                $status_text = '';
                $status_class = '';
                if ($tarik_saldo['status'] === 'menunggu') {
                    $status_text = 'Menunggu Verifikasi';
                    $status_class = 'text-yellow-600';
                } elseif ($tarik_saldo['status'] === 'terima') {
                    $status_text = 'Verifikasi Diterima';
                    $status_class = 'text-green-600';
                }

                // Metode tampilan
                $metode = $tarik_saldo['metode'];
                if (in_array($metode, ['BCA', 'BNI'])) {
                    $metode_display = "Transfer Bank ($metode)";
                } elseif (in_array($metode, ['Dana', 'ShopeePay'])) {
                    $metode_display = "E-Wallet ($metode)";
                } else {
                    $metode_display = $metode;
                }
            @endphp

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 text-gray-800">

                <div>
                    <label class="text-sm text-gray-500">Jumlah Penarikan</label>
                    <div class="mt-1 p-4 rounded-lg border bg-gray-50 shadow-sm text-xl font-semibold text-green-600">
                        {{ $formatted_saldo }}
                    </div>
                </div>

                <div>
                    <label class="text-sm text-gray-500">Status</label>
                    <div class="mt-1 p-3 rounded-lg border bg-gray-50 shadow-sm text-md font-semibold {{ $status_class }}">
                        {{ $status_text }}
                    </div>
                </div>

                <div>
                    <label class="text-sm text-gray-500">Metode Penarikan</label>
                    <div class="mt-1 p-3 rounded-lg border bg-gray-50 shadow-sm">
                        {{ $metode_display }}
                    </div>
                </div>

                <div>
                    <label class="text-sm text-gray-500">Nomor Penarikan</label>
                    <div class="mt-1 p-3 rounded-lg border bg-gray-50 shadow-sm">
                        {{ $tarik_saldo['nomor_tarik_saldo'] }}
                    </div>
                </div>

                <div class="md:col-span-2">
                    <label class="text-sm text-gray-500">Pesan Tambahan</label>
                    <div class="mt-1 p-3 rounded-lg border bg-gray-50 shadow-sm">
                        {{ $tarik_saldo['pesan'] ?? 'Tidak ada Pesan!' }}
                    </div>
                </div>

            </div>

        </div>
    </div>
@endsection
