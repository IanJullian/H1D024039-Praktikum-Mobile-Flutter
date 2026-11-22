<?php
namespace App\Controllers;

use App\Models\MProduk;

class ProdukController extends RestfulController
{
    // Menambahkan produk
    public function create()
    {
        $harga = filter_var(
            $this->request->getPost('harga'),
            FILTER_VALIDATE_INT
        );

        $data = [
            'kode_produk' => trim(
                (string) ($this->request->getPost('kode_produk') ?? '')
            ),
            'nama_produk' => trim(
                (string) ($this->request->getPost('nama_produk') ?? '')
            ),
            'harga' => $harga
        ];

        // Validasi input sebelum disimpan.
        if (
            $data['kode_produk'] === '' ||
            $data['nama_produk'] === '' ||
            $harga === false ||
            $harga <= 0
        ) {
            return $this->response
                ->setStatusCode(422)
                ->setJSON([
                    'code' => 422,
                    'status' => false,
                    'data' => ['message' => 'Data produk tidak valid']
                ]);
        }

        $model = new MProduk();
        $insert = $model->insert($data);

        if ($insert === false) {
            return $this->response
                ->setStatusCode(500)
                ->setJSON([
                    'code' => 500,
                    'status' => false,
                    'data' => ['message' => 'Gagal menyimpan produk']
                ]);
        }

        $produk = $model->find($model->getInsertID());

        return $this->responseHasil(200, true, $produk);
    }

    // Menampilkan seluruh produk
    public function list()
    {
        $model = new MProduk();
        $produk = $model->findAll();

        return $this->responseHasil(200, true, $produk);
    }

    // Menampilkan detail produk berdasarkan ID
    public function detail($id)
    {
        $model = new MProduk();
        $produk = $model->find($id);

        return $this->responseHasil(200, true, $produk);
    }

    // Mengubah produk
    public function ubah($id)
    {
        // Membaca data dari request PUT.
        $input = $this->request->getRawInput();

        $harga = filter_var(
            $input['harga'] ?? null,
            FILTER_VALIDATE_INT
        );

        $data = [
            'kode_produk' => trim(
                (string) ($input['kode_produk'] ?? '')
            ),
            'nama_produk' => trim(
                (string) ($input['nama_produk'] ?? '')
            ),
            'harga' => $harga
        ];

        if (
            $data['kode_produk'] === '' ||
            $data['nama_produk'] === '' ||
            $harga === false ||
            $harga <= 0
        ) {
            return $this->response
                ->setStatusCode(422)
                ->setJSON([
                    'code' => 422,
                    'status' => false,
                    'data' => ['message' => 'Data produk tidak valid']
                ]);
        }

        $model = new MProduk();

        if (!$model->find($id)) {
            return $this->response
                ->setStatusCode(404)
                ->setJSON([
                    'code' => 404,
                    'status' => false,
                    'data' => ['message' => 'Produk tidak ditemukan']
                ]);
        }

        $model->update($id, $data);
        $produk = $model->find($id);

        return $this->responseHasil(200, true, $produk);
    }

    // Menghapus produk
    public function hapus($id)
    {
        $model = new MProduk();
        $produk = $model->delete($id);

        return $this->responseHasil(200, true, $produk);
    }
}
