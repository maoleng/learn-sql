--Ham tao ra boi nguoi dung
create function cong(@a int, @b int)
returns int
as
begin
	return @a + @b
end

select dbo.cong(5,6) as 'pheptinhcong'
----------------------------
 
drop database sinh_vien
create database sinh_vien
use sinh_vien

drop table sinh_vien
create table sinh_vien(
ma int identity,
ten nvarchar(5),
gioi_tinh bit,
ngay_sinh date,
primary key (ma)
)

insert into sinh_vien
values ('Long', 1, '2002-05-05'), ('Ken', 0, '2003-03-07'), ('Nam', 1, '1997-05-08')

--Ham doi cach hien thi gioi tinh
create function ten_gioi_tinh(@gioi_tinh bit)
returns nvarchar(50)
as
begin
	return case when
	@gioi_tinh = 1 then 'Nam'
	else N'Nữ'
	end
end
select ma, ten,
dbo.ten_gioi_tinh(gioi_tinh) as gioi_tinh from sinh_vien

--Ham doi cach hien thi ngay sinh thanh tuoi
create function func_lay_ra_tuoi(@ngay_sinh date)
returns int
as
begin
	return
	year(GETDATE()) - year(@ngay_sinh)
end

--ham tra ve 1 bang
select ma,ten,gioi_tinh, dbo.func_lay_ra_tuoi(ngay_sinh) from sinh_vien

create function func_xem_sinh_vien(@ma int)
returns table
return select * from sinh_vien where ma = @ma

select * from dbo.func_xem_sinh_vien(1)
