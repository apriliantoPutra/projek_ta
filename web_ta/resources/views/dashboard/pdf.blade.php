<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Bank Sampah</title>
    <style>
        @page {
            margin: 20px;
            size: landscape;
        }

        body {
            font-family: Arial, sans-serif;
            font-size: 12px;
        }

        .header {
            text-align: center;
            margin-bottom: 20px;
        }

        .logo {
            height: 60px;
            margin-bottom: 10px;
        }

        .title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .subtitle {
            font-size: 16px;
            color: #555;
        }

        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin: 25px 0 10px 0;
            padding-bottom: 5px;
            border-bottom: 2px solid #4CAF50;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th {
            background-color: #4CAF50;
            color: white;
            text-align: left;
            padding: 8px;
        }

        td {
            padding: 8px;
            border-bottom: 1px solid #ddd;
            vertical-align: top;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .total-row {
            font-weight: bold;
            background-color: #e6f7e6 !important;
        }

        .total-label {
            text-align: right;
            padding-right: 15px;
        }

        .no-data {
            text-align: center;
            padding: 20px;
            color: #777;
            font-style: italic;
        }

        .footer {
            text-align: right;
            margin-top: 30px;
            font-size: 12px;
            color: #777;
        }

        .jenis-sampah {
            white-space: nowrap;
        }

        .jenis-sampah-item {
            margin-bottom: 3px;
        }
    </style>
</head>

<body>
    <div class="header">
        <img src="{{ $logoPath }}" alt="Bank Sampah Logo" class="logo">
        <div class="title">Laporan {{ ucfirst($reportType) }} Bank Sampah</div>
        <div class="subtitle">Periode: {{ $periodText }}</div>
    </div>

    <div class="section-title">Data Setor Sampah</div>
    <table>
        <thead>
            <tr>
                <th width="5%">No</th>
                <th width="15%">Nama Nasabah</th>
                <th width="15%">Email</th>
                <th width="15%">Tanggal Setor</th>
                <th width="20%">Jenis Sampah</th>
                <th width="10%">Berat (kg)</th>
                <th width="10%">Harga</th>
            </tr>
        </thead>
        <tbody>
            @if ($has_setor_data)
                @foreach ($setor_sampah as $index => $item)
                    <tr>
                        <td>{{ $index + 1 }}</td>
                        <td>{{ $item['user']['profil']['nama_pengguna'] ?? '-' }}</td>
                        <td>{{ $item['user']['email'] }}</td>
                        <td>{{ $item['waktu_pengajuan'] }}</td>
                        <td class="jenis-sampah">
                            @if ($item['input_detail'])
                                @foreach ($item['input_detail']['setoran_sampah'] as $sampah)
                                    <div class="jenis-sampah-item">{{ $sampah['nama_sampah'] }} ({{ $sampah['berat'] }}
                                        kg)</div>
                                @endforeach
                            @else
                                -
                            @endif
                        </td>
                        <td>{{ $item['input_detail']['total_berat'] ?? '-' }}</td>
                        <td>Rp {{ number_format($item['input_detail']['total_harga'] ?? 0, 0, ',', '.') }}</td>
                    </tr>
                @endforeach
                <tr class="total-row">
                    <td colspan="4" class="total-label">TOTAL</td>
                    <td></td>
                    <td>{{ $total_berat }} kg</td>
                    <td>Rp {{ number_format($total_harga, 0, ',', '.') }}</td>
                </tr>
            @else
                <tr>
                    <td colspan="7" class="no-data">Tidak ada data setor sampah</td>
                </tr>
            @endif
        </tbody>
    </table>

    <div class="section-title">Data Penarikan Saldo</div>
    <table>
        <thead>
            <tr>
                <th width="5%">No</th>
                <th width="25%">Nama Nasabah</th>
                <th width="25%">Email</th>
                <th width="20%">Tanggal Penarikan</th>
                <th width="15%">Jumlah Saldo</th>
            </tr>
        </thead>
        <tbody>
            @if ($has_tarik_data)
                @foreach ($tarik_saldo as $index => $item)
                    <tr>
                        <td>{{ $index + 1 }}</td>
                        <td>{{ $item['user']['profil']['nama_pengguna'] ?? '-' }}</td>
                        <td>{{ $item['user']['email'] }}</td>
                        <td>{{ $item['waktu_pengajuan'] }}</td>
                        <td>Rp {{ number_format($item['jumlah_saldo'], 0, ',', '.') }}</td>
                    </tr>
                @endforeach
                <tr class="total-row">
                    <td colspan="3" class="total-label">TOTAL</td>
                    <td></td>
                    <td>Rp {{ number_format($total_saldo, 0, ',', '.') }}</td>
                </tr>
            @else
                <tr>
                    <td colspan="5" class="no-data">Tidak ada data penarikan saldo</td>
                </tr>
            @endif
        </tbody>
    </table>

    <div class="footer">
        Dicetak pada: {{ \Carbon\Carbon::now()->isoFormat('dddd, D MMMM YYYY HH:mm:ss') }}
    </div>
</body>

</html>
