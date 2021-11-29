create database quan_ly_khach_hang
use quan_ly_khach_hang

drop table khach_hang
create table khach_hang( 
ma int identity,
ho_ten nvarchar(50) not null,
so_dien_thoai char(15),
dia_chi nvarchar(100),
gioi_tinh bit,
ngay_sinh date,
primary key (ma)
)

insert into khach_hang
values (N'Long','0922266789',N'331 Ba Da',0,'2000-1-10')

--1/Hien thi ho ten va so dien thoai
select ho_ten, so_dien_thoai from khach_hang

--2/ Cap nhat nguoi co ma 2 sang ten Tuan
update khach_hang
set
ho_ten = N'Tuấn'
where ma=2

--3/ Xóa khách hàng có mã lớn hơn 3 và giới tính là nam
delete from khach_hang
where ma>3 and gioi_tinh = 1

--4/ Lấy ra  khách hàng sinh tháng 1
SELECT * FROM khach_hang
   WHERE MONTH(ngay_sinh) = 1 

--5/ Lấy ra khách hàng có họ tên trong danh sách (Anh,Minh,Đức) và giới tính Nam hoặc chỉ cần năm sinh trước 2000
select * from khach_hang
where ho_ten in ('Anh','Minh',N'Đức') and gioi_tinh=1 or Year(ngay_sinh)<2000

--6/ (**) Lấy ra khách hàng có tuổi lớn hơn 18

select * from khach_hang
where year(GETDATE()) - YEAR(ngay_sinh) > 18


--7/ (**) Lấy ra 3 khách hàng mới nhất

select top 3 * from khach_hang
order by ma desc

--8/ (**) Lấy ra khách hàng có tên chứa chữ T

select * from khach_hang
where ho_ten like '%z%'

alter table khach_hang
add constraint CK_dieu_kien_cua_Long check ((ho_ten= 'Long' and gioi_tinh = 1) or ho_ten != 'Long')

alter table khach_hang
drop constraint CK_dieu_kien_cua_Long

insert into khach_hang(ho_ten,so_dien_thoai,dia_chi,ngay_sinh)
values ('a' , '01541','LeLoi', '2020-10-10')

ALTER TABLE khach_hang
ADD CONSTRAINT macDinhGioiTinh
DEFAULT 1 FOR gioi_tinh
