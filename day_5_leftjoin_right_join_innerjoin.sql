--bài tập

--Tạo cơ sở dữ liệu để lưu thông tin kinh doanh của 1 cửa hàng
--Yêu cầu có đủ:
--thông tin khách hàng
--thông tin sản phẩm
--thông tin hoá đơn

create table khachHang(			
maKhachHang int identity,			
ho nvarchar(10),					
ten nvarchar(10),					
mail varchar(50),					
soDienThoai char(15),				
diaChi nvarchar(50)					
)

create table  sanPham(
maSanPham int identity,
tenSanPham nvarchar(50),
thongTin nvarchar(50),
gia int
)

create table hoaDon(
maKhachHang ,
maSanPham ,
ngayMua 
soLuong
)



--Tạo bảng quản lí 1 lớp - n sinh viên

create table lop(
maLop int identity,
tenLop nvarchar(50) not null unique,
primary key (maLop)
)
insert into lop
values ('ATTT'), ('CSDL'), ('LT'), ('Hack')
drop table lop
create table sinhVien(
maSinhVien int identity,
tenSinhVien nvarchar(50) not null,
gioiTinh bit default 0,
maLop int,
foreign key (maLop) references lop(maLop), 
primary key (maSinhVien)
)
insert into sinhVien
values ('Loc', 1, 2), ('Tuan', 1, 1), ('Long',1,3)
insert into sinhVien(tenSinhVien, gioiTinh)
values ('Anh', 1)

select lop.tenLop, sinhVien.maSinhVien, sinhVien.tenSinhVien, sinhVien.gioiTinh from lop
join sinhVien on lop.maLop = sinhVien.maLop


select * from sinhVien
left join lop on lop.maLop = sinhVien.maLop

--Đếm sinh viên không có lớp nào:
select count(*) from sinhVien
right join lop on lop.maLop = sinhVien.maLop
where sinhVien.maLop is null

--In ra số sinh viên theo từng lớp
select lop.tenLop, count(sinhVien.tenSinhVien) as 'So sinh vien' from sinhVien
right join lop on lop.maLop = sinhVien.maLop
group by lop.tenLop
