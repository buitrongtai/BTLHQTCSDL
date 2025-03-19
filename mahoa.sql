
CREATE SYMMETRIC KEY KhoaBimat
WITH ALGORITHM = AES_256
ENCRYPTION BY PASSWORD = 'MatKhauManh@123';

OPEN SYMMETRIC KEY KhoaBimat DECRYPTION BY PASSWORD = 'MatKhauManh@123';
UPDATE KhachHang
SET 
    SoDienThoai = ENCRYPTBYKEY(KEY_GUID('KhoaBimat'), SoDienThoai),
    Email = ENCRYPTBYKEY(KEY_GUID('KhoaBimat'), Email);

OPEN SYMMETRIC KEY KhoaBimat DECRYPTION BY PASSWORD = 'MatKhauManh@123';
SELECT 
    TenKH,
    CONVERT(NVARCHAR, DECRYPTBYKEY(SoDienThoai)) AS SoDienThoai,
    CONVERT(NVARCHAR, DECRYPTBYKEY(Email)) AS Email
FROM KhachHang;
