--1. Hàm vô hướng: Tính tổng tiền của một hóa đơn
CREATE FUNCTION dbo.fn_TinhTongTienHoaDon
(
    @MaHoaDon INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TongTien FLOAT;

    SELECT @TongTien = SUM(SoLuong * DonGia)
    FROM ChiTietHoaDon
    WHERE MaHoaDon = @MaHoaDon;

    RETURN @TongTien;
END;
go
--2. Hàm vô hướng: Kiểm tra số lượng tồn kho của một mặt hàng
CREATE FUNCTION dbo.fn_GetSoLuongTon
(
    @MaHangHoa INT
)
RETURNS INT
AS
BEGIN
    DECLARE @SoLuongTon INT;

    SELECT @SoLuongTon = SoLuongTon
    FROM HangHoa
    WHERE MaHangHoa = @MaHangHoa;

    RETURN @SoLuongTon;
END;
go
--3. Hàm vô hướng: Tính số tiền chênh lệch khi đổi hàng
CREATE FUNCTION dbo.fn_TinhTienChenhLech
(
    @MaHangTra INT,
    @SoLuongTra INT,
    @MaHangNhan INT,
    @SoLuongNhan INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @DonGiaTra FLOAT, @DonGiaNhan FLOAT, @SoTienChenhLech FLOAT;

    -- Lấy đơn giá của hàng trả và hàng nhận
    SELECT @DonGiaTra = DonGia FROM HangHoa WHERE MaHangHoa = @MaHangTra;
    SELECT @DonGiaNhan = DonGia FROM HangHoa WHERE MaHangHoa = @MaHangNhan;

    -- Tính số tiền chênh lệch
    SET @SoTienChenhLech = (@SoLuongTra * @DonGiaTra) - (@SoLuongNhan * @DonGiaNhan);

    RETURN @SoTienChenhLech;
END;
go
--4. Hàm bảng: Lấy danh sách khách hàng
CREATE FUNCTION dbo.fn_GetAllKhachHang()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM KhachHang
);
go
--5. Hàm bảng: Lấy thông tin hóa đơn theo khách hàng
CREATE FUNCTION dbo.fn_GetHoaDonByKhachHang
(
    @MaKH INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM HoaDon WHERE MaKH = @MaKH
);
go
--6. Hàm bảng: Lấy danh sách hàng hóa cần nhập thêm
CREATE FUNCTION dbo.fn_GetHangHoaCanNhapThem()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM HangHoa WHERE SoLuongTon < SoLuongToiThieu
);
go
--7. Hàm bảng: Lấy thông tin chi tiết hóa đơn
CREATE FUNCTION dbo.fn_GetChiTietHoaDon
(
    @MaHoaDon INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM ChiTietHoaDon WHERE MaHoaDon = @MaHoaDon
);
go
--8. Hàm biến bảng: Lấy thông tin khách hàng và thẻ VIP
CREATE FUNCTION dbo.fn_GetKhachHangTheVIP()
RETURNS @Result TABLE
(
    MaKH INT,
    TenKH NVARCHAR(100),
    MaTheVIP INT,
    SoLanGiamGia INT,
    NgayHetHan DATE
)
AS
BEGIN
    INSERT INTO @Result
    SELECT kh.MaKH, kh.TenKH, tv.MaTheVIP, tv.SoLanGiamGia, tv.NgayHetHan
    FROM KhachHang kh
    LEFT JOIN TheVIP tv ON kh.MaKH = tv.MaKH;

    RETURN;
END;
go
--9. Hàm biến bảng: Lấy thông tin đổi/trả hàng hợp lệ
CREATE FUNCTION dbo.fn_GetDoiTraHangHopLe()
RETURNS @Result TABLE
(
    MaPhieuDoi INT,
    MaKH INT,
    NgayLap DATE,
    MaHangHoaTra INT,
    SoLuongTra INT,
    MaHangHoaNhan INT,
    SoLuongNhan INT
)
AS
BEGIN
    INSERT INTO @Result
    SELECT pd.MaPhieuDoi, pd.MaKH, pd.NgayLap, pd.MaHangHoaTra, pd.SoLuongTra, pd.MaHangHoaNhan, pd.SoLuongNhan
    FROM PhieuDoi pd
    JOIN HoaDon hd ON pd.MaKH = hd.MaKH
    WHERE DATEDIFF(DAY, hd.NgayLap, pd.NgayLap) <= 30;

    RETURN;
END;
go
--10. Hàm biến bảng: Lấy thông tin hàng hóa và số lượng tồn kho
CREATE FUNCTION dbo.fn_GetHangHoaTonKho()
RETURNS @Result TABLE
(
    MaHangHoa INT,
    TenHangHoa NVARCHAR(100),
    SoLuongTon INT,
    SoLuongToiThieu INT
)
AS
BEGIN
    INSERT INTO @Result
    SELECT MaHangHoa, TenHangHoa, SoLuongTon, SoLuongToiThieu
    FROM HangHoa;

    RETURN;
END;


--1
SELECT dbo.fn_TinhTongTienHoaDon(1) AS TongTien;
SELECT dbo.fn_GetSoLuongTon(101) AS SoLuongTon;


--2
SELECT * FROM dbo.fn_GetAllKhachHang();
SELECT * FROM dbo.fn_GetHoaDonByKhachHang(1);
SELECT * FROM dbo.fn_GetHangHoaCanNhapThem();
SELECT * FROM dbo.fn_GetChiTietHoaDon(1);

--3
SELECT * FROM dbo.fn_GetKhachHangTheVIP();
SELECT * FROM dbo.fn_GetDoiTraHangHopLe();
SELECT * FROM dbo.fn_GetHangHoaTonKho();