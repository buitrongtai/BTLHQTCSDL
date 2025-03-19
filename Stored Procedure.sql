CREATE PROCEDURE ThemKhachHang
    @TenKH NVARCHAR(100),
    @DiaChi NVARCHAR(255),
    @SoDienThoai NVARCHAR(15),
    @Email NVARCHAR(100)
AS
BEGIN
    INSERT INTO KhachHang (TenKH, DiaChi, SoDienThoai, Email)
    VALUES (@TenKH, @DiaChi, @SoDienThoai, @Email);
END;
go
CREATE PROCEDURE ThemHoaDon
    @MaKH INT,
    @NgayLap DATE,
    @TongTien FLOAT
AS
BEGIN
    INSERT INTO HoaDon (MaKH, NgayLap, TongTien)
    VALUES (@MaKH, @NgayLap, @TongTien);
END;
go
CREATE PROCEDURE ThemChiTietHoaDon
    @MaHoaDon INT,
    @MaHangHoa INT,
    @SoLuong INT,
    @DonGia FLOAT
AS
BEGIN
    INSERT INTO ChiTietHoaDon (MaHoaDon, MaHangHoa, SoLuong, DonGia)
    VALUES (@MaHoaDon, @MaHangHoa, @SoLuong, @DonGia);
END;
go
CREATE PROCEDURE KiemTraTonKho
AS
BEGIN
    DECLARE @MaHangHoa INT, @SoLuongTon INT, @SoLuongToiThieu INT;

    -- Duyệt qua các mặt hàng
    DECLARE cur CURSOR FOR
    SELECT MaHangHoa, SoLuongTon, SoLuongToiThieu FROM HangHoa;

    OPEN cur;
    FETCH NEXT FROM cur INTO @MaHangHoa, @SoLuongTon, @SoLuongToiThieu;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @SoLuongTon < @SoLuongToiThieu
        BEGIN
            -- Tạo phiếu nhập hàng
            INSERT INTO PhieuNhapHang (NgayLap, MaHangHoa, SoLuong)
            VALUES (GETDATE(), @MaHangHoa, @SoLuongToiThieu - @SoLuongTon);

            -- Cập nhật tồn kho
            UPDATE HangHoa SET SoLuongTon = @SoLuongToiThieu WHERE MaHangHoa = @MaHangHoa;
        END;

        FETCH NEXT FROM cur INTO @MaHangHoa, @SoLuongTon, @SoLuongToiThieu;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
go
CREATE PROCEDURE CapNhatTheVIP
    @MaTheVIP INT
AS
BEGIN
    UPDATE TheVIP
    SET SoLanGiamGia = SoLanGiamGia - 1
    WHERE MaTheVIP = @MaTheVIP;
END;
go
CREATE PROCEDURE SP_TinhTienChenhLech
    @MaHangTra INT,
    @SoLuongTra INT,
    @MaHangNhan INT,
    @SoLuongNhan INT,
    @SoTienChenhLech FLOAT OUTPUT
AS
BEGIN
    DECLARE @DonGiaTra FLOAT, @DonGiaNhan FLOAT;

    -- Lấy đơn giá của hàng trả và hàng nhận
    SELECT @DonGiaTra = DonGia FROM HangHoa WHERE MaHangHoa = @MaHangTra;
    SELECT @DonGiaNhan = DonGia FROM HangHoa WHERE MaHangHoa = @MaHangNhan;

    -- Tính số tiền chênh lệch
    SET @SoTienChenhLech = (@SoLuongTra * @DonGiaTra) - (@SoLuongNhan * @DonGiaNhan);
END;
go
CREATE PROCEDURE SP_GetSoLuongBan
    @MaHangHoa INT,
    @SoLuongBan INT OUTPUT
AS
BEGIN
    SELECT @SoLuongBan = SUM(SoLuong)
    FROM ChiTietHoaDon
    WHERE MaHangHoa = @MaHangHoa;
END;