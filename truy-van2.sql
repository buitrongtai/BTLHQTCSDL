--Lấy thông tin hóa đơn kèm tên khách hàng và tên hàng hóa
SELECT 
    HoaDon.MaHoaDon, 
    KhachHang.TenKH, 
    HangHoa.TenHangHoa, 
    ChiTietHoaDon.SoLuong, 
    ChiTietHoaDon.DonGia
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.MaKH = KhachHang.MaKH
INNER JOIN ChiTietHoaDon ON HoaDon.MaHoaDon = ChiTietHoaDon.MaHoaDon
INNER JOIN HangHoa ON ChiTietHoaDon.MaHangHoa = HangHoa.MaHangHoa;
--Lấy thông tin phiếu đổi hàng kèm tên khách hàng và tên hàng hóa
SELECT 
    pd.MaPhieuDoi, 
    kh.TenKH, 
    hhTra.TenHangHoa AS TenHangTra, 
    hhNhan.TenHangHoa AS TenHangNhan, 
    pd.SoTienChenhlech
FROM PhieuDoi pd
INNER JOIN KhachHang kh ON pd.MaKH = kh.MaKH 
INNER JOIN HangHoa hhTra ON pd.MaHangHoaTra = hhTra.MaHangHoa
INNER JOIN HangHoa hhNhan ON pd.MaHangHoaNhan = hhNhan.MaHangHoa;
--Tính tổng tiền mua hàng của mỗi khách hàng
SELECT 
    KhachHang.TenKH, 
    SUM(HoaDon.TongTien) AS TongTienMuaHang
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.MaKH = KhachHang.MaKH
GROUP BY KhachHang.TenKH;
--Tính tổng số lượng hàng hóa đã bán của mỗi mặt hàng
SELECT 
    HangHoa.TenHangHoa, 
    SUM(ChiTietHoaDon.SoLuong) AS TongSoLuongBan
FROM ChiTietHoaDon
INNER JOIN HangHoa ON ChiTietHoaDon.MaHangHoa = HangHoa.MaHangHoa
GROUP BY HangHoa.TenHangHoa;
--Lấy các khách hàng có tổng tiền mua hàng lớn hơn 500,000
SELECT 
    KhachHang.TenKH, 
    SUM(HoaDon.TongTien) AS TongTienMuaHang
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.MaKH = KhachHang.MaKH
GROUP BY KhachHang.TenKH
HAVING SUM(HoaDon.TongTien) > 500000;
--Lấy các mặt hàng có tổng số lượng bán lớn hơn 10
SELECT 
    HangHoa.TenHangHoa, 
    SUM(ChiTietHoaDon.SoLuong) AS TongSoLuongBan
FROM ChiTietHoaDon
INNER JOIN HangHoa ON ChiTietHoaDon.MaHangHoa = HangHoa.MaHangHoa
GROUP BY HangHoa.TenHangHoa
HAVING SUM(ChiTietHoaDon.SoLuong) > 10;
--Lấy thông tin khách hàng có tổng tiền mua hàng cao nhất
SELECT 
    KhachHang.TenKH, 
    SUM(HoaDon.TongTien) AS TongTienMuaHang
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.MaKH = KhachHang.MaKH
GROUP BY KhachHang.TenKH
HAVING SUM(HoaDon.TongTien) = (
    SELECT MAX(TongTienMuaHang)
    FROM (
        SELECT SUM(HoaDon.TongTien) AS TongTienMuaHang
        FROM HoaDon
        GROUP BY HoaDon.MaKH
    ) AS Temp
);
--Lấy thông tin hàng hóa chưa từng được bán
SELECT 
    HangHoa.TenHangHoa
FROM HangHoa
WHERE HangHoa.MaHangHoa NOT IN (
    SELECT DISTINCT MaHangHoa
    FROM ChiTietHoaDon
);
--Lấy thông tin khách hàng chưa từng mua hàng
SELECT 
    KhachHang.TenKH
FROM KhachHang
WHERE KhachHang.MaKH NOT IN (
    SELECT DISTINCT MaKH
    FROM HoaDon
);