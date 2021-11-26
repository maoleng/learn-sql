--Tạo procedure thao tác với bảng lớp (mã, tên) và sinh viên (mã, tên, giới tính, mã lớp):
create database sinh_vien
use sinh_vien

drop table lop
create table lop(
ma int identity,
ten_lop nvarchar(50),
primary key (ma)
)

drop table sinh_vien
create table sinh_vien(
ma int identity,
ten_sinh_vien nvarchar(50),
gioi_tinh bit,
ma_lop int,
primary key (ma),
foreign key (ma_lop) references lop(ma)
)

insert into lop
values ('KHMT'), ('PPLT'), ('MMT'), ('TTNT')

insert into sinh_vien(ten_sinh_vien, gioi_tinh, ma_lop)
values ('Long', 1, 1), ('Loc', 1, 2), ('Kiet', 0, 1), ('Luan', 1, 3)


--xem_sinh_vien: hiển thị thông tin sinh viên kèm lớp. Có thể truyền vào mã lớp hoặc mã sinh viên để lọc
drop procedure xem_sinh_vien
create procedure xem_sinh_vien
@ma int = -1,
@ma_lop int = -1
as
begin
	select * from sinh_vien
	where ma = @ma or ma_lop = @ma_lop

end


xem_sinh_vien @ma = 2 @ma_lop = 2

--them_sinh_vien: thêm sinh viên rồi hiển thị lại thông tin sinh viên đó. Có thể không cần truyền giới tính 
create procedure them_sinh_vien
@ten nvarchar(50),
@gioi_tinh  bit = 1,
@ma_lop int
as
begin
	insert into sinh_vien
	values (@ten, @gioi_tinh, @ma_lop)

	select * from sinh_vien
	where ten_sinh_vien = @ten and gioi_tinh = @gioi_tinh and ma_lop = @ma_lop
end

them_sinh_vien @ten = 'Chou', @ma_lop = 4, @gioi_tinh = 0

--them_sinh_vien: thêm sinh viên rồi hiển thị lại thông tin sinh viên đó. Có thể không cần truyền giới tính (*: không cần truyền cả mã lớp, mã sẽ lấy mặc định lớp mới nhất)

drop proc them_sinh_vien_2
create procedure them_sinh_vien_2

@ten nvarchar(50),
@gioi_tinh  bit = 1,
@ma_lop int = -1
as
begin
	declare @ma_lop_moi_nhat  int
	set @ma_lop_moi_nhat = (
	select top 1 ma from lop
	order by ma desc
	)
	@ma_lop = case when @ma_lop = -1 then @ma_lop_moi_nhat else @ma_lop end
	insert into sinh_vien
	values (@ten, @gioi_tinh, @ma_lop )

	select * from sinh_vien
	where ten_sinh_vien = @ten and gioi_tinh = @gioi_tinh and ma_lop = @ma_lop
end

--sua_sinh_vien: sửa thông tin sinh viên và default nếu k nhập
drop proc  sua_sinh_vien
create proc sua_sinh_vien
@ma int,
@ten_sinh_vien nvarchar(50) = 'a',
@gioi_tinh bit = -1,
@ma_lop int = -1
as
begin
	select * from sinh_vien
	where ma = @ma

	update sinh_vien
	set ten_sinh_vien = case when @ten_sinh_vien = 'a' then ten_sinh_vien else @ten_sinh_vien end,
	gioi_tinh = case when @gioi_tinh = -1 then gioi_tinh else @gioi_tinh end,
	ma_lop = case when @ma_lop = -1 then ma_lop else @ma_lop end
	where ma = @ma

	select * from sinh_vien
	where ma = @ma
end

sua_sinh_vien @ma = 2, @ten_sinh_vien = 'Ngai Loc'
select * from sinh_vien

--xoa_sinh_vien (*: hiển thị số lượng sinh viên trước và sau khi xoá.
drop proc xoa_sinh_vien
create proc xoa_sinh_vien
@ma int
as
begin
	select count(*) as 'so_luong_sinh_vien_truoc_khi_xoa' from sinh_vien
	delete from sinh_vien
	where ma = @ma 
	select count(*) as 'so_luong_sinh_vien_sau_khi_xoa' from sinh_vien
end

xoa_sinh_vien @ma = 3

--**: hiển thị số lượng sinh viên trước và sau khi xoá của lớp mà lớp đó chứa sinh viên bị xoá.
drop proc xoa_sinh_vien_2
create proc xoa_sinh_vien_2
@ma int
as
begin
	declare @kiem_tra_ma_lop int
	set @kiem_tra_ma_lop = (
	select ma_lop from sinh_vien where ma = @ma
	)
		
	select count(*) as 'so sinh vien cua lop truoc khi xoa' from sinh_vien
	where ma_lop = @kiem_tra_ma_lop

	delete from sinh_vien
	where ma = @ma

	select count(*) 'so sinh vien cua lop sau khi xoa' from sinh_vien
	where ma_lop = @kiem_tra_ma_lop
end

xoa_sinh_vien_2 @ma =8

-- ***: hiển thị số lượng sinh viên trước và sau khi xoá của các lớp mà các lớp đó chứa các sinh viên bị xoá)


select * from sinh_vien
