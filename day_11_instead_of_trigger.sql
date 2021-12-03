drop database sinh_vien
create database sinh_vien
use sinh_vien

drop table lop
create table lop(
ma_lop int,
ten_lop nvarchar(50),
so_cho_trong int,
primary key (ma_lop)
)

drop table sinh_vien
create table sinh_vien(
ma_sinh_vien int ,
ten_sinh_vien nvarchar(50),
ma_lop int,
primary key (ma_sinh_vien),
foreign key (ma_lop) references lop(ma_lop)
)

insert into lop(ma_lop, ten_lop, so_cho_trong)
values (1, 'KHMT', 5), (2, 'KTPM', 5), (3, 'MMT', 5)


--trigger instead of them sinh vien
drop trigger trigger_them_sinh_vien
create trigger trigger_them_sinh_vien
on sinh_vien
instead of insert
as
begin
	declare @ma_lop int = (select ma_lop from inserted)	
	declare @so_cho_trong int = (select so_cho_trong from lop where ma_lop = @ma_lop)
	if (@so_cho_trong = 0)
		begin
			print(N'Hết chỗ')
		end
	else
		begin
			update lop set
			so_cho_trong -= 1
			where ma_lop = @ma_lop
			declare @ma_sinh_vien int = (select ma_sinh_vien from inserted)
			declare @ten_sinh_vien nvarchar(50) = (select ten_sinh_vien from inserted)
			insert into sinh_vien(ma_sinh_vien, ten_sinh_vien, ma_lop)
			values(@ma_sinh_vien, @ten_sinh_vien, @ma_lop)
			print(N'Đã thêm sinh viên')
		end


end

insert into sinh_vien
values (2, 'Khoa', 1)


--trigger instead of chuyen lop cho sinh vien
drop trigger trigger_chuyen_sinh_vien
create trigger trigger_chuyen_sinh_vien
on sinh_vien
instead of update
as 
begin
	--lay ra ma lop ban sinh vien vua insert/delete, kiem tra so cho trong la bao nhieu
	--neu so cho trong = 0 thi out chuong trinh, khac 0 thi tiep tuc
	--tru 1 di so cho trong where malop = @malopcu 
	--+ 1 so cho trong where malop = @malopmoi
	declare @ma_lop_cu int = (select ma_lop from deleted)
	declare @ma_lop_moi int = (select ma_lop from inserted)
	declare @so_cho_trong_lop_cu int = (select so_cho_trong from lop where ma_lop = @ma_lop_cu)
	declare @so_cho_trong_lop_moi int = (select so_cho_trong from lop where ma_lop = @ma_lop_moi)
	
	if (@so_cho_trong_lop_moi = 0)
		begin
			print(N'Đã hết chỗ')
		end
	else
		begin
			update lop set
			so_cho_trong = so_cho_trong + 1
			where ma_lop = @ma_lop_cu
			
			update lop set
			so_cho_trong -= 1
			where ma_lop = @ma_lop_moi


			--ko nen lam nhu vay, vi nhu vay chi cap nhat duoc moi viec chuyen lop
			--declare @ma_sinh_vien int = (select ma_sinh_vien from inserted where ma_lop = @ma_lop_moi)
			--update sinh_vien set
			--ma_lop = @ma_lop_moi
			--where ma_sinh_vien = @ma_sinh_vien

			--nen lam nhu vay
			delete sinh_vien where ma_lop = @ma_lop_cu
			
			--declare @ma_sinh_vien int = (select ma_sinh_vien from inserted where ma_lop = @ma_lop_moi)
			--declare @ten_sinh_vien nvarchar(50) = (select ten_sinh_vien from inserted where ma_lop = @ma_lop_moi)
			--insert into sinh_vien(ma_sinh_vien, ten_sinh_vien, ma_lop)
			--values (@ma_sinh_vien, @ten_sinh_vien, @ma_lop_moi)
			insert into sinh_vien
			select * from inserted
		end
		
		select * from sinh_vien
		select * from lop
end

update sinh_vien
set ma_lop = 1 where ma_sinh_vien = 2

--trigger them 1 luc nhieu sinh vien
drop trigger trigger_them_nhieu_sinh_vien
create or alter trigger trigger_them_nhieu_sinh_vien
on sinh_vien
instead of insert
as
begin
	--dem so luong sinh vien them vao chia ra theo tung lop & dem so cho trong theo tung lop
	--kiem tra so luong sinh vien them vao co be hon so cho trong khong ? tra ve nhung malop hop le
	--insert nhung ban hop le vao 
	--cap nhat bang lop 
	insert into sinh_vien
	select * from inserted
	where ma_lop in (
		select lop.ma_lop from lop
		join
		(select ma_lop, count(*) as 'So_luong_sinh_vien_se_them_vao' from inserted group by ma_lop)  as i
		on lop.ma_lop  = i.ma_lop
		where (So_luong_sinh_vien_se_them_vao <= so_cho_trong)
	)
	update lop
	set so_cho_trong -= i.So_luong_sinh_vien_se_them_vao
	from 
		lop
		join
		(select ma_lop, count(*) as 'So_luong_sinh_vien_se_them_vao' from inserted group by ma_lop)  as i
		on lop.ma_lop  = i.ma_lop
		where (So_luong_sinh_vien_se_them_vao <= so_cho_trong)
	
end

insert into sinh_vien
values (5, 'Long', 3), (6, 'Ken', 2), (7, 'Ken', 2), (8, 'Ken', 1)



create or alter trigger trigger_cap_nhat_1_luc_nhieu_sinh_vien
on sinh_vien
instead of update
as
begin
	--đếm số bạn chuyển, so sánh với số chỗ trống -> lấy ra những bạn có thể chuyển	
	--cột mã không tự động tăng mới làm được
	--select lọc ra 1 số thông tin , insert vào bảng sinh viên những thông tin đó
	delete sinh_vien from sinh_vien
	join deleted on deleted.ma_sinh_vien = sinh_vien.ma_sinh_vien
	join inserted on inserted.ma_sinh_vien = inserted.ma_sinh_vien
	where inserted.ma_lop in(
		select lop.ma_lop from lop join
			(select ma_lop, count(*) as 'so_ban_duoc_chuyen' from inserted group by ma_lop) as i
			on lop.ma_lop = i.ma_lop
			where i.so_ban_duoc_chuyen <= lop.so_cho_trong
	)
	
	insert into sinh_vien
	select * from inserted
	where ma_lop in(
		select lop.ma_lop from lop join
		(select ma_lop, count(*) as 'so_ban_duoc_chuyen' from inserted group by ma_lop) as i
		on lop.ma_lop = i.ma_lop
		where i.so_ban_duoc_chuyen <= lop.so_cho_trong
	)


	select * from sinh_vien
	select * from lop

end



delete from sinh_vien

update sinh_vien set
ma_lop = 3
where ma_sinh_vien in (2,3)

select * from sinh_vien
select * from lop
