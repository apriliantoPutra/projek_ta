<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Bank Sampah</title>
    <link rel="icon" href="{{ asset('img/logo.png') }}" type="image/png">
    @vite('resources/css/app.css')
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css" rel="stylesheet" />
</head>

<body class="bg-gray-100 font-sans">
    <div class="flex h-screen">
        {{-- sidebar --}}
        @include('layout.sidebar')

        {{-- content --}}
        <div class="flex-1 flex flex-col">
            {{-- Header --}}
            @include('layout.header')

            {{-- main --}}
            <main class=" overflow-y-auto p-6 space-y-5">
                @yield('main')
            </main>
        </div>
    </div>
    <script>
        function toggleDropdown(id) {
            let element = document.getElementById(id);
            element.classList.toggle('hidden');

            // Hapus 'flex' dan 'md:flex' jika ada
            element.classList.remove('flex', 'md:flex');
        }
    </script>
</body>

</html>
