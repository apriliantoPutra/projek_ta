<?php

use App\Http\Controllers\AkunController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\Edukasi\ArtikelController;
use App\Http\Controllers\Edukasi\VideoController;
use App\Http\Controllers\LoginController;
use Illuminate\Support\Facades\Route;

Route::get('/', [LoginController::class, 'index']);
Route::post('/login', [LoginController::class, 'authenticate']);
Route::post('/logout', [LoginController::class, 'logout']);

Route::middleware(['authorization', 'admin'])->group(function () {

    Route::get('/dashboard', [DashboardController::class, 'index',])->name('Dashboard');
    Route::get('/akun', [AkunController::class, 'index',])->name('Akun');
    Route::get('/akun-tambah', [AkunController::class, 'create',])->name('Akun-Tambah');
    Route::post('/akun-tambah', [AkunController::class, 'store',])->name('Akun-Store');
    Route::get('/akun-edit/{id}', [AkunController::class, 'edit',])->name('Akun-Edit');
    Route::put('/akun-edit/{id}', [AkunController::class, 'update',])->name('Akun-Update');
    Route::delete('/akun-hapus/{id}', [AkunController::class, 'destroy',])->name('Akun-Hapus');



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
});
