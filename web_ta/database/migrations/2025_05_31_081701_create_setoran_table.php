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
        Schema::create('layanan_jemput', function (Blueprint $table) {
            $table->id();
            $table->foreignId('bank_sampah_id')->constrained('bank_sampah');
            $table->integer('ongkir_per_jarak');
            $table->timestamps();
        });
        Schema::create('pengajuan_setor', function (Blueprint $table) {
            $table->id();
            $table->foreignId('warga_id')->constrained('akun');
            $table->string('jenis_setor');
            $table->dateTime('waktu_pengajuan');
            $table->string('status_pengajuan');
            $table->text('catatan_petugas')->nullable(); // diedit petugas
            $table->timestamps();
        });
        Schema::create('detail_setor', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengajuan_id')->constrained('bank_sampah');
            $table->foreignId('petugas_id')->constrained('akun');
            $table->json('setoran_sampah');
            $table->float('total_berat');
            $table->integer('total_harga');
            $table->string('status_setor');
            $table->timestamps();
        });
        Schema::create('saldo', function (Blueprint $table) {
            $table->id();
            $table->foreignId('warga_id')->constrained('akun');
            $table->integer('total_saldo');
            $table->timestamps();
        });
        Schema::create('penarikan_saldo', function (Blueprint $table) {
            $table->id();
            $table->foreignId('warga_id')->constrained('akun');
            $table->string('metode_penarikan');
            $table->integer('jumlah_penarikan');
            $table->string('status_penarikan');
            $table->text('catatan_penarikan')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('layanan_jemput');
        Schema::dropIfExists('pengajuan_setor');
        Schema::dropIfExists('detail_setor');
        Schema::dropIfExists('saldo');
        Schema::dropIfExists('penarikan_saldo');
    }
};
