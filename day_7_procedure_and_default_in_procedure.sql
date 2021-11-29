--tao database va bang
create database sinh_vien
use sinh_vien
 drop database sinh_vien
drop table sinh_vien
create table sinh_vien (
ma int identity,
ten nvarchar(50),
gioi_tinh bit,
ma_lop int,
foreign key (ma_lop) references lop(ma_lop),
primary key (ma)
)

drop table lop
 
create table lop(
ma_lop int identity,
ten_lop nvarchar(50),
primary key (ma_lop)
)

--insert vao bang
insert into lop
values ('lt'), ('KHMT'), ('KTPM')

insert into sinh_vien (ten, gioi_tinh, ma_lop)
values ('Loc', 1, 1), ('Kim', 0, 2), ('Hung', 1, 1)

--cau truc proc
drop procedure them_va_hien_thi_sinh_vien 
create procedure them_va_hien_thi_sinh_vien 
as
begin
	insert into sinh_vien
	values ('An', 0, 3)
	select * from sinh_vien
end

execute them_va_hien_thi_sinh_vien

--proc co tham so
drop procedure them_va_hien_thi_sinh_vien_tuy_y
create procedure them_va_hien_thi_sinh_vien_tuy_y
@ten nvarchar(50),
@gioi_tinh bit,
@ma_lop int
as
begin
	insert into sinh_vien
	values (@ten, @gioi_tinh, @ma_lop)
	select top 3* from sinh_vien
	order by ma desc
end

them_va_hien_thi_sinh_vien_tuy_y @ten = 'Teo', @gioi_tinh = 0, @ma_lop = 2


create procedure cap_nhat_sinh_vien
@ma int,
@ten nvarchar(50)
as
begin
	select * from sinh_vien
	where ma = @ma
	update sinh_vien
	set ten = @ten
	where ma = @ma
	select * from sinh_vien
	where ma = @ma
end
cap_nhat_sinh_vien @ten = 'Kim wibu', @ma = 2

--procedure trong procedure
create proc lay_ra_sinh_vien
@ma int
as
begin
	select * from sinh_vien
	where ma = @ma
end

create procedure cap_nhat_sinh_vien_proc_in_proc
@ma int,
@ten nvarchar(50)
as
begin
	execute lay_ra_sinh_vien @ma = @ma
	update sinh_vien
	set ten = @ten
	where ma = @ma
	execute lay_ra_sinh_vien @ma = @ma
end

cap_nhat_sinh_vien_proc_in_proc @ma = 1 , @ten =  'Loc hacker'

--default trong proc
drop proc lay_ra_sinh_vien_default
create proc lay_ra_sinh_vien_default
@ma int = -1
as
begin
	select * from sinh_vien
	where ma = @ma or @ma = -1 
end

lay_ra_sinh_vien_default


drop procedure them_va_hien_thi_sinh_vien_tuy_y_default
create procedure them_va_hien_thi_sinh_vien_tuy_y_default
@ten nvarchar(50),
@gioi_tinh bit = 1,
@ma_lop int = 1
as
begin
	insert into sinh_vien
	values (@ten, @gioi_tinh, @ma_lop)
	select top 3* from sinh_vien
	order by ma desc
end

them_va_hien_thi_sinh_vien_tuy_y_default @ten = 'Long' , @gioi_tinh = 0, @ma_lop = 2

--default lv2
drop proc cap_nhat_sinh_vien_proc_in_proc_default_lv2
create procedure cap_nhat_sinh_vien_proc_in_proc_default_lv2
@ma int,
@ten nvarchar(50),
@gioi_tinh bit = null, --why not "is null"
@ma_lop int = -2
as
begin
	execute lay_ra_sinh_vien @ma = @ma
	update sinh_vien
	set ten = @ten , gioi_tinh = case when @gioi_tinh is null then gioi_tinh else @gioi_tinh end,
	ma_lop = case when @ma_lop = -2 then ma_lop else @ma_lop end
	where ma = @ma
	execute lay_ra_sinh_vien @ma = @ma
end
lay_ra_sinh_vien_default
cap_nhat_sinh_vien_proc_in_proc_default_lv2 @ten = 'Ngai Loc', @ma = 1
