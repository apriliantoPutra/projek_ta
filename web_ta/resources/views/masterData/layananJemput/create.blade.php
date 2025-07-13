@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-add-circle-line text-blue-600 text-2xl"></i> Tambah Data Layanan Jemput
                </h1>
            </div>

            <!-- Form -->
            <form action="{{ route('Layanan-Jemput-Store') }}" method="POST" class="space-y-6">
                @csrf

                <div>
                    <label for="bank_sampah_id" class="block text-sm font-medium text-gray-700 mb-1">Pilih Bank</label>
                    <select name="bank_sampah_id" id="bank_sampah_id"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                        <option value="" disabled selected>Pilih Satuan</option>
                        @foreach ($bankSampah as $data)
                            <option value="{{ $data->id }}">{{ $data->nama_bank_sampah }}</option>
                        @endforeach
                    </select>
                </div>
                <div>
                    <label for="ongkir_per_jarak" class="block text-sm font-medium text-gray-700 mb-1">Ongkos Per KM</label>
                    <input type="text" name="ongkir_per_jarak" id="ongkir_per_jarak"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>
                <div class="flex justify-end gap-4">
                    <a href="#"
                        class="px-4 py-2 bg-gray-300 hover:bg-gray-400 text-gray-800 rounded-md transition">Batal</a>
                    <button type="submit"
                        class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md shadow transition">Simpan</button>
                </div>
            </form>
        </div>
    </div>
@endsection
