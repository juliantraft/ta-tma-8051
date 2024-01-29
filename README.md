# Tugas Akhir - Teknik Mikroprosesor dan Antarmuka

[Laporan Lengkap](https://github.com/juliantraft/ta-tma-8051/blob/main/Laporan/Juliant%20Raffa_21120120130127_Laporan%20Tugas%201.pdf)

Dirancang sebuah sistem untuk melakukan monitor terhadap sistem pengisian tandon air. Tandon air yang terletak di atas menara terhubung dengan bak PAM dan sumur yang terletak di bawah. Penampung air di bawah masing-masing memiliki pompa untuk memompa air (pompa bak PAM dan sumur). Karena posisinya yang lebih tinggi dari sumur, bak PAM memiliki prioritas lebih tinggi sebagai sumber pengisian air untuk tandon. Terdapat 5 sensor saklar yang berfungsi sebagai masukkan sistem. 3 sensor saklar digunakan untuk mendeteksi keadaan tandon air, bak PAM, dan sumur. 2 sensor saklar lain digunakan sebagai masukkan sinyal _interrupt_ untuk kerusakan pompa bak PAM atau pompa sumur. Sistem akan dirancang menggunakan _microcontroller_ 8051 yang disimulasikan menggunakan MCU 8051 IDE.

Jika sistem mendeteksi tandon kosong, sistem akan memerika jika bak PAM terisi dan pompanya tidak rusak. Jika kedua kondisi terpenuhi, maka pompa bak PAM akan dinyalakan untuk mengisi tandon. Jika pompa bak PAM tidak dapat dinyalakan, maka akan diperiksa kondisi isi sumur dan keadaan pompa sumur. Jika sumur terisi dan pompa sumur tidak rusak, maka pompa sumur akan dinyalakan untuk mengisi tandon. Jika bak PAM dan sumur kosong dan tidak ada pompa yang rusak, maka kedua pompa akan dimatikan.

Karena keterbatasan pada simulator MCU 8051 IDE, sensor saklar akan direpresentasikan dengan _switch_ yang bersifat _active low_ dan pompa akan direpresentasikan dengan LED yang juga bersifat _active low_. Berikut adalah tabel kebenaran sistem.

| Isi Tandon  <br>(P1.0) | Isi Bak PAM<br>(P1.1) | P. Bak PAM Rusak<br>(P1.5) | Isi Sumur<br>(P1.2) | P. Sumur Rusak<br>(P1.6) | Pompa Bak PAM<br>(P1.3) | Pompa Sumur<br>(P1.4) |
| ---------------------- | --------------------- | ----------------------- | ------------------- | ------------------------ | ----------------------- | --------------------- |
| 0                      | 0                     | X                       | 0                   | X                        | 0                       | 0                     |
| 0                      | 0                     | X                       | **1**               | **0**                    | 0                       | **1**                 |
| 0                      | 0                     | X                       | X                   | 1                        | 0                       | 0                     |
| 0                      | **1**                 | **0**                   | X                   | X                        | **1**                   | 0                     |
| 0                      | X                     | 1                       | 0                   | X                        | 0                       | 0                     |
| 0                      | 1                     | 1                       | 1                   | 1                        | 0                       | 0                     |
| 1                      | X                     | X                       | X                   | X                        | 0                       | 0                     |
