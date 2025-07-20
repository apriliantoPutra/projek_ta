<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class LayananJemputSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('layanan_jemput')->insert([
            [
                'bank_sampah_id' => '1',
                'ongkir_per_jarak' => '1000',
            ],
        ]);
    }
}
