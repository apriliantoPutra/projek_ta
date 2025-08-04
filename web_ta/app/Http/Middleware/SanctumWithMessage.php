<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SanctumWithMessage
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (!auth()->guard('sanctum')->check()) {
            return response()->json([
                'success' => false,
                'message' => 'Anda harus login terlebih dahulu',
            ], 401);
        }

        return $next($request);
    }
}
