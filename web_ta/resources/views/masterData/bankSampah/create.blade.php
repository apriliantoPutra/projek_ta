@extends('layout.template')

@section('main')
    <div class="p-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 gap-3">
                <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="ri-search-line"></i> Tambah Data
                </h1>
            </div>

            <form action="{{ route('Bank-Sampah-Store') }}" method="POST" class="space-y-6">
                @csrf
                <div>
                    <label for="nama_bank_sampah" class="block text-sm font-medium text-gray-700 mb-1">Nama Bank
                        Sampah</label>
                    <input type="text" name="nama_bank_sampah" id="nama_bank_sampah"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <div>
                    <label for="deskripsi_bank_sampah"
                        class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                    <textarea id="deskripsi_bank_sampah" name="deskripsi_bank_sampah" rows="4"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required></textarea>
                </div>

                <div>
                    <label for="alamat_bank_sampah" class="block text-sm font-medium text-gray-700 mb-1">Alamat
                        Bank Sampah</label>
                    <input type="text" name="alamat_bank_sampah" id="alamat_bank_sampah"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>

                <div>
                    <label for="koordinat_bank_sampah" class="block text-sm font-medium text-gray-700 mb-1">Koordinat
                        Bank Sampah</label>
                    <input type="text" name="koordinat_bank_sampah" id="koordinat_bank_sampah"
                        placeholder="-7.051354290226383, 110.4374793951377"
                        class="w-full border border-gray-300 rounded-md px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required>
                </div>
                <div class="flex justify-end gap-4">

                    <button type="submit"
                        class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md shadow transition">Simpan</button>
                </div>
            </form>
        </div>
    </div>
@endsection
