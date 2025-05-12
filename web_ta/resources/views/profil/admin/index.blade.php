@extends('layout.template')

@section('main')
    <div class="p-4">
        <div class="bg-white shadow-md rounded-lg p-6 max-w-4xl mx-auto">
            <!-- Header -->
            <h2 class="text-2xl font-bold text-gray-800 mb-6 border-b pb-2">Profil Pengguna</h2>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Gambar Profil -->
                <div class="flex flex-col items-center">
                    <img src="https://i.pravatar.cc/150?img=12" alt="Foto Profil" class="rounded-full w-32 h-32 shadow-md">
                    <p class="mt-3 text-lg font-semibold text-gray-700">Nama Lengkap</p>
                    <p class="text-sm text-gray-500">Mahasiswa Informatika</p>
                </div>

                <!-- Informasi Akun -->
                <div class="md:col-span-2 space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-600">Username</label>
                        <div class="mt-1 p-2 bg-gray-100 rounded-md text-gray-800">dummyuser123</div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-600">Email</label>
                        <div class="mt-1 p-2 bg-gray-100 rounded-md text-gray-800">dummyuser@mail.com</div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-600">Alamat</label>
                        <div class="mt-1 p-2 bg-gray-100 rounded-md text-gray-800">
                            Jl. Pendidikan No.123, Kota Edukasi, Indonesia
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-600">No HP</label>
                            <div class="mt-1 p-2 bg-gray-100 rounded-md text-gray-800">+62 812-3456-7890</div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-600">Koordinat Lokasi</label>
                            <div class="mt-1 p-2 bg-gray-100 rounded-md text-gray-800">-6.200000, 106.816666</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Gambar Maps -->
            <div class="mt-6">
                <label class="block text-sm font-medium text-gray-600 mb-2">Peta Lokasi</label>
                <img src="https://maps.googleapis.com/maps/api/staticmap?center=-6.200000,106.816666&zoom=14&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C-6.200000,106.816666&key=YOUR_GOOGLE_MAPS_API_KEY"
                    alt="Peta Lokasi" class="rounded-md shadow w-full max-w-3xl mx-auto">
                <p class="text-xs text-gray-400 mt-1">*Gambar peta dummy, ganti dengan API key jika tersedia</p>
            </div>
        </div>
    </div>
@endsection
