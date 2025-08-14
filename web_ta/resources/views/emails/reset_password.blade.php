<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Reset Password</title>
</head>

<body style="font-family: Arial, sans-serif; background: #f7f7f7; padding: 20px;">
    <div style="max-width: 600px; background: #ffffff; padding: 20px; border-radius: 8px;">
        <h2 style="color: #e53935;">Reset Password</h2>
        <p>Halo,</p>
        <p>Kami menerima permintaan untuk mereset password akun Anda. Silakan gunakan token berikut untuk melanjutkan
            proses reset password:</p>

        <div
            style="background: #f0f0f0; padding: 10px; text-align: center; border-radius: 5px; font-size: 18px; font-weight: bold; letter-spacing: 2px;">
            {{ $token }}
        </div>

        <p style="margin-top: 20px;">Token ini berlaku selama <b>15 menit</b>.</p>
        <p>Jika Anda tidak merasa meminta reset password, abaikan email ini.</p>

        <hr>
        <p style="font-size: 12px; color: #888;">Email ini dikirim otomatis, mohon tidak membalas langsung.</p>
    </div>
</body>

</html>
