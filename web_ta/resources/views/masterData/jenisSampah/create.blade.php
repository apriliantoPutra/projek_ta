@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-add-circle-line text-blue-600 text-2xl"></i> Tambah Data Sampah
                </h1>
            </div>

            <!-- Form -->
            <form action="{{ route('Jenis-Sampah-Store') }}" method="POST" class="space-y-6">
                @csrf
                <div>
                    <label for="nama_sampah" class="block text-sm font-medium text-gray-700 mb-1">Nama Sampah</label>
                    <input type="text" name="nama_sampah" id="nama_sampah"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <div>
                    <label for="satuan" class="block text-sm font-medium text-gray-700 mb-1">Satuan</label>
                    <select name="satuan" id="satuan"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                        <option value="" disabled selected>Pilih Satuan</option>
                        <option value="kg">Kilogram (kg)</option>
                        <option value="pcs">Pieces (pcs)</option>
                    </select>
                </div>

                <div>
                    <label for="harga_per_satuan" class="block text-sm font-medium text-gray-700 mb-1">Harga Per
                        Satuan</label>
                    <input type="text" name="harga_per_satuan" id="harga_per_satuan"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <div>
                    <div class="flex items-center justify-between mb-1">
                        <label for="warna_indikasi" class="block text-sm font-medium text-gray-700">Warna Indikasi</label>
                        <a href="https://htmlcolorcodes.com/color-picker/" target="_blank"
                            class="text-sm text-blue-600 hover:underline">Lihat Color Picker</a>
                    </div>
                    <input type="text" name="warna_indikasi" id="warna_indikasi" placeholder="#00FF00"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <div class="flex justify-end gap-4">
                    <a href="{{ route('Jenis-Sampah') }}"
                        class="px-4 py-2 bg-gray-300 hover:bg-gray-400 text-gray-800 rounded-md transition">Batal</a>
                    <button type="submit"
                        class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md shadow transition">Simpan</button>
                </div>
            </form>
        </div>
    </div>
@endsection
