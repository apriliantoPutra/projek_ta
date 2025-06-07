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
        Schema::create('detail_setoran_pengajuan_petugas', function (Blueprint $table) {
            $table->foreignId('detail_setoran_id')->constrained('detail_setor');
            $table->foreignId('pengajuan_petugas_id')->constrained('pengajuan_petugas');
            $table->primary(['detail_setoran_id', 'pengajuan_petugas_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('detail_setoran_pengajuan_petugas');
    }
};
