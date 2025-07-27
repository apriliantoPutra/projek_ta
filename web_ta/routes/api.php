<?php

use App\Enums\TokenAbility;
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

            Route::get('/setor-terbaru', [KumpulanSetorController::class, 'terbaru']);
            Route::get('/setor-baru', [KumpulanSetorController::class, 'baru']);
            Route::get('/setor-proses', [KumpulanSetorController::class, 'proses']);
            Route::get('/setor-selesai', [KumpulanSetorController::class, 'selesai']);

            Route::prefix('setor-langsung')->group(function () {
                // warga
                Route::post('/', [SetorLangsungController::class, 'storePengajuan']);
                // petugas
                Route::get('/baru', [SetorLangsungController::class, 'listPengajuanBaru']); // list pengajuan Baru
                Route::get('/selesai', [SetorLangsungController::class, 'listPengajuanSelesai']); // list pengajuan Selesai

                Route::get('/{id}', [SetorLangsungController::class, 'showPengajuan']); // detail pengajuan by id
                Route::put('/terima-pengajuan/{id}', [SetorLangsungController::class, 'terimaPengajuan']); // ubah status
                Route::put('/batal-pengajuan/{id}', [SetorLangsungController::class, 'batalPengajuan']); // ubah status

                Route::post('/detail-sampah/{id}', [SetorLangsungController::class, 'storeDetail']); // input detail sampah berdasarkan id pengajuan
                Route::get('/selesai/{id}', [SetorLangsungController::class, 'showPengajuanDetail']); // detail pengajuan by id
            });
            Route::prefix('setor-jemput')->group(function () {
                // warga
                Route::post('/', [SetorJemputController::class, 'storePengajuan']);
                // petugas
                Route::get('/baru', [SetorJemputController::class, 'listPengajuanBaru']);
                Route::get('/proses', [SetorJemputController::class, 'listPengajuanProses']);
                Route::get('/selesai', [SetorJemputController::class, 'listPengajuanSelesai']);
                Route::get('/{id}', [SetorJemputController::class, 'showPengajuan']);

                Route::patch('/terima-pengajuan/{id}', [SetorJemputController::class, 'terimaPengajuan']);
                Route::patch('/batal-pengajuan/{id}', [SetorJemputController::class, 'batalPengajuan']);
                Route::patch('/konfirmasi/{id}', [SetorJemputController::class, 'konfirmasiPengajuan']);
            });
            //tarik saldo
            Route::post('/pengajuan-tarik-saldo', [ApiTarikSaldoController::class, 'pengajuanTarikSaldo']);
            Route::get('/permintaan-tarik-saldo', [ApiTarikSaldoController::class, 'permintaanTarikSaldo']);
            Route::get('/histori-tarik-saldo', [HistoriController::class, 'listSaldo']);
            Route::get('/histori-tarik-saldo/{id}', [HistoriController::class, 'detailSaldo']);

            // histori setor warga
            Route::get('/histori-setor-baru', [HistoriController::class, 'listSetorBaru']);
            Route::get('/histori-setor-proses', [HistoriController::class, 'listSetorProses']);
            Route::get('/histori-setor-selesai', [HistoriController::class, 'listSetorSelesai']);
            Route::get('/histori-setor-batal', [HistoriController::class, 'listSetorBatal']);
            Route::get('/histori-setor-detai/{id}', [HistoriController::class, 'detailSetor']);

            Route::get('/notifikasi', [NotificationController::class, 'detailNotifikasi']);
            Route::get('/api-key', [ChatBotController::class, 'apiKey']);

            // logout
            Route::post('/logout', [ApiLoginController::class, 'logout']);
        });

        Route::post('/refresh', [ApiLoginController::class, 'refresh'])->middleware('ability_with_message:' . TokenAbility::ISSUE_ACCESS_TOKEN->value);
    });

    Route::prefix('artikel')->group(function () {
        Route::get('/', [ArtikelController::class, 'index']);
        Route::get('/terbaru', [ArtikelController::class, 'terbaru']);
        Route::get('{id}', [ArtikelController::class, 'show']);
    });

    Route::prefix('video')->group(function () {
        Route::get('/', [VideoController::class, 'index']);
        Route::get('/terbaru', [VideoController::class, 'terbaru']);
        Route::get('{id}', [VideoController::class, 'show']);
    });

    Route::get('/total-berat', [TotalSampahController::class, 'totalSampah']);
    Route::get('/total-berat-botol', [TotalSampahController::class, 'totalSampahBotol']);
});
