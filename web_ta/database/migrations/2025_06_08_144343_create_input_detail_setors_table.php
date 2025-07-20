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
        Schema::create('input_detail_setors', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengajuan_id')->constrained('pengajuan_setor');
            $table->foreignId('petugas_id')->nullable()->constrained('akun');
            $table->json('setoran_sampah')->nullable();
            $table->float('total_berat');
            $table->integer('total_harga');
            $table->string('status_setor');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('input_detail_setors');
    }
};
