<?php

use App\Enums\TokenAbility;
use App\Http\Controllers\Api\AkunController;
use App\Http\Controllers\Api\ApiAkunController;
use App\Http\Controllers\Api\ArtikelController;
use App\Http\Controllers\Api\ChatBotController;
use App\Http\Controllers\Api\HistoriController;
use App\Http\Controllers\Api\KumpulanSetorController;
use App\Http\Controllers\Api\LoginController as ApiLoginController;
use App\Http\Controllers\Api\MasterDataController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\ProfilController as ApiProfilController;
use App\Http\Controllers\Api\SaldoController;
use App\Http\Controllers\Api\SetorJemputController;
use App\Http\Controllers\Api\SetorLangsungController;
use App\Http\Controllers\Api\TarikSaldoController as ApiTarikSaldoController;
use App\Http\Controllers\Api\TotalSampahController;
use App\Http\Controllers\Api\VideoController;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\Facades\Route;


Route::prefix('v1')->group(function () {
    Route::post('register', [ApiLoginController::class, 'register']);
    Route::post('authenticate', [ApiLoginController::class, 'authenticate']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::middleware('ability_with_message:' . TokenAbility::ACCESS_API->value)->group(function () {
            Route::get('/jenis-sampah', [MasterDataController::class, 'kumpulanJenisSampah']);
            Route::get('/jenis-sampah/{id}', [MasterDataController::class, 'detailJenisSampah']);
            Route::get('/bank-sampah', [MasterDataController::class, 'detailBankSampah']);

            Route::prefix('profil')->group(function () {
                Route::post('/', [ApiProfilController::class, 'tambah']);
                Route::get('/', [ApiProfilController::class, 'detail']);
                Route::put('/', [ApiProfilController::class, 'edit']);
            });

            Route::get('/akun', [AkunController::class, 'detail']);
            Route::get('/saldo', [SaldoController::class, 'detail']);

            Route::get('/setor-terbaru', [KumpulanSetorController::class, 'limaTerbaru']);
            Route::get('/setor-baru', [KumpulanSetorController::class, 'baru']);
            Route::get('/setor-proses', [KumpulanSetorController::class, 'proses']);
            Route::get('/setor-selesai', [KumpulanSetorController::class, 'selesai']);

            Route::prefix('setor-langsung')->group(function () {
                Route::post('/', [SetorLangsungController::class, 'tambahPengajuan']);
                Route::get('/{id}', [SetorLangsungController::class, 'detailPengajuan']);

                Route::post('/detail-sampah/{id}', [SetorLangsungController::class, 'tambahDetailSetor']);
                Route::get('/selesai/{id}', [SetorLangsungController::class, 'detailSetorSelesai']);
            });

            Route::prefix('setor-jemput')->group(function () {
                // warga
                Route::post('/', [SetorJemputController::class, 'tambahPengajuan']);
                // petugas
                Route::get('/{id}', [SetorJemputController::class, 'detailPengajuan']);
                Route::patch('/terima-pengajuan/{id}', [SetorJemputController::class, 'terimaPengajuan']);
                Route::patch('/batal-pengajuan/{id}', [SetorJemputController::class, 'batalPengajuan']);
                Route::patch('/konfirmasi/{id}', [SetorJemputController::class, 'konfirmasiPengajuan']);
            });

            //tarik saldo
            Route::post('/pengajuan-tarik-saldo', [ApiTarikSaldoController::class, 'pengajuanTarikSaldo']);
            Route::get('/permintaan-tarik-saldo', [ApiTarikSaldoController::class, 'permintaanTarikSaldo']);
            Route::get('/histori-tarik-saldo', [HistoriController::class, 'kumpulanTarikSaldo']);
            Route::get('/histori-tarik-saldo/{id}', [HistoriController::class, 'detailTarikSaldo']);

            // histori setor warga
            Route::get('/histori-setor-baru', [HistoriController::class, 'kumpulanSetorBaru']);
            Route::get('/histori-setor-proses', [HistoriController::class, 'kumpulanSetorProses']);
            Route::get('/histori-setor-selesai', [HistoriController::class, 'kumpulanSetorSelesai']);
            Route::get('/histori-setor-batal', [HistoriController::class, 'kumpulanSetorBatal']);
            Route::get('/histori-setor-detai/{id}', [HistoriController::class, 'detailSetorSampah']);

            Route::get('/notifikasi-warga', [NotificationController::class, 'warga']);
            Route::get('/notifikasi-petugas', [NotificationController::class, 'petugas']);

            Route::get('/api-key', [ChatBotController::class, 'apiKey']);

            // logout
            Route::post('/logout', [ApiLoginController::class, 'logout']);
        });
        
        Route::post('/refresh', [ApiLoginController::class, 'refresh'])->middleware('ability_with_message:' . TokenAbility::ISSUE_ACCESS_TOKEN->value);
    });

    Route::prefix('artikel')->group(function () {
        Route::get('/', [ArtikelController::class, 'kumpulan']);
        Route::get('/terbaru', [ArtikelController::class, 'limaTerbaru']);
        Route::get('{id}', [ArtikelController::class, 'detail']);
    });

    Route::prefix('video')->group(function () {
        Route::get('/', [VideoController::class, 'kumpulan']);
        Route::get('/terbaru', [VideoController::class, 'limaTerbaru']);
        Route::get('{id}', [VideoController::class, 'detail']);
    });

    Route::get('/total-berat', [TotalSampahController::class, 'semuaSampah']);
    Route::get('/total-berat-botol', [TotalSampahController::class, 'sampahBotolPlastik']);
});
