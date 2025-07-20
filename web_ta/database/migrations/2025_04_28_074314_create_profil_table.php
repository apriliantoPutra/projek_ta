<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('profil', function (Blueprint $table) {
            $table->id();
            $table->foreignId("akun_id")->constrained('akun');
            $table->string('nama_pengguna')->unique();
            $table->string('alamat_pengguna');
            $table->string('no_hp_pengguna')->unique();
            $table->string('gambar_pengguna')->nullable();
            $table->string('koordinat_pengguna');


            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('profil');
    }
};
