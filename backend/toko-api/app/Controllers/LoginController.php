<?php
namespace App\Controllers;

use App\Models\MLogin;
use App\Models\MMember;

class LoginController extends RestfulController
{
    public function login()
    {
        $email = $this->request->getVar('email');
        $password = $this->request->getVar('password');

        // Validasi input
        if (
            !is_string($email) || $email === '' ||
            !is_string($password) || $password === ''
        ) {
            return $this->responseHasil(
                400,
                false,
                "Email dan password harus diisi"
            );
        }

        // Mencari member berdasarkan email
        $model = new MMember();
        $member = $model->where(['email' => $email])->first();

        if (!$member) {
            return $this->responseHasil(
                400,
                false,
                "Email tidak ditemukan"
            );
        }

        // Memverifikasi password
        if (!password_verify($password, $member['password'])) {
            return $this->responseHasil(
                400,
                false,
                "Password tidak valid"
            );
        }

        // Membuat token login
        $login = new MLogin();
        $auth_key = $this->RandomString();

        $login->save([
            'member_id' => $member['id'],
            'auth_key' => $auth_key
        ]);

        $data = [
            'token' => $auth_key,
            'user' => [
                'id' => $member['id'],
                'email' => $member['email']
            ]
        ];

        return $this->responseHasil(200, true, $data);
    }

    // Membuat token acak
    private function RandomString($length = 100)
    {
        $karakter = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $panjang_karakter = strlen($karakter);
        $str = '';

        for ($i = 0; $i < $length; $i++) {
            $str .= $karakter[random_int(0, $panjang_karakter - 1)];
        }

        return $str;
    }
}
