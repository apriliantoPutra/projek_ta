<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class VerifyEmail extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     */
    public $token_email;
    public function __construct($token_email)
    {
        $this->token_email = $token_email;
    }
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Verifikasi Registrasi Akun Bank Sampah',
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.verify',
            with: [
                'token' => $this->token_email
            ]
        );
    }

    public function attachments(): array
    {
        return [];
    }
}
