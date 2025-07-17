<aside id="sidebar-menu" class=" w-64 bg-gray-800 text-gray-100 flex flex-col justify-between md:flex">
    <div class="flex-1 flex flex-col justify-between"> <!-- pembungkus utama -->

        <!-- Bagian Atas (Logo + Navigasi) -->
        <div>
            <div class="px-5 py-2 text-center bg-green-300 text-white">
                <img src="/img/logo.png" alt="Logo" class="w-17 mx-auto">
            </div>
            <nav class="px-4 py-4 space-y-2 overflow-auto">
                <a href="/dashboard"
                    class="flex items-center px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                    <i class="ri-dashboard-line mr-3"></i> Dashboard
                </a>
                <a href="/akun"
                    class="flex items-center px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                    <i class="ri-user-line mr-3"></i> Akun
                </a>

                <div class="rounded-lg border-b border-gray-700">
                    <button onclick="toggleDropdown('dropdownButton')"
                        class="flex items-center justify-between w-full px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors">
                        <span><i class="ri-database-2-line mr-3"></i>Master Data</span>
                        <i class="ri-arrow-down-s-line"></i>
                    </button>
                    <div id="dropdownButton" class="hidden flex-col space-y-1 pl-10 mt-2">
                        <a href="{{ route('Jenis-Sampah') }}"
                            class="block px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                            Jenis Sampah
                        </a>
                        <a href="{{ route('Bank-Sampah') }}"
                            class="block px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors ">
                            Bank Sampah
                        </a>
                        <a href="{{ route('Layanan-Jemput') }}"
                            class="block px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors ">
                            Layanan Jemput
                        </a>
                    </div>
                </div>

                <div class="rounded-lg border-b border-gray-700">
                    <button onclick="toggleDropdown('dropdownButton2')"
                        class="flex items-center justify-between w-full px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors">
                        <span><i class="ri-recycle-line mr-3"></i>Setor Sampah</span>
                        <i class="ri-arrow-down-s-line"></i>
                    </button>
                    <div id="dropdownButton2" class="hidden flex-col space-y-1 pl-10 mt-2">
                        <a href="{{ route('Setor-Langsung') }}"
                            class="block px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                            Langsung
                        </a>
                        <a href="{{ route('Setor-Jemput') }}"
                            class="block px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors ">
                            Jemput
                        </a>
                    </div>
                </div>

                <a href="{{ route('Tarik-Saldo') }}"
                    class="flex items-center px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                    <i class="ri-wallet-3-line mr-3"></i> Tarik Saldo
                </a>
                <div class="rounded-lg border-b border-gray-700">
                    <button onclick="toggleDropdown('dropdownButton3')"
                        class="flex items-center justify-between w-full px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors">
                        <span><i class="ri-book-open-line mr-3"></i>Edukasi</span>
                        <i class="ri-arrow-down-s-line"></i>
                    </button>
                    <div id="dropdownButton3" class="hidden flex-col space-y-1 pl-10 mt-2">
                        <a href="{{ route('Artikel') }}"
                            class="block px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                            Artikel
                        </a>
                        <a href="{{ route('Video') }}"
                            class="block px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors ">
                            Video
                        </a>
                    </div>
                </div>


                {{-- <a href="#"
                    class="flex items-center px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                    <i class="ri-robot-2-line mr-3"></i> Chatbot
                </a> --}}
            </nav>
        </div>

        <!-- Bagian Bawah (Footer) -->
        <div class="px-4 py-4 border-t border-gray-700">
            <div class="flex items-center space-x-3 mb-3">
                <img src="/img/profile.jpeg" alt="Foto Profil" class="w-16 h-16 rounded-full object-cover">
                <div>
                    <p class="font-medium text-white">Nama User</p>
                    <p class="text-xs text-gray-400">Admin</p>
                </div>
            </div>
            <div class="flex flex-col space-y-2">
                <a href="{{ route('Profil') }}"
                    class="text-sm bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700 text-center transition">Profil</a>
                <form method="POST" action="/logout">
                    @csrf
                    <button type="submit"
                        class="w-full text-sm bg-red-600 cursor-pointer text-white px-3 py-1 rounded hover:bg-red-700 transition">Logout</button>
                </form>
            </div>
        </div>

    </div>
</aside>
