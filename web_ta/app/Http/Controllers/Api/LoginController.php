<?php

namespace App\Http\Controllers\Api;

use App\Enums\TokenAbility;
use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Models\User;
use Carbon\Carbon;
use GrahamCampbell\ResultType\Success;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use PHPOpenSourceSaver\JWTAuth\Exceptions\JWTException;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;

class LoginController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required|string|max:255|unique:akun,username',
            'email' => 'required|string|email|max:255|unique:akun,email',
            'password' => 'required|min:6',
            'konfirmasiPassword' => 'required|min:6|same:password',

        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 400);
        }

        DB::beginTransaction();

        try {
            $akun = User::create([
                'username' => $request->get('username'),
                'email' => $request->get('email'),
                'password' => Hash::make($request->get('password')),
                'role' => 'warga'
            ]);

            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Registrasi Berhasil',
                'data' => $akun
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(
                [
                    "success" => false,
                    "message" => $e->getMessage()

                ]
            );
        }
    }
    public function authenticate(LoginRequest $request)
    {
        if (!Auth::attempt($request->only('username', 'password'))) {
            return response()->json([
                'success' => false,
                'message' => 'Periksa kembali username atau password Anda',
            ], 401);
        }

        $akun = User::where('username', $request['username'])->firstOrFail();
        // Pengecekan untuk menghapus token yang sudah ada
        $akun->tokens()->where('name', 'access-token')->delete();
        $akun->tokens()->where('name', 'refresh-token')->delete();


        $access_token = $akun->createToken('access-token', [TokenAbility::ACCESS_API->value], Carbon::now()->addMinutes(config('sanctum.access_token_expiration')))->plainTextToken;
        $refresh_token = $akun->createToken('refresh-token', [TokenAbility::ISSUE_ACCESS_TOKEN->value], Carbon::now()->addDays(config('sanctum.refresh_token_expiration')))->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login Berhasil',
            'access_token' => $access_token,
            'refresh_token' => $refresh_token,
            'data' => $akun
        ], 200);
    }
    public function refresh(Request $request)
    {
        $user = $request->user();
        $currentToken = $user->currentAccessToken();

        if (!$currentToken || $currentToken->name !== 'refresh-token' || $currentToken->expires_at->isPast()) {
            return response()->json(['success' => false, 'message' => 'Token tidak valid/ kadaluarsa'], 401);
        }

        // Hapus semua access-token sebelumnya
        $user->tokens()->where('name', 'access-token')->delete();

        // Buat access-token baru
        $newAccessToken = $user->createToken(
            'access-token',
            [TokenAbility::ACCESS_API->value],
            now()->addMinutes(config('sanctum.access_token_expiration'))
        )->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Token berhasil diperbarui',
            'access_token' => $newAccessToken,
            'token_type' => 'Bearer',
            'data' => $user
        ], 200);
    }


    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Berhasil Logout'
        ], 200);
    }
}
