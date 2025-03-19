-- Lấy thông tin hóa đơn kèm tên khách hàng
SELECT HoaDon.MaHoaDon, KhachHang.TenKH, HoaDon.NgayLap, HoaDon.TongTien
FROM HoaDon
JOIN KhachHang ON HoaDon.MaKH = KhachHang.MaKH;
-- Lấy thông tin chi tiết hóa đơn kèm tên hàng hóa
SELECT ChiTietHoaDon.MaChiTiet, HangHoa.TenHangHoa, ChiTietHoaDon.SoLuong, ChiTietHoaDon.DonGia
FROM ChiTietHoaDon
JOIN HangHoa ON ChiTietHoaDon.MaHangHoa = HangHoa.MaHangHoa;

--Lấy thông tin phiếu đổi hàng kèm tên hàng hóa trả và nhận
SELECT 
    PhieuDoiHang.MaPhieuDoi, 
    HangHoaTra.TenHangHoa AS TenHangTra, 
    HangHoaNhan.TenHangHoa AS TenHangNhan, 
    PhieuDoiHang.SoTienChenhLech
FROM PhieuDoiHang
JOIN HangHoa AS HangHoaTra ON PhieuDoiHang.MaHangTra = HangHoaTra.MaHangHoa
JOIN HangHoa AS HangHoaNhan ON PhieuDoiHang.MaHangNhan = HangHoaNhan.MaHangHoa;
--Lấy thông tin khách hàng có thẻ VIP còn hiệu lực
SELECT KhachHang.TenKH, TheVIP.NgayHetHan
FROM KhachHang
JOIN TheVIP ON KhachHang.MaKH = TheVIP.MaKH
WHERE TheVIP.NgayHetHan >= GETDATE();
--Lấy thông tin hàng hóa cần nhập thêm (số lượng tồn kho < số lượng tối thiểu)
SELECT TenHangHoa, SoLuongTon, SoLuongToiThieu
FROM HangHoa
WHERE SoLuongTon < SoLuongToiThieu;
--Tính tổng tiền của một hóa đơn
SELECT SUM(SoLuong * DonGia) AS TongTien
FROM ChiTietHoaDon
WHERE MaHoaDon = 1;
--Tính tổng số lượng hàng hóa đã bán
SELECT MaHangHoa, SUM(SoLuong) AS TongSoLuongBan
FROM ChiTietHoaDon
GROUP BY MaHangHoa;
--Xóa các hóa đơn cũ hơn 1 năm
DELETE FROM HoaDon
WHERE NgayLap < DATEADD(YEAR, -1, GETDATE());
-- Xóa các phiếu chi không có hóa đơn liên quan
DELETE FROM PhieuChi
WHERE MaHoaDon NOT IN (SELECT MaHoaDon FROM HoaDon);
--update dia chi khach
UPDATE KhachHang
SET DiaChi = N'Lài Cai'
WHERE MaKH = 1;
--Cập nhật số lượng tồn kho của hàng hóa
UPDATE HangHoa
SET SoLuongTon = SoLuongTon - 5
WHERE MaHangHoa = 2 AND SoLuongTon >= 5;

