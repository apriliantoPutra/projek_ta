<?php

namespace Database\Seeders;

use Carbon\Carbon;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AkunSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('akun')->insert([
            [
                'username'=> 'Admin',
                'email'=> 'admin@gmail.com',
                'password'=> Hash::make('admin123'),
                'role'=>'admin',
                'created_at'=> Carbon::now()
            ],
            [
                'username'=> 'warga',
                'email'=> 'warga@gmail.com',
                'password'=> Hash::make('warga123'),
                'role'=>'warga',
                'created_at'=> Carbon::now()
            ],
        ]);
    }
}
