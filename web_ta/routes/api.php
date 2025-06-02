<?php

use App\Http\Controllers\Api\ApiAkunController;
use App\Http\Controllers\Api\ArtikelController;
use App\Http\Controllers\Api\LoginController as ApiLoginController;
use App\Http\Controllers\Api\ProfilController as ApiProfilController;
use App\Http\Controllers\Api\SaldoController;
use App\Http\Controllers\Api\VideoController;
use Illuminate\Support\Facades\Route;


Route::prefix('v1')->group(function () {
    Route::post('register', [ApiLoginController::class, 'register']);
    Route::post('authenticate', [ApiLoginController::class, 'authenticate']);


    Route::middleware('auth:sanctum')->group(function () {
        Route::prefix('profil')->group(function () {
            Route::post('/', [ApiProfilController::class, 'store']);
            Route::get('/', [ApiProfilController::class, 'show']);
            Route::put('/', [ApiProfilController::class, 'update']);
        });

        Route::get('/akun', [ApiAkunController::class, 'show']);
        Route::get('/saldo', [SaldoController::class, 'show']);

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
