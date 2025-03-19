
SET IDENTITY_INSERT KhachHang ON;
INSERT INTO KhachHang (MaKH, TenKH, DiaChi, SoDienThoai, Email)
VALUES 
(7, N'Nguyễn Thị G', N'Hà Nội', '0911111111', 'nguyenthig@gmail.com'),
(8, N'Trần Văn H', N'Hồ Chí Minh', '0922222222', 'tranvanh@gmail.com'),
(9, N'Lê Thị I', N'Đà Nẵng', '0933333333', 'lethii@gmail.com'),
(10, N'Phạm Văn K', N'Cần Thơ', '0944444444', 'phamvank@gmail.com'),
(11, N'Hoàng Thị L', N'Hải Phòng', '0955555555', 'hoangthil@gmail.com'),
(12, N'Vũ Văn M', N'Bình Dương', '0966666666', 'vuvanm@gmail.com'),
(13, N'Nguyễn Văn N', N'Hà Nội', '0977777777', 'nguyenvann@gmail.com'),
(14, N'Trần Thị O', N'Hồ Chí Minh', '0988888888', 'tranthio@gmail.com'),
(15, N'Lê Văn P', N'Đà Nẵng', '0999999999', 'levanp@gmail.com'),
(16, N'Phạm Thị Q', N'Cần Thơ', '0900000000', 'phamthiq@gmail.com'),
(17, N'Hoàng Văn R', N'Hải Phòng', '0912121212', 'hoangvanr@gmail.com'),
(18, N'Vũ Thị S', N'Bình Dương', '0923232323', 'vuthis@gmail.com'),
(19, N'Nguyễn Văn T', N'Hà Nội', '0934343434', 'nguyenvant@gmail.com'),
(20, N'Trần Thị U', N'Hồ Chí Minh', '0945454545', 'tranthiu@gmail.com'),
(21, N'Lê Văn V', N'Đà Nẵng', '0956565656', 'levanv@gmail.com'),
(22, N'Phạm Thị X', N'Cần Thơ', '0967676767', 'phamthix@gmail.com'),
(23, N'Hoàng Văn Y', N'Hải Phòng', '0978787878', 'hoangvany@gmail.com'),
(24, N'Vũ Thị Z', N'Bình Dương', '0989898989', 'vuthiz@gmail.com'),
(25, N'Nguyễn Văn AA', N'Hà Nội', '0990909090', 'nguyenvanaa@gmail.com'),
(26, N'Trần Thị BB', N'Hồ Chí Minh', '0901010101', 'tranthibb@gmail.com');

SET IDENTITY_INSERT KhachHang OFF;
go
--the vip
INSERT INTO TheVIP (MaKH, SoLanGiamGia, TiLeGiamGia, NgayHetHan)
VALUES 
(7, 3, 0.1, '2026-12-31'),
(8, 2, 0.15, '2026-01-30'),
(9, 4, 0.2, '2026-01-31'),
(10, 1, 0.1, '2026-02-15'),
(11, 5, 0.05, '2026-02-20'),
(12, 3, 0.1, '2026-12-31'), 
(13, 2, 0.15, '2026-01-30'),
(14, 4, 0.2, '2026-01-31'),  
(15, 1, 0.1, '2026-02-15'), 
(16, 5, 0.05, '2026-02-20'); 
go
--2. Bảng HangHoa
SET IDENTITY_INSERT HangHoa ON;

INSERT INTO HangHoa (MaHangHoa, TenHangHoa, DonGia, SoLuongTon, SoLuongToiThieu)
VALUES 
(9, N'bột giặt', 20000, 20, 40);
SET IDENTITY_INSERT HangHoa off;

go
--3. Bảng HoaDon
SET IDENTITY_INSERT HoaDon ON;

INSERT INTO HoaDon (MaHoaDon, MaKH, NgayLap, TongTien)
VALUES 
(6, 7, '2025-01-06', 250000),
(7, 8, '2025-01-07', 300000),
(8, 9, '2025-01-08', 150000),
(9, 10, '2025-01-09', 200000),
(10, 11, '2025-01-10', 350000);

SET IDENTITY_INSERT HoaDon OFF;
go
--4. Bảng ChiTietHoaDon
SET IDENTITY_INSERT ChiTietHoaDon ON;

INSERT INTO ChiTietHoaDon (MaChiTiet, MaHoaDon, MaHangHoa, SoLuong, DonGia)
VALUES 
(9, 6, 1, 5, 10000),
(10, 6, 2, 3, 20000),
(11, 7, 3, 1, 150000),
(12, 7, 4, 2, 300000), 
(13, 8, 5, 4, 25000),
(14, 8, 6, 2, 50000),
(15, 9, 7, 10, 15000),
(16, 10, 8, 5, 30000);
SET IDENTITY_INSERT ChiTietHoaDon OFF;
go
--5. Bảng PhieuNhapHang
SET IDENTITY_INSERT PhieuNhapHang ON;

INSERT INTO PhieuNhapHang (MaPhieuNhap, NgayLap, MaHangHoa, SoLuong)
VALUES 
(5, '2023-10-10', 5, 50),  -- Nhập thêm 50 kem đánh răng
(6, '2023-10-11', 6, 30),  -- Nhập thêm 30 dầu gội đầu
(7, '2023-10-12', 7, 20),  -- Nhập thêm 20 bàn chải đánh răng
(8, '2023-10-13', 8, 10);  -- Nhập thêm 10 nước rửa chén

SET IDENTITY_INSERT PhieuNhapHang OFF;

go
--6. Bảng PhieuChi
SET IDENTITY_INSERT PhieuChi ON;

INSERT INTO PhieuChi (MaPhieuChi, MaKH, MaHoaDon, NgayLap, SoTien, LyDo)
VALUES 
(4, 7, 6, '2023-10-10', 50000, N'Trả hàng không vừa ý'), -- Nguyễn Thị G trả lại 5 bánh mì
(5, 8, 7, '2023-10-11', 100000, N'Trả hàng không vừa ý'), -- Trần Văn H trả lại 1 áo thun
(6, 9, 8, '2023-10-12', 75000, N'Trả hàng không vừa ý');  -- Lê Thị I trả lại 4 kem đánh răng

SET IDENTITY_INSERT PhieuChi OFF;
go
--7. Bảng PhieuDoi
SET IDENTITY_INSERT PhieuDoi ON;

INSERT INTO PhieuDoi (MaPhieuDoi, MaKH, NgayLap, MaHangHoaTra, SoLuongTra, SoTienTra, MaHangHoaNhan, SoLuongNhan, SoTienNhan, SoTienChenhlech)
VALUES 
(4, 7, '2023-10-10', 1, 5, 50000, 2, 3, 60000, 10000),
(5, 8, '2023-10-11', 3, 1, 150000, 5, 5, 125000, -25000),
(6, 9, '2023-10-12', 5, 4, 100000, 6, 2, 100000, 0);

SET IDENTITY_INSERT PhieuDoi OFF;
