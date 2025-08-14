<?php

namespace App\Http\Controllers\Api;

use App\Enums\TokenAbility;
use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Models\PendingRegistration;
use App\Models\User;
use Carbon\Carbon;
use GrahamCampbell\ResultType\Success;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Mail;

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

            $token = Str::random(20);

            PendingRegistration::create([
                'username' => $request->username,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'token' => $token,
                'expires_at' => Carbon::now()->addMinutes(15)
            ]);

            // Kirim email verifikasi
            Mail::to($request->email)->send(new \App\Mail\VerifyEmail($token));

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Silakan cek email untuk verifikasi akun'
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat registrasi: ' . $e->getMessage()
            ], 500);
        }
    }


    public function confirmEmail(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'token' => 'required|string'
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

            $pending = PendingRegistration::where('email', $request->email)
                ->where('token', $request->token)
                ->first();

            if (!$pending) {
                DB::rollBack();
                return response()->json([
                    'success' => false,
                    'message' => 'Token tidak valid'
                ], 400);
            }

            if (Carbon::now()->greaterThan($pending->expires_at)) {
                DB::rollBack();
                return response()->json([
                    'success' => false,
                    'message' => 'Token kadaluarsa'
                ], 400);
            }

            // Buat akun baru
            User::create([
                'username' => $pending->username,
                'email' => $pending->email,
                'password' => $pending->password,
                'role' => 'warga'
            ]);

            // Hapus pending registration
            $pending->delete();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Akun telah dibuat, Silakan login!'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat verifikasi email: ' . $e->getMessage()
            ], 500);
        }
    }


    public function lupaPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:akun,email',
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

            $token = Str::random(20);
            DB::table('password_resets')->updateOrInsert(
                ['email' => $request->email],
                ['token' => $token, 'created_at' => Carbon::now()]
            );

            Mail::to($request->email)->send(new \App\Mail\ResetPassword($token));

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Token reset password telah dikirim ke email'
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:akun,email',
            'token' => 'required|string',
            'password' => 'required|min:6',
            'konfirmasiPassword' => 'required|min:6|same:password'
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

            $reset = DB::table('password_resets')
                ->where('email', $request->email)
                ->where('token', $request->token)
                ->first();

            if (!$reset) {
                return response()->json([
                    'success' => false,
                    'message' => 'Token tidak valid'
                ], 400);
            }

            if (Carbon::parse($reset->created_at)->addMinutes(15)->isPast()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Token kadaluarsa'
                ], 400);
            }

            User::where('email', $request->email)->update([
                'password' => Hash::make($request->password)
            ]);

            DB::table('password_resets')->where('email', $request->email)->delete();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Password berhasil direset'
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
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
