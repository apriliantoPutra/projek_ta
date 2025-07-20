<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Models\User;
use GrahamCampbell\ResultType\Success;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;


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
                'message' => $validator->errors()->first(),
                'errors' => $validator->errors()
            ], 422);
        }
        DB::beginTransaction();

        try {
            $akun = User::create([
                'username' => $request->get('username'),
                'email' => $request->get('email'),
                'password' => Hash::make($request->get('password')),
                'role' => 'warga'
            ]);
            $token = $akun->createToken('auth_token')->plainTextToken;
            DB::commit();
            return response()->json([
                'success' => true,
                'token' => $token,
                'data' => $akun
            ]);
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

    /**
     * @group Auth
     * Authenticate user menggunakan username & password
     */
    public function authenticate(LoginRequest $request) // pakai LoginRequest
    {
        if (!Auth::attempt($request->only('username', 'password'))) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid Credentials'
            ], 400);
        }

        $akun = User::where('username', $request['username'])->firstOrFail();
        $token = $akun->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'token' => $token,
            'data' => $akun
        ]);
    }


    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json([
            'success' => true,
            'message' => 'Logged Out'
        ]);
    }
}
