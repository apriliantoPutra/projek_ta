<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Laravel\Sanctum\Http\Middleware\CheckForAnyAbility;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__ . '/../routes/web.php',
        api: __DIR__ . '/../routes/api.php',
        commands: __DIR__ . '/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->alias([
            'authorization' => \App\Http\Middleware\Authenticate::class,
            'admin' => \App\Http\Middleware\Akses::class,
            'ability' => CheckForAnyAbility::class,
            'ability_with_message' => \App\Http\Middleware\CheckAbilityWithMessage::class,
            'sanctum_with_message' => \App\Http\Middleware\SanctumWithMessage::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        $exceptions->render(function (Illuminate\Auth\AuthenticationException $e, Illuminate\Http\Request $request) {
            if ($request->expectsJson()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Belum login atau token tidak valid',
                ], 401);
            }
        });
    })->create();
