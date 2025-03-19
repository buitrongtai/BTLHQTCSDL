-- Tạo LOGIN cho SQL Server
CREATE LOGIN Kien_admin WITH PASSWORD = 'kien123';
CREATE LOGIN Tai_viewer WITH PASSWORD = 'tai123';
CREATE LOGIN Son_operator WITH PASSWORD = 'son123';


-- Chuyển sang cơ sở dữ liệu cần thiết lập
USE master;

-- Tạo USER trong database
CREATE USER Kien_admin FOR LOGIN Kien_admin;
CREATE USER Tai_viewer FOR LOGIN Tai_viewer;
CREATE USER Son_operator FOR LOGIN Son_operator;

-- Cấp quyền cho Kien (admin) - Toàn quyền quản trị
ALTER ROLE db_owner ADD MEMBER Kien_admin;

-- Cấp quyền cho Tai (viewer) - Chỉ đọc dữ liệu
ALTER ROLE db_datareader ADD MEMBER Tai_viewer;

-- Cấp quyền cho Son (operator) - Đọc, ghi, sửa dữ liệu
ALTER ROLE db_datawriter ADD MEMBER Son_operator;
GRANT SELECT, INSERT, UPDATE, DELETE ON DATABASE::master TO Son_operator;

-- Quản lý sao lưu và phục hồi dữ liệu
-- Cấp quyền backup/restore cho Kiên (admin) và Sơn (operator)
GRANT BACKUP DATABASE TO Kien_admin, Son_operator;
GRANT BACKUP LOG TO Kien_admin, Son_operator;
GRANT CREATE DATABASE TO Kien_admin;

-- Cấp quyền phục hồi dữ liệu
GRANT ALTER ANY DATABASE TO Kien_admin, Son_operator;

-- Kiểm tra tạo LOGIN
SELECT name FROM sys.sql_logins WHERE name IN ('Kien_admin', 'Tai_viewer', 'Son_operator');

--Kiểm tra tạo USER trong database
USE master;
SELECT name FROM sys.database_principals WHERE name IN ('Kien_admin', 'Tai_viewer', 'Son_operator');

--Kiểm tra phân quyền
SELECT dp.name AS UserName, dp.type_desc, rp.name AS RoleName
FROM sys.database_role_members drm
JOIN sys.database_principals rp ON drm.role_principal_id = rp.principal_id
JOIN sys.database_principals dp ON drm.member_principal_id = dp.principal_id
WHERE dp.name IN ('Kien_admin', 'Tai_viewer', 'Son_operator');

--Kiểm tra quyền Backup & Restore
SELECT * FROM fn_my_permissions(NULL, 'DATABASE') 
WHERE permission_name IN ('BACKUP DATABASE', 'BACKUP LOG', 'ALTER ANY DATABASE');

--Backup
BACKUP DATABASE [master] 
TO DISK = 'C:\Backup\BTL-CSDL_backup.bak'
WITH FORMAT, INIT, NAME = 'Backup Master Database';

--RESTORE 
RESTORE FILELISTONLY 
FROM DISK = 'C:\Backup\BTL-CSDL_backup.bak';