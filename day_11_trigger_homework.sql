
(*: Kiểm tra sức chứa tương ứng với tổng số lượng sản phẩm, nếu còn dư mới được cập nhật vào kho đó)

drop database quan_ly_san_pham
create database quan_ly_san_pham
use quan_ly_san_pham


--Kho (mã, tên, tổng tài sản, sức chứa)
drop table kho
create table kho(
ma_kho int,
ten_kho nvarchar(50),
tong_tai_san int default 0,
suc_chua int default 50,
primary key (ma_kho)
)

insert into kho(ma_kho, ten_kho)
values (1, 'Keo'), (2, 'Bong bay')

--Sản phẩm (mã, tên, số lượng, giá trị, mã kho)
drop table san_pham
create table san_pham(
ma_san_pham int ,
ten_san_pham nvarchar (50),
so_luong int,
gia_tri int,
ma_kho int,
primary key(ma_san_pham),
foreign key (ma_kho) references kho(ma_kho)
)

--Tạo procedure để thêm và hiển thị lại giá trị vừa thêm ở từng bảng
create procedure them_va_hien_thi_gia_tri_vua_them_san_pham
@ten_san_pham nvarchar(50),
@so_luong int,
@gia_tri int,
@ma_kho int
as
begin
	insert into san_pham(ten_san_pham, so_luong, gia_tri, ma_kho)
	values (@ten_san_pham, @so_luong, @gia_tri, @ma_kho)
	select top 1* from san_pham order by ma_san_pham desc

end
--Kho (mã, tên, tổng tài sản, sức chứa)
drop proc them_va_hien_thi_gia_tri_vua_them_kho
create procedure them_va_hien_thi_gia_tri_vua_them_kho
@ten_kho nvarchar(50),
@suc_chua int
as
begin
	insert into kho(ten_kho, suc_chua)
	values (@ten_kho, @suc_chua)
	select top 1* from kho order by ma_kho desc
end

them_va_hien_thi_gia_tri_vua_them_kho @ten_kho = N'Kho kẹo', @suc_chua = 20
them_va_hien_thi_gia_tri_vua_them_san_pham @ten_san_pham = N'Kẹo nổ'  , @gia_tri = 20, @so_luong = 10, @ma_kho = 2


--Tạo trigger phù hợp để Khi cập nhật sản phẩm thì cập nhật tổng tài sản tương ứng với kho
drop trigger cap_nhat_tong_tai_san_tuong_ung_kho
create or alter trigger cap_nhat_tong_tai_san_tuong_ung_kho
on san_pham
after insert, delete, update
as
begin
	--update 
	update kho set
	tong_tai_san = tong_tai_san + tong_tien_cua_san_pham
	from kho join
	--Lấy ra tổng tài sản của 1 sản phẩm
	(select ma_kho, sum(gia_tri * so_luong) as 'tong_tien_cua_san_pham' from inserted group by ma_kho ) as i
	on i.ma_kho = kho.ma_kho

	update kho set
	tong_tai_san = tong_tai_san - tong_tien_cua_san_pham
	from kho join
	--Lấy ra tổng tài sản của 1 sản phẩm
	(select ma_kho, sum(gia_tri * so_luong) as 'tong_tien_cua_san_pham' from deleted group by ma_kho ) as d
	on d.ma_kho = kho.ma_kho

	select * from kho
	select * from san_pham

end

insert into san_pham(ma_san_pham, ten_san_pham, so_luong, gia_tri, ma_kho)
values (1, 'keo dong', 5,10,1),(2, 'bong dong', 5,10,2)

--Khi xoá kho thì kiểm tra sản phẩm có tồn tại không, nếu không mới được xoá
create or alter trigger kiem_tra_kho_truoc_khi_xoa
on kho
instead of delete
as
begin
	delete from kho
	where ma_kho in (
		--xóa những kho người dùng yêu cầu
		select ma_kho from deleted
		--chỉ xóa những kho k có sản phẩm
		where ma_kho not in(
			select ma_san_pham from san_pham
		)
	)

	select ma_kho, 'Khong the xoa do co san pham' as 'Thong bao' from kho
	where ma_kho in (
		select ma_kho from deleted
		where ma_kho in (
			select ma_san_pham from san_pham
		)
	)


end




delete from san_pham
where ma_san_pham in (3,4)

update san_pham set ma_kho = 1 where ma_san_pham  = 2

select * from kho
select * from san_pham

delete from kho
where ma_kho = 1


insert into kho
values (3, 'A', '0', 50)

