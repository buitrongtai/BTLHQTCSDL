-- Bảng Khách hàng
CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY IDENTITY(1,1),
    TenKH NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255),
    SoDienThoai NVARCHAR(15),
    Email NVARCHAR(100)
);

-- Bảng Thẻ VIP
CREATE TABLE TheVIP (
    MaTheVIP INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT,
    SoLanGiamGia INT,
    TiLeGiamGia FLOAT,
    NgayHetHan DATE,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Bảng Hàng hóa
CREATE TABLE HangHoa (
    MaHangHoa INT PRIMARY KEY IDENTITY(1,1),
    TenHangHoa NVARCHAR(100) NOT NULL,
    DonGia FLOAT NOT NULL,
    SoLuongTon INT,
    SoLuongToiThieu INT
);

-- Bảng Hóa đơn
CREATE TABLE HoaDon (
    MaHoaDon INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT,
    NgayLap DATE,
    TongTien FLOAT,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Bảng Chi tiết Hóa đơn
CREATE TABLE ChiTietHoaDon (
    MaChiTiet INT PRIMARY KEY IDENTITY(1,1),
    MaHoaDon INT,
    MaHangHoa INT,
    SoLuong INT,
    DonGia FLOAT,
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
    FOREIGN KEY (MaHangHoa) REFERENCES HangHoa(MaHangHoa)
);

-- Bảng Phiếu nhập hàng
CREATE TABLE PhieuNhapHang (
    MaPhieuNhap INT PRIMARY KEY IDENTITY(1,1),
    NgayLap DATE,
    MaHangHoa INT,
    SoLuong INT,
    FOREIGN KEY (MaHangHoa) REFERENCES HangHoa(MaHangHoa)
);
-- Bảng Phiếu Chi (ghi nhận lịch sử đổi/trả hàng)
CREATE TABLE PhieuChi (
    MaPhieuChi INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT,
    MaHoaDon INT,
    NgayLap DATE,
    SoTien FLOAT,
    LyDo NVARCHAR(255),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon)
);

-- Bảng Phiếu Đổi (ghi nhận thông tin đổi/trả hàng)
CREATE TABLE PhieuDoi (
    MaPhieuDoi INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT,
    NgayLap DATE,
    MaHangHoaTra INT,
    SoLuongTra INT,
    SoTienTra FLOAT,
    MaHangHoaNhan INT,
    SoLuongNhan INT,
    SoTienNhan FLOAT,
    SoTienChenhlech FLOAT,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaHangHoaTra) REFERENCES HangHoa(MaHangHoa),
    FOREIGN KEY (MaHangHoaNhan) REFERENCES HangHoa(MaHangHoa)
);
