# PL/SQL Training Project - Berijalan Bootcamp

## 📋 Overview

Repositori ini merupakan hasil belajar dari **training PL/SQL** di **Berijalan** pada rangkaian
**Bootcamp Technocenter Batch 15** dengan mentor **Mas Deni** dan **Mas Raymond**.

**📅 Periode Training:** 26 September 2025 - 02 Oktober 2025  
**📍 Lokasi:** Berijalan Office Lantai 8

## 🎯 Project Description

Implementasi sistem approval pengajuan kredit customer menggunakan Oracle PL/SQL dengan berbagai
komponen:

- Master data management
- Business logic functions
- Stored procedures
- Transaction handling
- Error management

## 📁 File Structure

```
final_test/
├── 1.sql - Task 1: Create table master approval
├── 2.sql - Task 2: Function get_highest_level
├── 3.sql - Task 3: Create table transaksi pengajuan customer
├── 4.sql - Task 4: Create table transaksi approval customer
├── 5.sql - Task 5: Procedure insert pengajuan customer
├── 6.sql - Task 6: Function get_next_level_app
├── 7.sql - Task 7: Procedure gen_approval
└── Other basic materials
```

## 🚀 Features Implemented on Final Test

### Task 1: Master Approval Table

- Tabel master untuk level approval berdasarkan range amount
- Data USER01 - USER05 dengan range 1 - 500,000,000

### Task 2: Function get_highest_level

- Function untuk mendapatkan level approval tertinggi
- Input: amount_pengajuan
- Output: cd_user atau ' ' jika diluar range

### Task 3: Transaction Tables

- Tabel transaksi pengajuan customer
- Status: WAITING, IN PROGRESS, APPROVED, REJECTED
- Auto-generate ID 10 digit

### Task 4: Approval History

- Tabel history approval per level
- Tracking nomor urut approval dan hasil keputusan

### Task 5: Insert Pengajuan Procedure

- Procedure untuk insert pengajuan baru
- Validasi input dan business rules
- Auto-generate customer ID

### Task 6: Next Level Function

- Function untuk mendapatkan level approval berikutnya
- Logic navigasi antar level approval

### Task 7: Approval Process

- Procedure untuk proses approval
- Update status berdasarkan keputusan
- Integration dengan semua komponen

## 🧪 Testing

Setiap task dilengkapi dengan comprehensive test cases:

- Positive scenarios
- Negative scenarios
- Edge cases
- Error handling validation

## 🎓 Learning Outcomes

- Oracle PL/SQL fundamentals
- Stored procedures and functions
- Transaction management
- Error handling
- Business logic implementation
- Database design patterns

## 👨‍🏫 Mentors

- **Mas Deni**
- **Mas Raymond**

## 🏢 Organization

**Berijalan - Bootcamp Technocenter Batch 15**

---

_Terima kasih kepada mentor dan tim Berijalan atas guidance selama training PL/SQL ini! 🙏_
