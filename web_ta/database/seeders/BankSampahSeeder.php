<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class BankSampahSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('bank_sampah')->insert([
            [
                'admin_id' => 'karung',
                'nama_bank_sampah' => 'Bank Sampah Tembalang',
                'deskripsi_bank_sampah' => 'Deskripsi Bank Sampah Tembalang',
                'alamat_bank_sampah' => 'Tembalang Semarang Jawa Tengah',
                'koordinat_bank_sampah' => '-7.05055837482239, 110.44114708764991'
            ],
        ]);
    }
}
