<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class JenisSampahSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('jenis_sampah')->insert([
            [
                'nama_sampah' => 'karung',
                'satuan' => 'kg',
                'harga_per_satuan' => '1000',
                'warna_indikasi' => '#f210d9',
            ],
            [
                'nama_sampah' => 'kaleng',
                'satuan' => 'kg',
                'harga_per_satuan' => '1800',
                'warna_indikasi' => '#9510f2',
            ],
            [
                'nama_sampah' => 'besi',
                'satuan' => 'kg',
                'harga_per_satuan' => '4200',
                'warna_indikasi' => '#f21081',
            ],
            [
                'nama_sampah' => 'seng',
                'satuan' => 'pcs',
                'harga_per_satuan' => '1500',
                'warna_indikasi' => '#10f2e0',
            ],
            [
                'nama_sampah' => 'kardus',
                'satuan' => 'kg',
                'harga_per_satuan' => '1500',
                'warna_indikasi' => '#36e987',
            ],
            [
                'nama_sampah' => 'botol plastik',
                'satuan' => 'kg',
                'harga_per_satuan' => '2000',
                'warna_indikasi' => '#05fb47',
            ],
            [
                'nama_sampah' => 'kertas',
                'satuan' => 'kg',
                'harga_per_satuan' => '2000',
                'warna_indikasi' => '#6a8748',
            ],
            [
                'nama_sampah' => 'baja ringan',
                'satuan' => 'kg',
                'harga_per_satuan' => '2500',
                'warna_indikasi' => '#eaa411',
            ],
            [
                'nama_sampah' => 'botol kaca',
                'satuan' => 'pcs',
                'harga_per_satuan' => '600',
                'warna_indikasi' => '#ea4911',
            ],
            [
                'nama_sampah' => 'sak plastik',
                'satuan' => 'kg',
                'harga_per_satuan' => '1000',
                'warna_indikasi' => '#760637',
            ],
            [
                'nama_sampah' => 'kabel',
                'satuan' => 'kg',
                'harga_per_satuan' => '25000',
                'warna_indikasi' => '#e5e917',
            ],
        ]);
    }
}
