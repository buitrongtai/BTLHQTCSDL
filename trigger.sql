create TRIGGER TRG_ChiTietHoaDon_Insert
ON ChiTietHoaDon
FOR INSERT
AS
BEGIN
    DECLARE @MaHangHoa INT, @SoLuong INT;
    -- Lấy thông tin từ bảng INSERTED
    SELECT @MaHangHoa = MaHangHoa, @SoLuong = SoLuong
    FROM INSERTED;
    -- Kiểm tra số lượng tồn kho
    IF (SELECT SoLuongTon FROM View_HangHoa_TonKho WHERE MaHangHoa = @MaHangHoa) < @SoLuong
    BEGIN
        RAISERROR('Số lượng hàng hóa không đủ để bán.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- Cập nhật số lượng tồn kho
        UPDATE HangHoa
        SET SoLuongTon = SoLuongTon - @SoLuong
        WHERE MaHangHoa = @MaHangHoa;
    END
END;
go
create TRIGGER TRG_ChiTietHoaDon_Insert_UpdateTongTien
ON ChiTietHoaDon
FOR INSERT
AS
BEGIN
    DECLARE @MaHoaDon INT, @ThanhTien FLOAT;

    -- Lấy thông tin từ bảng INSERTED
    SELECT @MaHoaDon = MaHoaDon, @ThanhTien = SoLuong * DonGia
    FROM INSERTED;

    -- Cập nhật tổng tiền hóa đơn
    UPDATE HoaDon
    SET TongTien = TongTien + @ThanhTien
    WHERE MaHoaDon = @MaHoaDon;
END;
go
create TRIGGER TRG_HoaDon_Insert_CheckVIP
ON HoaDon
FOR INSERT
AS
BEGIN
    DECLARE @MaKH INT, @MaTheVIP INT, @SoLanGiamGia INT;

    -- Lấy thông tin từ bảng INSERTED
    SELECT @MaKH = MaKH
    FROM INSERTED;
    -- Kiểm tra thẻ VIP bằng View
    SELECT @MaTheVIP = MaTheVIP, @SoLanGiamGia = SoLanGiamGia
    FROM View_TheVIP_ConHieuLuc
    WHERE MaKH = @MaKH;

    -- Nếu thẻ VIP hết hiệu lực hoặc hết số lần sử dụng
    IF @MaTheVIP IS NULL OR @SoLanGiamGia <= 0
    BEGIN
        RAISERROR('Thẻ VIP không hợp lệ hoặc đã hết số lần sử dụng.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- Giảm số lần sử dụng thẻ VIP
        UPDATE TheVIP
        SET SoLanGiamGia = SoLanGiamGia - 1
        WHERE MaTheVIP = @MaTheVIP;
    END
END;
go
-- Trigger kiểm tra điều kiện đổi/trả hàng
create TRIGGER trg_Kiem_tra_doi_hang
ON PhieuDoi
AFTER INSERT
AS
BEGIN
    -- Kiểm tra nếu hàng đổi/trả không có trong hóa đơn của khách hàng
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN View_ChiTietHoaDon_HangHoa cthd ON i.MaHangHoaTra = cthd.MaHangHoa
        LEFT JOIN HoaDon hd ON cthd.MaHoaDon = hd.MaHoaDon AND hd.MaKH = i.MaKH
        WHERE cthd.MaHoaDon IS NULL
    BEGIN
        RAISERROR ('Hàng đổi/trả không có trong hóa đơn mua hàng.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    -- Kiểm tra thời gian đổi/trả có trong vòng 30 ngày không
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN View_DoiTraHang_HopLe v ON i.MaKH = v.MaKH
        WHERE DATEDIFF(DAY, v.NgayMuaHang, i.NgayLap) > 30
    )
    BEGIN
        RAISERROR ('Hàng đổi/trả đã quá thời hạn 30 ngày.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    -- Kiểm tra khách hàng có sử dụng thẻ VIP khi mua hàng không
    IF NOT EXISTS (
        SELECT 1
        FROM inserted i
        JOIN View_KhachHang_TheVIP v ON i.MaKH = v.MaKH
    )
    BEGIN
        RAISERROR ('Khách hàng không có thẻ VIP, không thể đổi/trả hàng.', 16, 1);
        ROLLBACK;
        RETURN;
    END;
END;

go
create TRIGGER TRG_HangHoa_Update_CheckTonKho
ON HangHoa
FOR UPDATE
AS
BEGIN
    DECLARE @MaHangHoa INT, @SoLuongTon INT, @SoLuongToiThieu INT;

    -- Lấy thông tin từ bảng INSERTED
    SELECT @MaHangHoa = MaHangHoa, @SoLuongTon = SoLuongTon, @SoLuongToiThieu = SoLuongToiThieu
    FROM INSERTED;

    -- Kiểm tra số lượng tồn kho
    IF @SoLuongTon < @SoLuongToiThieu
    BEGIN
        -- Tạo phiếu nhập hàng
        INSERT INTO PhieuNhapHang (NgayLap, MaHangHoa, SoLuong)
        VALUES (GETDATE(), @MaHangHoa, @SoLuongToiThieu - @SoLuongTon);
    END
END;