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
        Schema::create('edukasi_artikel', function (Blueprint $table) {
            $table->id();
            $table->string('judul_artikel');
            $table->text('deskripsi_artikel');
            $table->string('gambar_artikel')->nullable();
            $table->string('nama_author');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('edukasi_artikel');
    }
};
