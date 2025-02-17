﻿CREATE TABLE KHOA
(
MAKHOA CHAR(5) PRIMARY KEY,
TENKHOA NVARCHAR(60),
DIENTHOAI CHAR(12)
)
INSERT INTO KHOA VALUES ('KCNTT',N'KHOA CÔNG NGHỆ THÔNG TIN','0982291206')
INSERT INTO KHOA VALUES ('KQTKD',N'KHOA QUẢN TRỊ KINH DOANH','0902291206')
INSERT INTO KHOA VALUES ('KKTTC',N'KHOA KẾ TOÁN TÀI CHÍNH','0982291216')

CREATE TABLE LOP
(
    MALOP CHAR(5) PRIMARY KEY,
    TENLOP NVARCHAR(60),
    NIENKHOA CHAR(10),
    HEDAOTAO NVARCHAR(60),
    NAMNHAPHOC DATE,
    SISO INT,
    MAKHOA CHAR(5) REFERENCES KHOA(MAKHOA)
)
INSERT INTO LOP VALUES ('CDT01',N'CAO ĐẲNG TIN HOC 01','2021-2022',N'CHÍNH QUY','2021',60,'KCNTT')
INSERT INTO LOP VALUES ('CDT02',N'CAO ĐẲNG TIN HOC 02','2021-2022',N'CHÍNH QUY','2021',80,'KCNTT')
INSERT INTO LOP VALUES ('DHQ01',N'ĐẠI HỌC QUẢN TRỊ KINH DOANH 01','2022-2023',N'CHÍNH QUY','2021',60,'KQTKD')


CREATE TABLE SINHVIEN
(
    MASV CHAR(5) PRIMARY KEY,
    HODEM NVARCHAR(60),
    TEN NVARCHAR(60),
    NGAYSINH DATE,
    GIOITINH CHAR(5),
    NOISINH NVARCHAR(60),
    MALOP CHAR(5) REFERENCES LOP(MALOP)
)

INSERT INTO SINHVIEN VALUES ('SV001',N'NGUYỄN VĂN',N'THUẬN','2003/04/20',N'NAM',N'CẦN THƠ','CDT01')
INSERT INTO SINHVIEN VALUES ('SV002',N'TRẦN VĂN',N'NAM','2002/04/25',N'NAM',N'TP. HCM','CDT01')
INSERT INTO SINHVIEN VALUES ('SV003',N'NGUYỄN VĂN',N'LỘC','2002/09/20',N'NAM',N'BÌNH THUẬN','CDT01')
INSERT INTO SINHVIEN VALUES ('SV004',N'ĐINH MỘNG',N'TUYỀN','2003/09/20',N'NỮ',N'NINH THUẬN','CDT02')
INSERT INTO SINHVIEN VALUES ('SV005',N'HUỲNH THÚY',N'TUYỀN','2001/11/30',N'NỮ',N'QUẢNG NGÃI','DHQ01')

INSERT INTO SINHVIEN VALUES ('SV006',N'HUỲNH BẢO',N'TUYỀN','2001/11/30',N'NAM',N'QUẢNG NGÃI','DHQ01')

INSERT INTO SINHVIEN VALUES ('SV007',N'HUỲNH BẢO',N'TUYỀN','2001/11/30',N'NAM',N'QUẢNG NGÃI','DHQ01')

CREATE TABLE MONHOC
(
MAMONHOC CHAR(5) PRIMARY KEY,
TENMONHOC NVARCHAR(60),
SODVHT INT
)

INSERT INTO MONHOC VALUES ('CTRR',N'CẤU TRÚC RỜI RẠC',3)
INSERT INTO MONHOC VALUES ('HCSDL',N'HỆ QUẢN TRỊ CƠ SỞ DỮ LIỆU',3)
INSERT INTO MONHOC VALUES ('TKWE',N'THIẾT KẾ WEB',2)


CREATE TABLE DIEMTHI
(
MAMONHOC CHAR(5) REFERENCES MONHOC(MAMONHOC),
MASV CHAR(5) REFERENCES SINHVIEN(MASV),
DIEMLAN1 DECIMAL(3,1),
DIEMLAN2 DECIMAL(3,1),
PRIMARY KEY(MAMONHOC,MASV)
)

INSERT INTO DIEMTHI VALUES ('CTRR','SV001',7.5,1.5)
INSERT INTO DIEMTHI VALUES ('HCSDL','SV001',7.5,4.5)
INSERT INTO DIEMTHI VALUES ('TKWE','SV001',5.5,0.0)

INSERT INTO DIEMTHI VALUES ('CTRR','SV002',8.5,2.5)
INSERT INTO DIEMTHI VALUES ('HCSDL','SV002',7.5,5.5)
INSERT INTO DIEMTHI VALUES ('TKWE','SV002',9.5,0.0)



INSERT INTO DIEMTHI VALUES ('CTRR','SV006',8.5,2.5)
INSERT INTO DIEMTHI VALUES ('HCSDL','SV006',7.5,5.5)
INSERT INTO DIEMTHI VALUES ('TKWE','SV006',9.5,0.0)


INSERT INTO DIEMTHI VALUES ('CTRR','SV003',1.5,7.5)
INSERT INTO DIEMTHI VALUES ('HCSDL','SV003',1.5,5.5)
INSERT INTO DIEMTHI VALUES ('TKWE','SV003',8.5,0.0)

INSERT INTO DIEMTHI VALUES ('CTRR','SV004',2.5,7.5)
INSERT INTO DIEMTHI VALUES ('HCSDL','SV004',1.5,6.5)
INSERT INTO DIEMTHI VALUES ('TKWE','SV004',8.5,0.0)

INSERT INTO DIEMTHI VALUES ('CTRR','SV005',5.5,0)
INSERT INTO DIEMTHI VALUES ('HCSDL','SV005',5.5,0)
INSERT INTO DIEMTHI VALUES ('TKWE','SV005',8.5,0.0)


---CÂU 1. VIẾT HÀM KIỂM TRA ĐIỂM TRUNG BÌNH CỦA MỘT SINH VIÊN ----

CREATE FUNCTION DIEM_TB1 (@MASINHVIEN CHAR(5))
RETURNS NUMERIC(5,1)
AS
	BEGIN
		DECLARE @DTB NUMERIC(5,1)
		SET @DTB = (SELECT AVG((DIEMLAN1+ DIEMLAN2)/2)
					FROM DIEMTHI
					WHERE MASV=@MASINHVIEN)
		RETURN @DTB
	END
GO

SELECT DBO.DIEM_TB1('SV001') AS DTB


--- CÂU 2. MÃ SV CÓ ĐIỂM TRUNG BÌNH CAO NHÁT ---

GO
CREATE FUNCTION DUNC_TIMSV2()
RETURNS @SV TABLE (MASV CHAR(5))
AS
BEGIN
   INSERT INTO @SV
   SELECT MASV
                 FROM DIEMTHI
				 GROUP BY MASV
				 HAVING AVG((DIEMLAN1+ DIEMLAN2)/2) >= ALL( SELECT  AVG((DIEMLAN1+ DIEMLAN2)/2)
				                                        FROM DIEMTHI
				                                        GROUP BY MASV
													 )
													 
  RETURN
END


--- 

GO
SELECT *
FROM DBO.DUNC_TIMSV2()



---CÂU 3. Viết hàm xuất danh sách các sinh viên có điểm trung bình bé hơn 5 (Thông tin gồm MaSV, HoTen)

CREATE FUNCTION SV_DTB_NHO51()

RETURNS TABLE
AS
   RETURN ( SELECT SV.MASV , (SV.HODEM + ' ' + SV.TEN) AS HOTEN
             FROM SINHVIEN SV , DIEMTHI DT
			 WHERE SV.MASV = DT.MASV
			 GROUP BY SV.MASV , (SV.HODEM + ' ' + SV.TEN) 
			 HAVING AVG((DIEMLAN1+ DIEMLAN2)/2) < 5

			)
GO

SELECT * FROM DBO.SV_DTB_NHO51()



-------- BÀI TIẾP THEO ------------

--- CÂU 1. Viết hàm truyền vào mã sinh viên , trả về tên lớp của sinh viên đó --

GO
CREATE FUNCTION TENLOP_SV1(@MA CHAR(5))
RETURNS NVARCHAR(20)
AS
BEGIN
   DECLARE @TENLOP NVARCHAR(20)
    SET @TENLOP = (
           SELECT L.TENLOP
		   FROM  SINHVIEN SV
		   JOIN LOP L ON L.MALOP = SV.MALOP 
		   WHERE  SV.MASV = @MA
		   )

RETURN @TENLOP
END


GO
SELECT DBO.TENLOP_SV1('SV001') AS TENLOP


--Câu 2: Viết hàm truyền vào tham số mã sinh viên và mã môn học trả về điểm của sinh viên học môn đó


GO
CREATE FUNCTION DIEM_MONHOC(@MASV CHAR(5), @MAMH CHAR(5))
RETURNS TABLE
AS
   RETURN ( SELECT SV.MASV ,  DT.MAMONHOC , (SV.HODEM + ' ' + SV.TEN) AS HOTEN  , DIEMLAN1, DIEMLAN2
			FROM  SINHVIEN SV
			JOIN DIEMTHI DT ON DT.MASV = SV.MASV 
			 WHERE DT.MAMONHOC = @MAMH AND  DT.MASV = @MASV
		    )
GO



SELECT * FROM DBO.DIEM_MONHOC('SV001','CTRR')



--Câu 3: Viết hàm truyền vào mã sinh viên trả về tổng số đơn vị học trình của sinh viên đó. Biết rằng chỉ tích lũy đối với môn học có điểm lần 1>=5 - --

GO
CREATE FUNCTION SUMTC_SV1(@MASV CHAR(5))
RETURNS INT
AS
BEGIN
   DECLARE @SUMTC INT
    SET @SUMTC= (
           SELECT SUM(MH.SODVHT)
		   FROM  MONHOC MH
		   JOIN DIEMTHI DT ON DT.MAMONHOC = MH.MAMONHOC 
		   WHERE  DT.DIEMLAN1 >= 5 AND DT.MASV = @MASV
		   )

RETURN @SUMTC
END

GO
SELECT DBO.SUMTC_SV1('SV001') AS TONGTC


--Câu 4: Viết hàm truyền vào tham số mã môn học, trả về bảng chứ thông tin những sinh viên học môn đó gồm (Mã sinh viên, họ tên, điểm lần 2, tên lớp)----


GO
CREATE FUNCTION TTSV_MH( @MAMH CHAR(5))
RETURNS  TABLE
AS
   RETURN ( SELECT SV.MASV , (SV.HODEM + ' ' + SV.TEN) AS HOTEN  , DIEMLAN2 , L.TENLOP
			FROM  SINHVIEN SV
			JOIN LOP L ON L.MALOP = SV.MALOP
			JOIN DIEMTHI DT ON DT.MASV = SV.MASV 
			
			 WHERE DT.MAMONHOC = @MAMH 
		    )
GO

SELECT *
FROM DBO.TTSV_MH('CTRR')


-- CÁCH  2 ----
GO
CREATE FUNCTION TTSV2_MH(@MAMH CHAR(5))
RETURNS  @TTSV TABLE (MASV CHAR(5) , HODEM NVARCHAR(10), TEN NVARCHAR(10) , DIEMLAN2 INT , TENLOP NVARCHAR(20) )
AS
BEGIN
   INSERT INTO @TTSV
				    SELECT 
					  SV.MASV,   SV.HODEM, SV.TEN, DT.DIEMLAN2, L.TENLOP
                    FROM  SINHVIEN SV
					JOIN LOP L ON L.MALOP = SV.MALOP
					JOIN DIEMTHI DT ON DT.MASV = SV.MASV 
					WHERE DT.MAMONHOC = @MAMH 
				 
  RETURN 
END 

GO
SELECT *
FROM TTSV2_MH('CTRR')

--Câu 5: Viết hàm truyền vào mã lớp, trả về danh sách những sinh viên học lớp đó bao gồm: mã sinh viên, họ tên, điểm trung bình -----
GO
CREATE FUNCTION  DSSV_THEOLOP(@MALOP CHAR(5))
RETURNS TABLE 
AS
RETURN ( SELECT SV.MASV , (SV.HODEM + ' ' + SV.TEN) AS HOTEN ,  ROUND(AVG((DIEMLAN1 + DIEMLAN2) / 2), 2) AS DTB 
			FROM  SINHVIEN SV
			JOIN LOP L ON L.MALOP = SV.MALOP
			JOIN DIEMTHI DT ON DT.MASV = SV.MASV 
			 WHERE L.MALOP = @MALOP
			 GROUP BY SV.MASV, SV.HODEM,  SV.TEN
		    )

GO

SELECT *
FROM  DSSV_THEOLOP('CDT01')

--Câu 6: Viết hàm truyền vào tham số mã sinh viên và niên khóa/học kỳ, trả về tổng số tín chỉ đã đạt của sinh viên đó, biết rằng sinh viên đạt một môn nếu điểm thi>=5---

SELECT *
FROM LOP

GO
CREATE FUNCTION  TONGTC_DAT_NK(@MASV CHAR(5), @NIENKHOA CHAR(10) )
RETURNS INT
AS
BEGIN
 DECLARE @SUMTC INT
    SET @SUMTC= (
           SELECT SUM(MH.SODVHT)
		   FROM  MONHOC MH
		   JOIN DIEMTHI DT ON DT.MAMONHOC = MH.MAMONHOC 
		   JOIN SINHVIEN SV ON SV.MASV = DT.MASV
		   JOIN LOP L ON  L.MALOP = SV.MALOP
		   WHERE  DT.DIEMLAN1 >= 5 AND DT.DIEMLAN2 >= 5 AND DT.MASV = @MASV AND @NIENKHOA = L.NIENKHOA
		   )

RETURN @SUMTC 
END
GO

DECLARE @TONGTC INT
SET @TONGTC = dbo.TONGTC_DAT_NK('SV002', '2021-2022')
PRINT @TONGTC


SELECT *
FROM LOP

SELECT *
FROM SINHVIEN
SELECT *
FROM DIEMTHI
--Câu 7: Viết hàm truyền vào tham số mã lớp, trả về bảng chứa danh sách những sinh viên (mã sv, họ tên, ngày sinh) học lớp đó

GO
CREATE FUNCTION DSSV_HOCLOP(@MALOP CHAR(10))
RETURNS @DSSV_HOCLOP TABLE ( MASV CHAR(5), HODEM NVARCHAR(10), TEN NVARCHAR(10), NGAYSINH DATETIME)
AS
BEGIN
  INSERT INTO @DSSV_HOCLOP
             SELECT SV.MASV , SV.HODEM , SV.TEN , SV.NGAYSINH 
			 FROM SINHVIEN SV
			 JOIN LOP L ON SV.MALOP = L.MALOP
			 WHERE  L.MALOP = @MALOP
 RETURN
END

GO
SELECT *
FROM DSSV_HOCLOP('CDT01')



--Câu 8: Viết hàm truyền vào tham số mã môn học và niên khóa/ học kỳ, trả về bàng chứa danh sách những sinh viên (mã sv, họ tên, ngày sinh, tên lớp) có điểm lần 1 <5

GO
CREATE FUNCTION DSSV(@MAMH CHAR(10))
RETURNS @DSSV TABLE ( MASV CHAR(5), HODEM NVARCHAR(10), TEN NVARCHAR(10), NGAYSINH DATETIME , TENLOP NVARCHAR(20), DIEMTHI1 DECIMAL(3,2) )
AS
BEGIN
  INSERT INTO @DSSV
             SELECT SV.MASV , SV.HODEM , SV.TEN , SV.NGAYSINH , L.TENLOP , DIEMLAN1
			 FROM SINHVIEN SV
			 JOIN DIEMTHI D ON SV.MASV = D.MASV
			 JOIN LOP L ON SV.MALOP = L.MALOP
			 WHERE DIEMLAN1 < 5 AND D.MAMONHOC = @MAMH
 RETURN
END

GO
SELECT *
FROM DSSV('CTRR')

--Câu 9: Viết hàm truyền vào tham số mã môn học, trả về bảng chứa danh sách những sinh viên (mã sv, họ tên, ngày sinh) chưa học môn đó-----


GO
CREATE FUNCTION DSSV_NO_MON(@MAMH CHAR(10))
RETURNS @DSSV_NO_MON TABLE ( MASV CHAR(5), HODEM NVARCHAR(10), TEN NVARCHAR(10), NGAYSINH DATETIME  )
AS
BEGIN
  INSERT INTO @DSSV_NO_MON
             SELECT SV.MASV , SV.HODEM , SV.TEN , SV.NGAYSINH 
			 FROM SINHVIEN SV
			 WHERE SV.MASV NOT IN ( SELECT D.MASV
			                        FROM DIEMTHI D
									WHERE MAMONHOC = @MAMH
									)
 RETURN
END

GO

SELECT *
FROM SINHVIEN

SELECT *
FROM DIEMTHI

SELECT *
FROM DSSV_NO_MON('CTRR')

--Câu 10: Viết hàm truyền vào tham số mã sinh viên, trả về bảng chứa danh sách những môn học (mã môn học, tên môn học, điểm cao nhất) mà sinh viên học---
--Biết rằng trường hợp sinh viên học một môn học nhiều lần thì chỉ hiển thị số điểm cao nhất và sắp theo ASC-----

----
GO
CREATE FUNCTION DSMH(@MASV CHAR(10))
RETURNS @DSMH TABLE (MAMH CHAR(5), TENMH NVARCHAR(50), DIEMTHI DECIMAL(3,2))
AS
BEGIN

 
    INSERT INTO @DSMH (MAMH, TENMH, DIEMTHI)
    SELECT 
        MH.MAMONHOC, 
        MH.TENMONHOC, 
        (SELECT 
            MAX(
			CASE 
				WHEN DIEMTHI.DIEMLAN1 > DIEMTHI.DIEMLAN2 THEN DIEMTHI.DIEMLAN1
					ELSE DIEMTHI.DIEMLAN2 
			END )
			  FROM DIEMTHI 
			  WHERE  DIEMTHI.MASV = @MASV AND MH.MAMONHOC = DIEMTHI.MAMONHOC
														
        ) AS DIEMTHI
    FROM 
        MONHOC MH
    JOIN 
        DIEMTHI D ON D.MAMONHOC = MH.MAMONHOC
    WHERE 
        D.MASV = @MASV
    GROUP BY 
        MH.MAMONHOC, MH.TENMONHOC
    ORDER BY 
        DIEMTHI ASC

    RETURN
END

GO
SELECT *
FROM DSMH('SV002')

SELECT*
FROM DIEMTHI