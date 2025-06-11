<?php

use App\Http\Controllers\Api\ApiAkunController;
use App\Http\Controllers\Api\ArtikelController;
use App\Http\Controllers\Api\LoginController as ApiLoginController;
use App\Http\Controllers\Api\MasterDataController;
use App\Http\Controllers\Api\ProfilController as ApiProfilController;
use App\Http\Controllers\Api\SaldoController;
use App\Http\Controllers\Api\SetorJemputController;
use App\Http\Controllers\Api\SetorLangsungController;
use App\Http\Controllers\Api\VideoController;
use App\Http\Controllers\PengajuanPetugasController;
use Illuminate\Support\Facades\Route;


Route::prefix('v1')->group(function () {
    Route::post('register', [ApiLoginController::class, 'register']);
    Route::post('authenticate', [ApiLoginController::class, 'authenticate']);


    Route::middleware('auth:sanctum')->group(function () {
        // master
        Route::get('/jenis-sampah', [MasterDataController::class, 'jenisSampahIndex']);
        Route::get('/jenis-sampah/{id}', [MasterDataController::class, 'jenisSampahShow']);
        Route::get('/bank-sampah', [MasterDataController::class, 'bankSampahIndex']);
        Route::get('/bank-sampah/{id}', [MasterDataController::class, 'bankSampahShow']);

        Route::prefix('profil')->group(function () {
            Route::post('/', [ApiProfilController::class, 'store']);
            Route::get('/', [ApiProfilController::class, 'show']);
            Route::put('/', [ApiProfilController::class, 'update']);
        });

        Route::get('/akun', [ApiAkunController::class, 'show']);
        Route::get('/saldo', [SaldoController::class, 'show']);

        Route::prefix('setor-langsung')->group(function () {
            // warga
            Route::post('/', [SetorLangsungController::class, 'storePengajuan']);
            // petugas
            Route::get('/', [SetorLangsungController::class, 'listPengajuan']); // list pengajuan
            Route::get('/{id}', [SetorLangsungController::class, 'showPengajuan']); // detail pengajuan by id
            Route::put('/terima-pengajuan/{id}', [SetorLangsungController::class, 'terimaPengajuan']); // ubah status
            Route::put('/batal-pengajuan/{id}', [SetorLangsungController::class, 'batalPengajuan']); // ubah status

            Route::post('/detail-sampah/{id}', [SetorLangsungController::class, 'storeDetail']); // input detail sampah berdasarkan id pengajuan
        });
        Route::prefix('setor-jemput')->group(function () {
            Route::post('/', [SetorJemputController::class, 'storePengajuan']);
        });


        Route::post('/setor-sampah', [PengajuanPetugasController::class, 'store']);
        Route::get('/setor-sampah/{id}', [PengajuanPetugasController::class, 'show']);

        // Logout
        Route::post('logout', [ApiLoginController::class, 'logout']);
    });



    Route::prefix('artikel')->group(function () {
        Route::get('/', [ArtikelController::class, 'index']);
        Route::get('{id}', [ArtikelController::class, 'show']);
    });

    Route::prefix('video')->group(function () {
        Route::get('/', [VideoController::class, 'index']);
        Route::get('{id}', [VideoController::class, 'show']);
    });
});
