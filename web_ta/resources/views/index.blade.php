<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Bank Sampah - Kelola Sampah Jadi Berkah</title>
    @vite('resources/css/app.css')
    <link rel="icon" href="{{ asset('img/green.png') }}" type="image/png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://unpkg.com/scrollreveal"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            ScrollReveal().reveal('.fade-in', {
                delay: 200,
                distance: '20px',
                origin: 'bottom',
                easing: 'ease-in-out',
                interval: 100
            });
        });
    </script>
</head>

<body class="font-sans bg-gray-50">
    <!-- Navbar -->
    <nav class="bg-green-600 shadow-md fixed w-full z-10">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-24">
                <div class="flex items-center">
                    <div class="flex-shrink-0 flex items-center">
                        <img class="h-16 w-14" src="{{ asset('/img/White.png') }}" alt="Bank Sampah Logo">
                        <span class="ml-2 text-white font-bold text-xl">Bank Sampah</span>
                    </div>
                </div>
                <div class="hidden md:flex items-center space-x-4">
                    <a href="#home"
                        class="text-white hover:bg-green-700 px-3 py-2 rounded-md text-sm font-medium transition duration-300">Home</a>
                    <a href="#tentang"
                        class="text-white hover:bg-green-700 px-3 py-2 rounded-md text-sm font-medium transition duration-300">Tentang</a>
                    <a href="#layanan"
                        class="text-white hover:bg-green-700 px-3 py-2 rounded-md text-sm font-medium transition duration-300">Layanan</a>
                    <a href="#harga"
                        class="text-white hover:bg-green-700 px-3 py-2 rounded-md text-sm font-medium transition duration-300">Harga</a>
                    <a href="#kontak"
                        class="text-white hover:bg-green-700 px-3 py-2 rounded-md text-sm font-medium transition duration-300">Kontak</a>

                </div>
                <div class="md:hidden flex items-center">
                    <button type="button" class="text-white hover:text-gray-300 focus:outline-none"
                        id="mobile-menu-button">
                        <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M4 6h16M4 12h16M4 18h16"></path>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
        <!-- Mobile menu -->
        <div class="md:hidden hidden bg-green-700" id="mobile-menu">
            <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
                <a href="#home"
                    class="text-white block px-3 py-2 rounded-md text-base font-medium hover:bg-green-600">Home</a>
                <a href="#tentang"
                    class="text-white block px-3 py-2 rounded-md text-base font-medium hover:bg-green-600">Tentang</a>
                <a href="#layanan"
                    class="text-white block px-3 py-2 rounded-md text-base font-medium hover:bg-green-600">Layanan</a>
                <a href="#harga"
                    class="text-white block px-3 py-2 rounded-md text-base font-medium hover:bg-green-600">Harga</a>
                <a href="#kontak"
                    class="text-white block px-3 py-2 rounded-md text-base font-medium hover:bg-green-600">Kontak</a>

            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home"
        class="pt-24 pb-16 md:pt-32 md:pb-24 bg-gradient-to-r from-green-500 to-green-600 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="md:flex md:items-center md:justify-between">
                <div class="md:w-1/2 mb-8 md:mb-0 fade-in">
                    <h1 class="text-4xl md:text-5xl font-bold leading-tight mb-4">Kelola Sampah Jadi Berkah</h1>
                    <p class="text-lg md:text-xl mb-6">Dengan Bank Sampah, sampah Anda memiliki nilai lebih. Setor
                        sampah dan dapatkan saldo yang bisa ditukarkan dengan berbagai manfaat. Download aplikasi Bank Sampah secara gratis.</p>
                    <div class="flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4">
                        <a href="#"
                            class="bg-yellow-400 hover:bg-yellow-500 text-green-800 font-bold py-3 px-6 rounded-lg text-center transition duration-300">Download
                            Aplikasi</a>
                        <a href="#layanan"
                            class="bg-white hover:bg-gray-100 text-green-600 font-bold py-3 px-6 rounded-lg text-center transition duration-300">Pelajari
                            Layanan</a>
                    </div>
                </div>
                <div class="md:w-1/2 fade-in">
                    <img src="https://i.pinimg.com/736x/93/7b/4f/937b4f890fa7a271fcf744b33e00f661.jpg"
                        alt="Bank Sampah Hero" class="rounded-lg shadow-xl w-full">
                </div>
            </div>
        </div>
    </section>

    <!-- Tentang Section -->
    <section id="tentang" class="py-16 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12 fade-in">
                <h2 class="text-3xl md:text-4xl font-bold text-green-600 mb-4">Tentang Bank Sampah</h2>
                <p class="text-lg text-gray-600 max-w-3xl mx-auto">Bank Sampah adalah aplikasi solusi pengelolaan sampah yang
                    inovatif dengan memberikan nilai ekonomis bagi sampah yang Anda setorkan.</p>
            </div>

            <div class="grid md:grid-cols-2 gap-8 items-center fade-in">
                <div>
                    <h3 class="text-2xl font-bold text-green-600 mb-4">Mengapa Memilih Bank Sampah?</h3>
                    <p class="text-gray-600 mb-6">Kami menyediakan sistem pengelolaan sampah yang terintegrasi dengan
                        memberikan manfaat langsung kepada masyarakat. Setiap sampah yang Anda setorkan akan dikonversi
                        menjadi saldo yang bisa digunakan untuk berbagai keperluan.</p>

                    <div class="space-y-4">
                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-green-100 p-2 rounded-full">
                                <svg class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M5 13l4 4L19 7"></path>
                                </svg>
                            </div>
                            <div class="ml-3">
                                <p class="text-gray-700 font-medium">Sistem setor sampah yang mudah</p>
                                <p class="text-gray-500 text-sm">Setor langsung atau jemput sampah ke rumah Anda</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-green-100 p-2 rounded-full">
                                <svg class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M5 13l4 4L19 7"></path>
                                </svg>
                            </div>
                            <div class="ml-3">
                                <p class="text-gray-700 font-medium">Sampah bernilai ekonomis</p>
                                <p class="text-gray-500 text-sm">Konversi sampah menjadi saldo yang bisa dicairkan</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-green-100 p-2 rounded-full">
                                <svg class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M5 13l4 4L19 7"></path>
                                </svg>
                            </div>
                            <div class="ml-3">
                                <p class="text-gray-700 font-medium">Lingkungan lebih bersih</p>
                                <p class="text-gray-500 text-sm">Berkontribusi pada pengurangan sampah di lingkungan
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-green-50 p-6 rounded-lg shadow-md">
                    <img src="https://i.pinimg.com/736x/03/70/58/03705861eaba977a7c83b8732a54e72d.jpg"
                        alt="Proses Bank Sampah" class="rounded-lg w-full">
                </div>
            </div>
        </div>
    </section>

    <!-- Layanan Section -->
    <section id="layanan" class="py-16 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12 fade-in">
                <h2 class="text-3xl md:text-4xl font-bold text-green-600 mb-4">Layanan Kami</h2>
                <p class="text-lg text-gray-600 max-w-3xl mx-auto">Berbagai pilihan layanan untuk memudahkan Anda
                    mengelola sampah</p>
            </div>

            <div class="grid md:grid-cols-2 gap-8 fade-in">
                <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition duration-300">
                    <div class="flex items-center mb-4">
                        <div class="bg-green-100 p-3 rounded-full mr-4">
                            <svg class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"></path>
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-green-600">Setor Langsung</h3>
                    </div>
                    <p class="text-gray-600 mb-4">Anda dapat langsung datang ke lokasi Bank Sampah kami di Tembalang
                        untuk menyetorkan sampah yang sudah dipilah.</p>
                    <ul class="space-y-2 text-gray-600">
                        <li class="flex items-start">
                            <svg class="h-5 w-5 text-green-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M5 13l4 4L19 7"></path>
                            </svg>
                            <span>Buka setiap hari kerja (Senin-Sabtu) jam 08.00-16.00</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="h-5 w-5 text-green-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M5 13l4 4L19 7"></path>
                            </svg>
                            <span>Sampah akan ditimbang dan dicatat sebagai saldo</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="h-5 w-5 text-green-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M5 13l4 4L19 7"></path>
                            </svg>
                            <span>Dapatkan bonus untuk sampah yang sudah dipilah dengan baik</span>
                        </li>
                    </ul>
                </div>

                <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition duration-300">
                    <div class="flex items-center mb-4">
                        <div class="bg-green-100 p-3 rounded-full mr-4">
                            <svg class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z">
                                </path>
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-green-600">Jemput Sampah</h3>
                    </div>
                    <p class="text-gray-600 mb-4">Untuk kenyamanan Anda, kami menyediakan layanan penjemputan sampah
                        langsung dari rumah Anda.</p>
                    <ul class="space-y-2 text-gray-600">
                        <li class="flex items-start">
                            <svg class="h-5 w-5 text-green-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M5 13l4 4L19 7"></path>
                            </svg>
                            <span>Jadwal penjemputan bisa diatur melalui aplikasi</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="h-5 w-5 text-green-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M5 13l4 4L19 7"></path>
                            </svg>
                            <span>Setiap 1 kilometer dikenakan biaya Rp. 1000</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="h-5 w-5 text-green-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M5 13l4 4L19 7"></path>
                            </svg>
                            <span>Saldo akan langsung masuk ke akun Anda setelah sampah diproses</span>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="mt-12 bg-green-50 rounded-lg p-8 text-center fade-in">
                <h3 class="text-2xl font-bold text-green-600 mb-4">Bagaimana Sampah Menjadi Saldo?</h3>
                <div class="grid md:grid-cols-4 gap-6 mt-8">
                    <div class="flex flex-col items-center">
                        <div class="bg-white rounded-full p-4 mb-3 shadow-md">
                            <svg class="h-10 w-10 text-green-600" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10">
                                </path>
                            </svg>
                        </div>
                        <p class="font-medium text-green-700">Pilah Sampah</p>
                        <p class="text-sm text-gray-600 mt-1">Pisahkan sampah berdasarkan jenisnya</p>
                    </div>
                    <div class="flex flex-col items-center">
                        <div class="bg-white rounded-full p-4 mb-3 shadow-md">
                            <svg class="h-10 w-10 text-green-600" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"></path>
                            </svg>
                        </div>
                        <p class="font-medium text-green-700">Setor/Jemput</p>
                        <p class="text-sm text-gray-600 mt-1">Bawa ke bank sampah atau jadwalkan penjemputan</p>
                    </div>
                    <div class="flex flex-col items-center">
                        <div class="bg-white rounded-full p-4 mb-3 shadow-md">
                            <svg class="h-10 w-10 text-green-600" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z">
                                </path>
                            </svg>
                        </div>
                        <p class="font-medium text-green-700">Timbang & Catat</p>
                        <p class="text-sm text-gray-600 mt-1">Sampah ditimbang dan dicatat sesuai jenis</p>
                    </div>
                    <div class="flex flex-col items-center">
                        <div class="bg-white rounded-full p-4 mb-3 shadow-md">
                            <svg class="h-10 w-10 text-green-600" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z">
                                </path>
                            </svg>
                        </div>
                        <p class="font-medium text-green-700">Dapatkan Saldo</p>
                        <p class="text-sm text-gray-600 mt-1">Saldo masuk ke akun dan bisa dicairkan</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Harga Sampah Section -->
    <section id="harga" class="py-16 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12 fade-in">
                <h2 class="text-3xl md:text-4xl font-bold text-green-600 mb-4">Harga Sampah per Kg</h2>
                <p class="text-lg text-gray-600 max-w-3xl mx-auto">Berikut harga sampah yang berlaku saat ini</p>
            </div>

            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6 fade-in">
                @foreach ($data_sampah as $sampah)
                    <div class="border border-green-200 rounded-lg p-6 hover:shadow-md transition duration-300">
                        <div class="flex items-center mb-4">
                            <div class="bg-green-100 p-2 rounded-full mr-3">
                                <svg class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10">
                                    </path>
                                </svg>
                            </div>
                            <h3 class="text-xl font-bold text-green-600">{{ $sampah->nama_sampah }}</h3>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-gray-600">Harga per kg</span>
                            <span class="font-medium text-lg">Rp
                                {{ number_format($sampah->harga_per_satuan, 0, ',', '.') }}</span>
                        </div>
                    </div>
                @endforeach
            </div>

            <div class="mt-8 text-center text-gray-500 text-sm fade-in">
                <p>Harga dapat berubah sesuai dengan kondisi pasar. Informasi lebih lanjut hubungi admin kami.</p>
            </div>
        </div>
    </section>




    <!-- Kontak & Lokasi Section -->
    <section id="kontak" class="py-16 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12 fade-in">
                <h2 class="text-3xl md:text-4xl font-bold text-green-600 mb-4">Hubungi Kami</h2>
                <p class="text-lg text-gray-600 max-w-3xl mx-auto">Kunjungi lokasi kami atau hubungi admin untuk
                    informasi lebih lanjut</p>
            </div>

            <div class="grid md:grid-cols-2 gap-8 fade-in">
                <div class="bg-green-50 p-6 rounded-lg shadow-md">
                    <h3 class="text-xl font-bold text-green-600 mb-4">Informasi Bank Sampah</h3>
                    <div class="space-y-4">
                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-green-100 p-2 rounded-full mr-3">
                                <svg class="h-5 w-5 text-green-600" fill="none" viewBox="0 0 24 24"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z">
                                    </path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                </svg>
                            </div>
                            <div>
                                <p class="font-medium text-gray-700">Alamat</p>
                                <p class="text-gray-600">{{ $bank_sampah->alamat_bank_sampah ?? '' }}</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-green-100 p-2 rounded-full mr-3">
                                <svg class="h-5 w-5 text-green-600" fill="none" viewBox="0 0 24 24"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z">
                                    </path>
                                </svg>
                            </div>
                            <div>
                                <p class="font-medium text-gray-700">Telepon</p>
                                <p class="text-gray-600">{{ $akun_admin->profil->no_hp_pengguna ?? '' }}</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-green-100 p-2 rounded-full mr-3">
                                <svg class="h-5 w-5 text-green-600" fill="none" viewBox="0 0 24 24"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z">
                                    </path>
                                </svg>
                            </div>
                            <div>
                                <p class="font-medium text-gray-700">Email</p>
                                <p class="text-gray-600">{{ $akun_admin->email ?? '' }}</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-green-100 p-2 rounded-full mr-3">
                                <svg class="h-5 w-5 text-green-600" fill="none" viewBox="0 0 24 24"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                            <div>
                                <p class="font-medium text-gray-700">Jam Operasional</p>
                                <p class="text-gray-600">Senin - Sabtu: 08.00 - 16.00 WIB</p>
                                <p class="text-gray-600">Minggu & Hari Libur: Tutup</p>
                            </div>
                        </div>
                    </div>

                    <h3 class="text-xl font-bold text-green-600 mt-8 mb-4">Admin Kami</h3>
                    <div class="bg-white p-4 rounded-lg shadow-sm">
                        <div class="flex items-center">
                            @php
                                $gambar = optional($akun_admin->profil)->gambar_pengguna
                                    ? asset('storage/' . $akun_admin->profil->gambar_pengguna)
                                    : 'https://i.pravatar.cc/100?u=' . $akun_admin->id;
                            @endphp

                            <img src="{{ $gambar }}" alt="Admin 1" class="w-14 h-14 rounded-full mr-3">
                            <div>
                                <p class="font-medium text-gray-700">{{ $akun_admin->profil->nama_pengguna ?? '' }}</p>
                                <p class="text-sm text-gray-500">Koordinator</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="bg-white p-1 rounded-lg shadow-md overflow-hidden">
                    <iframe src="https://www.google.com/maps?q={{ $bank_sampah->koordinat_bank_sampah }}&output=embed"
                        width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-green-800 text-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid md:grid-cols-3 gap-8">
                <div class="mb-8 md:mb-0">
                    <div class="flex items-center mb-4">
                        <img class="h-12 w-12 mr-2" src="{{ asset('/img/White.png') }}" alt="Bank Sampah Logo">
                        <span class="text-xl font-bold">Bank Sampah</span>
                    </div>
                    <p class="text-green-200 mb-4">Kelola sampah dengan bijak, dapatkan manfaat ekonomi, dan jaga
                        kelestarian lingkungan bersama kami.</p>
                    <div class="flex space-x-4">
                        <a href="#" class="text-green-200 hover:text-white transition duration-300">
                            <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24">
                                <path
                                    d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z">
                                </path>
                            </svg>
                        </a>
                        <a href="#" class="text-green-200 hover:text-white transition duration-300">
                            <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24">
                                <path
                                    d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z">
                                </path>
                            </svg>
                        </a>
                        <a href="#" class="text-green-200 hover:text-white transition duration-300">
                            <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24">
                                <path
                                    d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84">
                                </path>
                            </svg>
                        </a>
                        <a href="#" class="text-green-200 hover:text-white transition duration-300">
                            <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24">
                                <path
                                    d="M19.615 3.184c-3.604-.246-11.631-.245-15.23 0-3.897.266-4.356 2.62-4.385 8.816.029 6.185.484 8.549 4.385 8.816 3.6.245 11.626.246 15.23 0 3.897-.266 4.356-2.62 4.385-8.816-.029-6.185-.484-8.549-4.385-8.816zm-10.615 12.816v-8l8 3.993-8 4.007z">
                                </path>
                            </svg>
                        </a>
                    </div>
                </div>

                <div class="mb-8 md:mb-0">
                    <h3 class="text-lg font-semibold mb-4">Tautan Cepat</h3>
                    <ul class="space-y-2">
                        <li><a href="#home" class="text-green-200 hover:text-white transition duration-300">Home</a>
                        </li>
                        <li><a href="#tentang" class="text-green-200 hover:text-white transition duration-300">Tentang
                                Kami</a></li>
                        <li><a href="#layanan"
                                class="text-green-200 hover:text-white transition duration-300">Layanan</a></li>
                        <li><a href="#download"
                                class="text-green-200 hover:text-white transition duration-300">Download Aplikasi</a>
                        </li>
                        <li><a href="#" class="text-green-200 hover:text-white transition duration-300">Syarat &
                                Ketentuan</a></li>
                    </ul>
                </div>

                <div class="mb-8 md:mb-0">
                    <h3 class="text-lg font-semibold mb-4">Layanan</h3>
                    <ul class="space-y-2">
                        <li><a href="#" class="text-green-200 hover:text-white transition duration-300">Setor
                                Sampah</a></li>
                        <li><a href="#" class="text-green-200 hover:text-white transition duration-300">Jemput
                                Sampah</a></li>
                        <li><a href="#" class="text-green-200 hover:text-white transition duration-300">Tukar
                                Saldo</a></li>
                        <li><a href="#" class="text-green-200 hover:text-white transition duration-300">Edukasi
                                Sampah</a></li>
                        <li><a href="#"
                                class="text-green-200 hover:text-white transition duration-300">Pelatihan</a></li>
                    </ul>
                </div>


            </div>

            <div class="border-t border-green-700 mt-8 pt-8 text-center text-green-300">
                <p>&copy; 2023 Bank Sampah Tembalang. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
        // Mobile menu toggle
        document.getElementById('mobile-menu-button').addEventListener('click', function() {
            const menu = document.getElementById('mobile-menu');
            menu.classList.toggle('hidden');
        });

        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                e.preventDefault();

                const targetId = this.getAttribute('href');
                const targetElement = document.querySelector(targetId);

                if (targetElement) {
                    // Close mobile menu if open
                    const mobileMenu = document.getElementById('mobile-menu');
                    if (!mobileMenu.classList.contains('hidden')) {
                        mobileMenu.classList.add('hidden');
                    }

                    // Scroll to target
                    window.scrollTo({
                        top: targetElement.offsetTop - 70,
                        behavior: 'smooth'
                    });
                }
            });
        });

        // Change navbar style on scroll
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('nav');
            if (window.scrollY > 50) {
                navbar.classList.add('shadow-lg');
                navbar.classList.add('bg-green-700');
                navbar.classList.remove('bg-green-600');
            } else {
                navbar.classList.remove('shadow-lg');
                navbar.classList.remove('bg-green-700');
                navbar.classList.add('bg-green-600');
            }
        });
    </script>
</body>

</html>
