
# Student Registration Database — Hands-On Lab 1

Membangun database **`StudentRegistrationDB`** di SQL Server sebagai fondasi aplikasi **Student Registration** menggunakan WPF dan C#.

| Keterangan | Detail |
|---|---|
| **Nama** | Salsabila Hana Adniah |
| **NIM** | 5025251191 |
| **Mata Kuliah** | .NET Programming with C# |
| **Platform** | SQL Server Express + SQL Server Management Studio (SSMS) |

---

## Struktur Repository

```text
student-registration-lab/
├── README.md
├── database/
│   └── Praktikum_StudentRegistrationDB.sql
└── screenshots/
    ├── 01-koneksi-sqlexpress.png
    ├── 02-current-database.png
    ├── 03-tabel-programs.png
    ├── 04-tabel-students.png
    ├── 05-hasil-join.png
    ├── implement-wpf.png
    └── refresh-wpf.png
```

---

## Desain Database

Database menggunakan relasi **One-to-Many (1:N)**. Satu program studi dapat memiliki banyak mahasiswa, sedangkan setiap mahasiswa terdaftar pada satu program studi.

```text
┌──────────────────┐
│     PROGRAMS     │
├──────────────────┤
│ PK ProgramId     │
│ UK ProgramCode   │
│    ProgramName   │
│    IsActive      │
│    CreatedAt     │
└────────┬─────────┘
         │ 1
         │
         │ N
┌────────▼─────────┐
│     STUDENTS     │
├──────────────────┤
│ PK StudentId     │
│ UK NIM           │
│    Name          │
│ FK ProgramId     │
│    BirthDate     │
│    Address       │
│    PhoneNumber   │
│    CreatedAt     │
│    UpdatedAt     │
└──────────────────┘
```

### Database Constraints

| Constraint | Tabel | Fungsi |
|---|---|---|
| `PK_Programs` | Programs | Menjamin identitas unik program studi. |
| `UQ_Programs_ProgramCode` | Programs | Mencegah kode program studi duplikat. |
| `PK_Students` | Students | Menjamin identitas unik mahasiswa. |
| `UQ_Students_NIM` | Students | Mencegah NIM duplikat. |
| `FK_Students_Programs` | Students | Memastikan `ProgramId` merujuk pada program studi yang tersedia di tabel `Programs`. |

---

## Cara Menjalankan

1. Buka **SQL Server Management Studio (SSMS)**.
2. Hubungkan ke server `.\SQLEXPRESS` menggunakan **Windows Authentication**.
3. Pilih **File → Open → File**.
4. Buka file `database/Praktikum_StudentRegistrationDB.sql`.
5. Tekan **F5** untuk menjalankan script atau jalankan setiap bagian secara berurutan.
6. Pastikan database `StudentRegistrationDB`, tabel `Programs`, dan tabel `Students` berhasil dibuat.

**Catatan:** Script dirancang untuk dapat dijalankan ulang. Tabel lama dihapus terlebih dahulu sebelum dibuat kembali, sehingga data yang sudah ada pada tabel tersebut akan terhapus.

---

## Isi Script Praktikum

| Bagian | Keterangan |
|---|---|
| LAB 09–10 | Membuat dan menggunakan database `StudentRegistrationDB`. |
| LAB 11–13 | Membuat tabel `Programs` dan mengisi 5 program studi. |
| LAB 14–17 | Membuat tabel `Students` dan mengisi 5 mahasiswa. |
| LAB 18 | Menggabungkan tabel menggunakan `INNER JOIN`. |
| LAB 19 | Menguji Foreign Key dengan `ProgramId = 99`, yang seharusnya ditolak. |
| LAB 20 | Menguji UNIQUE constraint dengan NIM duplikat `20231001`, yang seharusnya ditolak. |
| LAB 21–23 | Memeriksa struktur tabel, kolom, dan relasi. |
| LAB 24 | Mengerjakan query menggunakan `SELECT`, `WHERE`, `COUNT`, dan `GROUP BY`. |
| Mini Assignment | Menambahkan 3 mahasiswa baru dari program studi TI, SI, dan TE, lalu menampilkan hasil JOIN. |

---

## Mini Assignment

Tiga mahasiswa baru yang ditambahkan ke database:

| NIM | Nama | Program Studi |
|---|---|---|
| 20231006 | Vikri Zavandra | Teknik Informatika |
| 20231007 | Aminah | Sistem Informasi |
| 20231008 | Zayyidan | Teknik Elektro |

**Total mahasiswa setelah Mini Assignment: 8 mahasiswa.**

---

## Hasil Praktikum

### 2. Database StudentRegistrationDB

<img width="315" height="162" alt="image" src="https://github.com/user-attachments/assets/78230caf-a9d9-4cb8-94e6-cfa15b8c399c" />

### 3. Tabel Programs

<img width="852" height="271" alt="image" src="https://github.com/user-attachments/assets/041841d3-4f68-4afd-a501-7f3b3b8b525f" />


### 4. Tabel Students

<img width="1117" height="257" alt="image" src="https://github.com/user-attachments/assets/ad8e7103-3814-4ffb-b7e7-b2fefc5ddfc4" />


### 5. Hasil JOIN (Mini Assignment)

<img width="667" height="297" alt="image" src="https://github.com/user-attachments/assets/60ec7f92-a38c-4197-a54f-c2980a209947" />


---

## Implementasi WPF

### Tampilan Aplikasi

<img width="847" height="201" alt="image" src="https://github.com/user-attachments/assets/c4cbd1fd-963d-40dd-98a9-eb4b6392609a" />


### Refresh Data

<img width="848" height="207" alt="image" src="https://github.com/user-attachments/assets/4c5f350d-bb3c-49df-b535-d5d3b4aed70a" />


---

## Connection String

Berikut connection string untuk menghubungkan aplikasi WPF dengan database `StudentRegistrationDB` menggunakan SQL Server Express:

```csharp
string connectionString =
    @"Server=.\SQLEXPRESS;Database=StudentRegistrationDB;Trusted_Connection=True;TrustServerCertificate=True;";
```

Pastikan nama server sesuai dengan instance SQL Server yang digunakan pada komputer.

---

## Alur Integrasi Aplikasi

```text
WPF UI
   |
   v
ViewModel
   |
   v
Repository
   |
   v
ADO.NET
   |
   v
SQL Server
   |
   v
StudentRegistrationDB
```

Aplikasi WPF berinteraksi dengan database melalui Repository dan ADO.NET untuk menjalankan operasi pengambilan serta pengelolaan data mahasiswa.
