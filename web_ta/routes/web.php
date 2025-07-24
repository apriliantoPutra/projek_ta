<?php

use App\Http\Controllers\Web\AkunController;
use App\Http\Controllers\Web\ChatBotController;
use App\Http\Controllers\Web\DashboardController;
use App\Http\Controllers\Web\Edukasi\ArtikelController;
use App\Http\Controllers\Web\Edukasi\VideoController;
use App\Http\Controllers\Web\LandingPageController;
use App\Http\Controllers\Web\LoginController;
use App\Http\Controllers\Web\Master\BankSampahController;
use App\Http\Controllers\Web\Master\DataController;
use App\Http\Controllers\Web\Master\JenisSampahController;
use App\Http\Controllers\Web\Master\LayananJemputController;
use App\Http\Controllers\Web\ProfilController;
use App\Http\Controllers\Web\Setoran\SetorJemputController;
use App\Http\Controllers\Web\Setoran\SetorLangsungController;
use App\Http\Controllers\Web\TarikSaldoController;
use Illuminate\Support\Facades\Route;

Route::get('/', [LandingPageController::class, 'index'])->name('Landing-Page');
Route::get('/login', [LoginController::class, 'index'])->name('Login');
Route::post('/login', [LoginController::class, 'authenticate']);
Route::post('/logout', [LoginController::class, 'logout']);

Route::middleware(['authorization', 'admin'])->group(function () {
    // Master Data
    Route::prefix('/master')->group(function () {
        Route::get('/', [DataController::class, 'index'])->name('Master-Data');

        Route::get('/jenis-sampah', [JenisSampahController::class, 'index'])->name('Jenis-Sampah');
        Route::get('/jenis-sampah-tambah', [JenisSampahController::class, 'create'])->name('Jenis-Sampah-Tambah');
        Route::post('/jenis-sampah-store', [JenisSampahController::class, 'store'])->name('Jenis-Sampah-Store');
        Route::get('/jenis-sampah-edit/{id}', [JenisSampahController::class, 'edit'])->name('Jenis-Sampah-Edit');
        Route::put('/jenis-sampah-update/{id}', [JenisSampahController::class, 'update'])->name('Jenis-Sampah-Update');
        Route::delete('/jenis-sampah-delete/{id}', [JenisSampahController::class, 'destroy'])->name('Jenis-Sampah-delete');

        Route::get('/bank-sampah', [BankSampahController::class, 'index'])->name('Bank-Sampah');
        Route::get('/bank-sampah-tambah', [BankSampahController::class, 'create'])->name('Bank-Sampah-Tambah');
        Route::post('/bank-sampah-store', [BankSampahController::class, 'store'])->name('Bank-Sampah-Store');
        Route::get('/bank-sampah-edit', [BankSampahController::class, 'edit'])->name('Bank-Sampah-Edit');
        Route::put('/bank-sampah-update/{id}', [BankSampahController::class, 'update'])->name('Bank-Sampah-Update');

        Route::get('/layanan-jemput', [LayananJemputController::class, 'index'])->name('Layanan-Jemput');
        Route::get('/layanan-jemput-tambah', [LayananJemputController::class, 'create'])->name('Layanan-Jemput-Tambah');
        Route::post('/layanan-jemput-store', [LayananJemputController::class, 'store'])->name('Layanan-Jemput-Store');
        Route::get('/layanan-jemput-edit/{id}', [LayananJemputController::class, 'edit'])->name('Layanan-Jemput-Edit');
        Route::put('/layanan-jemput-update/{id}', [LayananJemputController::class, 'update'])->name('Layanan-Jemput-Update');
    });

    Route::get('/setoran-langsung', [SetorLangsungController::class, 'index'])->name('Setor-Langsung');

    Route::get('/dashboard', [DashboardController::class, 'index',])->name('Dashboard');


    Route::prefix('chatbot')->group(function () {
        Route::get('/', [ChatbotController::class, 'index'])->name('chatbot.index');
        Route::post('/update-api', [ChatbotController::class, 'updateApiKey'])->name('chatbot.update-api');
        Route::post('/chat', [ChatbotController::class, 'chat'])->name('chatbot.chat');
    });



    // Akun
    Route::get('/akun', [AkunController::class, 'index',])->name('Akun');
    Route::get('/akun-tambah', [AkunController::class, 'create',])->name('Akun-Tambah');
    Route::post('/akun-tambah', [AkunController::class, 'store',])->name('Akun-Store');
    Route::get('/akun-edit/{id}', [AkunController::class, 'edit',])->name('Akun-Edit');
    Route::put('/akun-edit/{id}', [AkunController::class, 'update',])->name('Akun-Update');
    Route::delete('/akun-hapus/{id}', [AkunController::class, 'destroy',])->name('Akun-Hapus');

    Route::get('/profil', [ProfilController::class, 'index'])->name('Profil');
    Route::get('/profil-tambah', [ProfilController::class, 'create'])->name('Profil-Tambah');
    Route::post('/profil-store', [ProfilController::class, 'store'])->name('Profil-Store');
    Route::get('/profil-edit', [ProfilController::class, 'edit'])->name('Profil-Edit');
    Route::put('/profil-update/{id}', [ProfilController::class, 'update'])->name('Profil-Update');

    Route::get('/profil-akun/{id}', [ProfilController::class, 'show'])->name('Profil-Akun');

    Route::get('/artikel', [ArtikelController::class, 'index',])->name('Artikel');
    Route::get('/artikel-detail/{id}', [ArtikelController::class, 'show',])->name('Artikel-Detail');
    Route::get('/artikel-tambah', [ArtikelController::class, 'create',])->name('Artikel-Tambah');
    Route::post('/artikel-tambah', [ArtikelController::class, 'store',])->name('Artikel-Store');
    Route::get('/artikel-edit/{id}', [ArtikelController::class, 'edit',])->name('Artikel-Edit');
    Route::put('/artikel-edit/{id}', [ArtikelController::class, 'update',])->name('Artikel-Update');
    Route::delete('/artikel-hapus/{id}', [ArtikelController::class, 'destroy',])->name('Artikel-Hapus');

    Route::get('/video', [VideoController::class, 'index',])->name('Video');
    Route::get('/video-detail/{id}', [VideoController::class, 'show',])->name('Video-Detail');
    Route::get('/video-tambah', [VideoController::class, 'create',])->name('Video-Tambah');
    Route::post('/video-tambah', [VideoController::class, 'store',])->name('Video-Store');
    Route::get('/video-edit/{id}', [VideoController::class, 'edit',])->name('Video-Edit');
    Route::put('/video-edit/{id}', [VideoController::class, 'update',])->name('Video-Update');
    Route::delete('/video-hapus/{id}', [VideoController::class, 'destroy',])->name('Video-Hapus');

    Route::get('/setor-langsung', [SetorLangsungController::class, 'index',])->name('Setor-Langsung');
    Route::get('/setor-langsung-detail/{id}', [SetorLangsungController::class, 'show',])->name('Setor-Langsung-Detail');

    Route::get('/setor-jemput', [SetorJemputController::class, 'index',])->name('Setor-Jemput');
    Route::get('/setor-jemput-detail/{id}', [SetorJemputController::class, 'show',])->name('Setor-Jemput-Detail');

    Route::get('/tarik-saldo', [TarikSaldoController::class, 'index'])->name('Tarik-Saldo');
    Route::get('/tarik-saldo/{id}', [TarikSaldoController::class, 'show'])->name('Tarik-Saldo-Detail');
    Route::put('/tarik-saldo-terima/{id}', [TarikSaldoController::class, 'terimaTarikSaldo'])->name('Tarik-Saldo-Terima');
    Route::put('/tarik-saldo-tolak/{id}', [TarikSaldoController::class, 'tolakTarikSaldo'])->name('Tarik-Saldo-Tolak');
});
