

drop database sinh_vien
create database sinh_vien
use sinh_vien

drop table lop
create table lop(
ma_lop int identity,
ten_lop nvarchar(50),
primary key (ma_lop)
)

create table sinh_vien(
ma_sinh_vien int identity,
ten_sinh_vien nvarchar(50),
gioi_tinh bit,
ngay_sinh date,
ma_lop int
primary key (ma_sinh_vien),
foreign key (ma_lop) references lop(ma_lop)
)

insert into lop
values ('KHMT'), ('ATTT'), ('MMT'), ('Hack')

insert into sinh_vien
values ('Loc', 1, '2003-05-10', 1), ('Long', 0, '2002-05-05', 2), ('Ken', 1, '1999-05-05', 3), ('Quynh', 1, '2005-05-05', 1)


--Tạo function thao tác với bảng lớp (mã, tên) và sinh viên (mã, tên, giới tính, ngày sinh, mã lớp):
--hiển thị tên giới tính

drop function hien_thi_gioi_tinh
create function hien_thi_gioi_tinh(@gioi_tinh bit)
returns nvarchar(50)
as
begin
	return case when @gioi_tinh = 1 then 'Nam' else N'Nữ' end 
end

select ma_sinh_vien, ten_sinh_vien, dbo.hien_thi_gioi_tinh(gioi_tinh) as 'Giới tính', ngay_sinh from sinh_vien

--hàm hiển thị tuổi

create function hien_thi_tuoi(@ngay_sinh date)
returns nvarchar(5)
as
begin
	return datediff(year, @ngay_sinh, getdate())
end

select ma_sinh_vien, ten_sinh_vien, gioi_tinh, dbo.hien_thi_tuoi(ngay_sinh) as 'Tuoi' from sinh_vien


--join 2 bảng và hiển thị lại toàn bộ thông tin theo mã sinh viên truyền vào
drop function ham_hien_thi_thong_tin_sinh_vien_va_lopp 
create function ham_hien_thi_thong_tin_sinh_vien_va_lopp (@ma_sinh_vien int)
returns table
as
return 
select sinh_vien.ma_sinh_vien, sinh_vien.ten_sinh_vien, sinh_vien.gioi_tinh, sinh_vien.ngay_sinh, lop.ten_lop from sinh_vien join lop on sinh_vien.ma_lop = lop.ma_lop where ma_sinh_vien = @ma_sinh_vien

select * from ham_hien_thi_thong_tin_sinh_vien_va_lopp(2)



