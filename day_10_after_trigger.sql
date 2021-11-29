create database sinh_vien
use sinh_vien

drop table lop 
create table lop(
ma_lop int identity,
ten_lop nvarchar(50),
so_luong_sinh_vien int default 0,
primary key (ma_lop)
)

drop table sinh_vien
create table sinh_vien(
ma_sinh_vien int identity,
ten_sinh_vien nvarchar(50),
ma_lop int,
primary key (ma_sinh_vien),
foreign key (ma_lop) references lop(ma_lop)
)

insert into lop(ten_lop)
values ('PPLT'), ('LTHDT'), ('SQL')

insert into sinh_vien
values ('Trung', 1), ('Oanh', 2), ('Kim', 1)

--them sinh vien thi so sinh vien cua bang lop tu dong tang
drop trigger trigger_them_sinh_vien
create trigger trigger_them_sinh_vien
on sinh_vien
after insert
as
begin
	declare @ma_lop int = (select ma_lop from inserted)
	update lop
	set 
	so_luong_sinh_vien = so_luong_sinh_vien + 1
	where ma_lop = @ma_lop
	select * from lop
end

--sinh vien bi duoi khoi lop
drop trigger trigger_sinh_vien_pay_khoi_lop
create trigger trigger_sinh_vien_pay_khoi_lop
on sinh_vien
after delete
as
begin
	declare @ma_lop int = (select ma_lop from deleted)
	update lop
	set
	so_luong_sinh_vien = so_luong_sinh_vien - 1
	where ma_lop = @ma_lop
	select * from sinh_vien
	select * from lop
end

--sinh vien chuyen lop
create trigger trigger_sinh_vien_chuyen_lop
on sinh_vien
after update
as
begin
	declare @ma_lop_cu int = (select ma_lop from deleted)
	declare @ma_lop_moi int = (select ma_lop from inserted)
	update lop
	set 
	so_luong_sinh_vien = so_luong_sinh_vien - 1
	where ma_lop = @ma_lop_cu

	update lop
	set so_luong_sinh_vien += 1
	where ma_lop = @ma_lop_moi

	select * from sinh_vien
	select * from lop
end

update sinh_vien
set ten_sinh_vien = 'Cong'
where ma_sinh_vien = 4

--insert nhieu sinh vien 1 luc
drop trigger trigger_them_nhieu_sinh_vien
create trigger trigger_them_nhieu_sinh_vien
on sinh_vien
after insert
as
begin
	update lop
	set
	so_luong_sinh_vien = so_luong_sinh_vien + i.so_luong_sinh_vien_vua_them
	from lop
	join
	(select ma_lop, count(*) as 'so_luong_sinh_vien_vua_them' from inserted group by ma_lop) as i
	on lop.ma_lop = i.ma_lop 
	select * from lop
	select * from sinh_vien
end



select * from sinh_vien
insert into sinh_vien(ten_sinh_vien, ma_lop)
values ('Anh', 1), ('Kan', 2), ('kin', 1)

--delete nhieu sinh vien , cap nhat cot so luong sinh vien o bang lop
drop trigger trigger_xoa_nhieu_sinh_vien_cap_nhat_bang_lop
create trigger trigger_xoa_nhieu_sinh_vien_cap_nhat_bang_lop
on sinh_vien
after delete
as
begin
	update lop
	set so_luong_sinh_vien = so_luong_sinh_vien - i.so_luong_sinh_vien_cua_lop

	from lop join
	(select ma_lop, count(*) as 'so_luong_sinh_vien_cua_lop' from deleted group by ma_lop) as i
	on lop.ma_lop = i.ma_lop
	
	select * from sinh_vien
	select * from lop
end

delete from sinh_vien
where ma_sinh_vien in (8,9)


