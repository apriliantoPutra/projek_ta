<?php

use App\Http\Controllers\AkunController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\Edukasi\ArtikelController;
use App\Http\Controllers\Edukasi\VideoController;
use App\Http\Controllers\LoginController;
use Illuminate\Support\Facades\Route;

Route::get('/', [LoginController::class, 'index']);

Route::get('/dashboard', [DashboardController::class, 'index', ]);
Route::get('/akun', [AkunController::class, 'index', ]);
Route::get('/akun-tambah', [AkunController::class, 'create', ]);
Route::get('/akun-edit', [AkunController::class, 'edit', ]);


Route::get('/artikel', [ArtikelController::class, 'index', ]);
Route::get('/artikel-tambah', [ArtikelController::class, 'create', ]);
Route::get('/artikel-edit', [ArtikelController::class, 'edit', ]);

Route::get('/video', [VideoController::class, 'index', ]);
Route::get('/video-tambah', [VideoController::class, 'create', ]);
Route::get('/video-edit', [VideoController::class, 'edit', ]);


