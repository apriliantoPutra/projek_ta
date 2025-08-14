<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Verifikasi Email</title>
</head>
<body style="font-family: Arial, sans-serif; background: #f7f7f7; padding: 20px;">
    <div style="max-width: 600px; background: #ffffff; padding: 20px; border-radius: 8px;">
        <h2 style="color: #4CAF50;">Verifikasi Email Anda</h2>
        <p>Halo,</p>
        <p>Terima kasih telah mendaftar di <b>Bank Sampah</b>. Untuk menyelesaikan proses pendaftaran, silakan masukkan token berikut di aplikasi atau website kami:</p>

        <div style="background: #f0f0f0; padding: 10px; text-align: center; border-radius: 5px; font-size: 18px; font-weight: bold; letter-spacing: 2px;">
            {{ $token }}
        </div>

        <p style="margin-top: 20px;">Token ini hanya berlaku selama <b>15 menit</b>.</p>
        <p>Jika Anda tidak merasa mendaftar, abaikan email ini.</p>

        <hr>
        <p style="font-size: 12px; color: #888;">Email ini dikirim otomatis, mohon tidak membalas langsung.</p>
    </div>
</body>
</html>
