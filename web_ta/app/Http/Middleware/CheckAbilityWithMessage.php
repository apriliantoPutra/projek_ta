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

        if (!$token || !$token->can($ability)) {
            return response()->json([
                'success' => false,
                'message' => 'Token yang Anda masukan salah.'
            ], Response::HTTP_FORBIDDEN);
        }

        return $next($request);
    }
}
