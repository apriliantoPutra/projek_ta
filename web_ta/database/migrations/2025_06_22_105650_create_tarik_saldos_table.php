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
        Schema::create('tarik_saldos', function (Blueprint $table) {
            $table->id();
             $table->foreignId('warga_id')->constrained('akun');
            $table->integer('jumlah_saldo');
            $table->string('status');
            $table->string('metode');
            $table->string('nomor_tarik_saldo');
            $table->text('pesan');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tarik_saldos');
    }
};
