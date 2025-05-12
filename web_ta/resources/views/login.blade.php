<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Bank Sampah</title>
    <link rel="icon" href="{{ asset('img/logo.png') }}" type="image/png">
    @vite('resources/css/app.css')
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">

</head>

<body>
    <section class="bg-gray-100 h-screen ">
        <div class="grid lg:grid-cols-2 h-full">
            <div class="bg-cover bg-center" style="background-image: url('img/wallpaper.jpg')">
                <div class="flex items-end justify-center h-full p-2">
                    <p class="text-white text-lg">Copyright © All rights reserved.</p>
                </div>
            </div>
            <div class="flex items-center justify-center p-5 ">
                <div class="p-8 border border-slate-400 bg-white rounded-xl shadow-lg w-full max-w-md">
                    <div class="mb-5 flex justify-center">
                        <img src="img/logo.png" alt="Logo" class="w-28">
                    </div>
                    <h2 class="text-xl font-bold text-center text-gray-800 mb-4">Selamat Datang di Bank Sampah</h2>
                    @if (session()->has('loginError'))
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            {{ session('loginError') }}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                aria-label="Close"></button>
                        </div>
                    @endif
                    <form action="/login" method="post">
                        @csrf
                        <div class="mb-4 space-y-2">
                            <label for="username" class="text-lg font-medium text-gray-700 block">Username</label>
                            <input type="text" id="username" name="username" autocomplete="off"
                                class="w-full p-3 bg-gray-50 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
                                placeholder="Masukkan username Anda" required>
                        </div>
                        <div class="mb-4 space-y-2">
                            <label for="password" class="text-lg font-medium text-gray-700 block">Password</label>
                            <input type="password" id="password" name="password"
                                class="w-full p-3 bg-gray-50 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
                                placeholder="Masukkan password Anda" required>
                        </div>
                        <button type="submit"
                            class="w-full py-3 text-white font-semibold bg-indigo-600 rounded-lg hover:bg-indigo-700 transition duration-300">
                            Login
                        </button>
                    </form>
                </div>
            </div>


        </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous">
    </script>
</body>

</html>
