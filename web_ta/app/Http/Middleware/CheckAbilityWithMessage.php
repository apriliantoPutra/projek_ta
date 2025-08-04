<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckAbilityWithMessage
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, $ability)
    {
        $token = $request->user()->currentAccessToken();
        if (!$token) {
            return response()->json([
                'success' => false,
                'message' => 'Token tidak ditemukan atau tidak valid'
            ], 401);
        }

        if (!$token->can($ability)) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak, tidak memiliki izin'
            ], 403);
        }

        return $next($request);
    }
}
