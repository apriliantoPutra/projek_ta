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
                <a href="{{ route('Master-Data') }}"
                    class="flex items-center px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                    <i class="ri-database-2-line mr-3"></i> Master Data

                </a>
                <a href="{{ route('Setor-Langsung') }}"
                    class="flex items-center px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                    <i class="ri-recycle-line mr-3"></i> Setoran Sampah
                </a>
                <a href="#"
                    class="flex items-center px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                    <i class="ri-wallet-3-line mr-3"></i> Tarik Saldo
                </a>
                <a href="/artikel"
                    class="flex items-center px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                    <i class="ri-book-open-line mr-3"></i> Edukasi
                </a>
                <a href="#"
                    class="flex items-center px-4 py-2 text-lg rounded-lg hover:bg-green-600 hover:text-white transition-colors border-b border-gray-700">
                    <i class="ri-robot-2-line mr-3"></i> Chatbot
                </a>
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
