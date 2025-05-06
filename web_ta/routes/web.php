<?php

use App\Http\Controllers\AkunController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\Edukasi\ArtikelController;
use App\Http\Controllers\Edukasi\VideoController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('login');
});

Route::get('/dashboard', [DashboardController::class, 'index', ]);
Route::get('/akun', [AkunController::class, 'index', ]);


Route::get('/artikel', [ArtikelController::class, 'index', ]);
Route::get('/video', [VideoController::class, 'index', ]);


