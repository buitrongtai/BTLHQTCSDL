-- View 1: Hiển thị thông tin khách hàng và thẻ VIP (nếu có)
CREATE VIEW View_KhachHang_TheVIP AS
SELECT 
    KhachHang.MaKH, 
    KhachHang.TenKH, 
    KhachHang.SoDienThoai, 
    TheVIP.MaTheVIP, 
    TheVIP.TiLeGiamGia, 
    TheVIP.NgayHetHan
FROM KhachHang
LEFT JOIN TheVIP ON KhachHang.MaKH = TheVIP.MaKH;
GO

-- View 2: Hiển thị thông tin tồn kho của các mặt hàng
CREATE VIEW View_HangHoa_TonKho AS
SELECT 
    MaHangHoa, 
    TenHangHoa, 
    DonGia, 
    SoLuongTon, 
    SoLuongToiThieu
FROM HangHoa;
GO

-- View 3: Hiển thị thông tin hóa đơn kèm tên khách hàng
CREATE VIEW View_HoaDon_KhachHang AS
SELECT 
    HoaDon.MaHoaDon, 
    KhachHang.TenKH, 
    HoaDon.NgayLap, 
    HoaDon.TongTien
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.MaKH = KhachHang.MaKH;
GO

-- View 4: Hiển thị chi tiết hóa đơn kèm thông tin sản phẩm và thành tiền
CREATE VIEW View_ChiTietHoaDon AS
SELECT 
    ChiTietHoaDon.MaChiTiet, 
    HoaDon.MaHoaDon, 
    HangHoa.TenHangHoa, 
    ChiTietHoaDon.SoLuong, 
    ChiTietHoaDon.DonGia, 
    (ChiTietHoaDon.SoLuong * ChiTietHoaDon.DonGia) AS ThanhTien
FROM ChiTietHoaDon
INNER JOIN HoaDon ON ChiTietHoaDon.MaHoaDon = HoaDon.MaHoaDon
INNER JOIN HangHoa ON ChiTietHoaDon.MaHangHoa = HangHoa.MaHangHoa;
GO

-- View 5: Hiển thị thông tin phiếu đổi hàng kèm tên hàng hóa trả và nhận
CREATE VIEW View_PhieuDoiHang AS
SELECT 
    PhieuDoi.MaPhieuDoi, 
    HoaDon.MaHoaDon, 
    HangHoaTra.TenHangHoa AS TenHangTra, 
    HangHoaNhan.TenHangHoa AS TenHangNhan, 
    PhieuDoi.SoTienChenhLech
FROM PhieuDoi
INNER JOIN HoaDon ON PhieuDoi.MaKH = HoaDon.MaKH  -- Sửa từ MaHoaDon thành MaKH
INNER JOIN HangHoa AS HangHoaTra ON PhieuDoi.MaHangHoaTra = HangHoaTra.MaHangHoa
INNER JOIN HangHoa AS HangHoaNhan ON PhieuDoi.MaHangHoaNhan = HangHoaNhan.MaHangHoa;
GO

-- View 6: Hiển thị thông tin phiếu chi kèm tên khách hàng
CREATE VIEW View_PhieuChi AS
SELECT 
    PhieuChi.MaPhieuChi, 
    HoaDon.MaHoaDon, 
    KhachHang.TenKH, 
    PhieuChi.NgayLap, 
    PhieuChi.LyDo, 
    PhieuChi.SoTien
FROM PhieuChi
INNER JOIN HoaDon ON PhieuChi.MaHoaDon = HoaDon.MaHoaDon
INNER JOIN KhachHang ON HoaDon.MaKH = KhachHang.MaKH;
GO

-- View 7: Hiển thị tổng số lượng và doanh thu của từng mặt hàng đã bán
CREATE VIEW View_TongHop_HangHoa_BanDuoc AS
SELECT 
    HangHoa.MaHangHoa, 
    HangHoa.TenHangHoa, 
    SUM(ChiTietHoaDon.SoLuong) AS TongSoLuongBan, 
    SUM(ChiTietHoaDon.SoLuong * ChiTietHoaDon.DonGia) AS TongDoanhThu
FROM ChiTietHoaDon
INNER JOIN HangHoa ON ChiTietHoaDon.MaHangHoa = HangHoa.MaHangHoa
GROUP BY HangHoa.MaHangHoa, HangHoa.TenHangHoa;
GO

-- View 8: Hiển thị tổng tiền mua hàng của từng khách hàng
CREATE VIEW View_KhachHang_TongTienMuaHang AS
SELECT 
    KhachHang.MaKH, 
    KhachHang.TenKH, 
    SUM(HoaDon.TongTien) AS TongTienMuaHang
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.MaKH = KhachHang.MaKH
GROUP BY KhachHang.MaKH, KhachHang.TenKH;
GO

-- View 9: Hiển thị các mặt hàng cần nhập thêm do số lượng tồn kho thấp hơn mức tối thiểu
CREATE VIEW View_HangHoa_CanNhapThem AS
SELECT 
    MaHangHoa, 
    TenHangHoa, 
    SoLuongTon, 
    SoLuongToiThieu
FROM HangHoa
WHERE SoLuongTon < SoLuongToiThieu;
GO

-- View 10: Hiển thị thông tin khách hàng có thẻ VIP còn hiệu lực
CREATE VIEW View_KhachHang_VIP_ConLai AS
SELECT 
    KhachHang.MaKH, 
    KhachHang.TenKH, 
    TheVIP.MaTheVIP, 
    TheVIP.SoLanGiamGia AS SoLanConLai
FROM KhachHang
INNER JOIN TheVIP ON KhachHang.MaKH = TheVIP.MaKH
WHERE TheVIP.NgayHetHan >= GETDATE();
GO

-- View 11: Hiển thị chi tiết hóa đơn kèm thông tin sản phẩm
CREATE VIEW View_HoaDon_ChiTiet AS
SELECT 
    hd.MaHoaDon, 
    hd.MaKH, 
    hd.NgayLap, 
    hd.TongTien, 
    cthd.MaHangHoa, 
    cthd.SoLuong, 
    cthd.DonGia
FROM HoaDon hd
JOIN ChiTietHoaDon cthd ON hd.MaHoaDon = cthd.MaHoaDon;
GO

-- View 12: Hiển thị thông tin thẻ VIP còn hiệu lực
CREATE VIEW View_TheVIP_ConHieuLuc AS
SELECT 
    MaTheVIP, 
    MaKH, 
    SoLanGiamGia, 
    TiLeGiamGia, 
    NgayHetHan
FROM TheVIP
WHERE NgayHetHan >= GETDATE();
GO

-- View 13: Hiển thị thông tin đổi/trả hàng hợp lệ
CREATE VIEW View_DoiTraHang_HopLe AS
SELECT 
    pd.MaPhieuDoi, 
    pd.MaKH, 
    pd.NgayLap, 
    pd.MaHangHoaTra, 
    pd.SoLuongTra, 
    pd.MaHangHoaNhan, 
    pd.SoLuongNhan, 
    hd.NgayLap AS NgayMuaHang
FROM PhieuDoi pd
JOIN HoaDon hd ON pd.MaKH = hd.MaKH
JOIN TheVIP tv ON pd.MaKH = tv.MaKH
WHERE DATEDIFF(DAY, hd.NgayLap, pd.NgayLap) <= 30
AND tv.NgayHetHan >= GETDATE();
GO

-- View 14: Hiển thị chi tiết hóa đơn kèm thông tin sản phẩm và số lượng tồn kho
CREATE VIEW View_ChiTietHoaDon_HangHoa AS
SELECT 
    cthd.MaChiTiet, 
    cthd.MaHoaDon, 
    cthd.MaHangHoa, 
    cthd.SoLuong, 
    cthd.DonGia, 
    hh.TenHangHoa, 
    hh.SoLuongTon
FROM ChiTietHoaDon cthd
JOIN HangHoa hh ON cthd.MaHangHoa = hh.MaHangHoa;

--Cách dùng

SELECT * FROM View_KhachHang_TheVIP;


SELECT * FROM View_HangHoa_TonKho WHERE SoLuongTon < 10;


SELECT * FROM View_HoaDon_KhachHang WHERE NgayLap >= '2023-01-01';


SELECT * FROM View_ChiTietHoaDon WHERE MaHoaDon = 1;


SELECT * FROM View_PhieuDoiHang WHERE SoTienChenhLech > 0;


SELECT * FROM View_PhieuChi WHERE NgayLap BETWEEN '2023-01-01' AND '2023-12-31';


SELECT * FROM View_TongHop_HangHoa_BanDuoc ORDER BY TongDoanhThu DESC;


SELECT * FROM View_KhachHang_TongTienMuaHang WHERE TongTienMuaHang > 1000000;


SELECT * FROM View_HangHoa_CanNhapThem;


SELECT * FROM View_KhachHang_VIP_ConLai WHERE SoLanConLai > 0;


SELECT * FROM View_HoaDon_ChiTiet WHERE MaHoaDon = 2;


SELECT * FROM View_TheVIP_ConHieuLuc;


SELECT * FROM View_DoiTraHang_HopLe;


SELECT * FROM View_ChiTietHoaDon_HangHoa WHERE MaHoaDon = 3;