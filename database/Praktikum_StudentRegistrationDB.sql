/* =====================================================================
   LAB 09 — Membuat Database
   ===================================================================== */
IF DB_ID('StudentRegistrationDB') IS NULL
    CREATE DATABASE StudentRegistrationDB;
GO


/* =====================================================================
   LAB 10 — Menggunakan Database
   ===================================================================== */
USE StudentRegistrationDB;
GO

SELECT DB_NAME() AS CurrentDatabase;   -- Hasil: StudentRegistrationDB
GO


DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Programs;
GO


/* =====================================================================
   LAB 11 — Membuat Tabel Programs
   ===================================================================== */
CREATE TABLE Programs
(
    ProgramId   INT IDENTITY(1,1)
                CONSTRAINT PK_Programs PRIMARY KEY,
    ProgramCode VARCHAR(20) NOT NULL
                CONSTRAINT UQ_Programs_ProgramCode UNIQUE,
    ProgramName VARCHAR(100) NOT NULL,
    IsActive    BIT NOT NULL
                CONSTRAINT DF_Programs_IsActive DEFAULT 1,
    CreatedAt   DATETIME2 NOT NULL
                CONSTRAINT DF_Programs_CreatedAt DEFAULT SYSDATETIME()
);
GO


/* =====================================================================
   LAB 12 — Memasukkan Data Program Studi
   ===================================================================== */
INSERT INTO Programs (ProgramCode, ProgramName)
VALUES
('TI',  'Teknik Informatika'),
('SI',  'Sistem Informasi'),
('MNJ', 'Manajemen'),
('TE',  'Teknik Elektro'),
('DKV', 'Desain Komunikasi Visual');
GO


/* =====================================================================
   LAB 13 — Melihat Data Programs
   ===================================================================== */
SELECT *
FROM Programs;
GO


/* =====================================================================
   LAB 14 — Membuat Tabel Students
   ===================================================================== */
CREATE TABLE Students
(
    StudentId   INT IDENTITY(1,1)
                CONSTRAINT PK_Students PRIMARY KEY,
    NIM         VARCHAR(20) NOT NULL
                CONSTRAINT UQ_Students_NIM UNIQUE,
    Name        VARCHAR(100) NOT NULL,
    ProgramId   INT NOT NULL,
    BirthDate   DATE NULL,
    Address     VARCHAR(250) NULL,
    PhoneNumber VARCHAR(20) NULL,
    CreatedAt   DATETIME2 NOT NULL
                CONSTRAINT DF_Students_CreatedAt DEFAULT SYSDATETIME(),
    UpdatedAt   DATETIME2 NULL,

    CONSTRAINT FK_Students_Programs
        FOREIGN KEY (ProgramId)
        REFERENCES Programs(ProgramId)
);
GO


/* =====================================================================
   LAB 15 — Relasi 1:N
   Satu Program (1) dapat memiliki banyak Students (N).
   Diwujudkan oleh FK_Students_Programs: Students.ProgramId -> Programs.ProgramId
   ===================================================================== */


/* =====================================================================
   LAB 16 — Memasukkan Data Mahasiswa
   ===================================================================== */
INSERT INTO Students (NIM, Name, ProgramId, BirthDate, Address, PhoneNumber)
VALUES
('20231001', 'Ahmad Rizki',   1, '2003-03-12', 'Jl. Merdeka No. 123, Surabaya',   '081234567890'),
('20231002', 'Siti Aisyah',   2, '2004-07-21', 'Jl. Diponegoro No. 45, Surabaya', '082233445566'),
('20231003', 'Budi Santoso',  1, '2003-11-05', 'Jl. Ahmad Yani No. 10, Surabaya', '081355667788'),
('20231004', 'Citra Lestari', 3, '2004-01-18', 'Jl. Darmo No. 20, Surabaya',      '089900112233'),
('20231005', 'Dimas Prayoga', 4, '2003-09-27', 'Jl. Raya ITS, Surabaya',          '081288776655');
GO


/* =====================================================================
   LAB 17 — Menampilkan Data Students
   ===================================================================== */
SELECT *
FROM Students;
GO


/* =====================================================================
   LAB 18 — Menggabungkan Dua Tabel (INNER JOIN)
   ===================================================================== */
SELECT
    s.StudentId,
    s.NIM,
    s.Name,
    p.ProgramCode,
    p.ProgramName,
    s.BirthDate,
    s.PhoneNumber
FROM Students s
INNER JOIN Programs p
    ON s.ProgramId = p.ProgramId;
GO


/* =====================================================================
   LAB 19 — Pengujian Foreign Key
   ===================================================================== */
BEGIN TRY
    INSERT INTO Students (NIM, Name, ProgramId)
    VALUES ('20231099', 'Test Student', 99);
END TRY
BEGIN CATCH
    PRINT 'LAB 19 - DITOLAK (sesuai harapan): ' + ERROR_MESSAGE();
END CATCH;
GO


/* =====================================================================
   LAB 20 — Pengujian UNIQUE NIM
   ===================================================================== */
BEGIN TRY
    INSERT INTO Students (NIM, Name, ProgramId)
    VALUES ('20231001', 'Mahasiswa Duplikat', 1);
END TRY
BEGIN CATCH
    PRINT 'LAB 20 - DITOLAK (sesuai harapan): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Bukti tidak ada data yang masuk dari LAB 19 & LAB 20 (harus tetap 5 baris)
SELECT COUNT(*) AS JumlahSetelahUji FROM Students;
GO


/* =====================================================================
   LAB 21 & 22 — Melihat Struktur Database dan Kolom Tabel
   ===================================================================== */
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
GO

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Students'
ORDER BY ORDINAL_POSITION;
GO


/* =====================================================================
   LAB 23 — Melihat Relationship (PK, UNIQUE, FK)
   ===================================================================== */
SELECT
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE,
    kcu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_TYPE;
GO

SELECT
    fk.name                              AS ForeignKey,
    OBJECT_NAME(fk.parent_object_id)     AS TabelAnak_N,
    OBJECT_NAME(fk.referenced_object_id) AS TabelInduk_1
FROM sys.foreign_keys fk;
GO


/* =====================================================================
   LAB 24 — Query Challenge
   ===================================================================== */

-- Challenge 1 — Tampilkan seluruh mahasiswa
SELECT *
FROM Students;
GO

-- Challenge 2 — Tampilkan mahasiswa Teknik Informatika
SELECT
    s.NIM,
    s.Name,
    p.ProgramName
FROM Students s
INNER JOIN Programs p
    ON s.ProgramId = p.ProgramId
WHERE p.ProgramCode = 'TI';
GO

-- Challenge 3 — Hitung jumlah mahasiswa
SELECT COUNT(*) AS TotalMahasiswa
FROM Students;
GO

-- Challenge 4 — Hitung mahasiswa berdasarkan program studi
-- (LEFT JOIN agar prodi tanpa mahasiswa, misal DKV, tetap muncul dengan 0)
SELECT
    p.ProgramName,
    COUNT(s.StudentId) AS JumlahMahasiswa
FROM Programs p
LEFT JOIN Students s
    ON p.ProgramId = s.ProgramId
GROUP BY
    p.ProgramId,
    p.ProgramName;
GO


/* =====================================================================
   MINI ASSIGNMENT
   Tambah 3 mahasiswa: 1 TI, 1 SI, 1 TE.
   ProgramId diambil dari ProgramCode supaya tidak salah ID.
   ===================================================================== */
INSERT INTO Students (NIM, Name, ProgramId, BirthDate, Address, PhoneNumber)
VALUES
('20231006', 'Eka Wijaya',
    (SELECT ProgramId FROM Programs WHERE ProgramCode = 'TI'),
    '2004-02-14', 'Jl. Kertajaya No. 8, Surabaya',   '081311223344'),
('20231007', 'Fitri Handayani',
    (SELECT ProgramId FROM Programs WHERE ProgramCode = 'SI'),
    '2003-12-02', 'Jl. Pemuda No. 17, Surabaya',     '085733445566'),
('20231008', 'Galih Nugroho',
    (SELECT ProgramId FROM Programs WHERE ProgramCode = 'TE'),
    '2004-05-30', 'Jl. Manyar Kertoarjo No. 5, Surabaya', '087855667788');
GO

-- Mini Assignment 
SELECT
    s.NIM,
    s.Name,
    p.ProgramName,
    s.BirthDate,
    s.PhoneNumber
FROM Students s
INNER JOIN Programs p
    ON s.ProgramId = p.ProgramId
ORDER BY s.Name;
GO
