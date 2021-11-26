--Tạo bảng lưu thông tin điểm của sinh viên (mã, họ tên, điểm lần 1, điểm lần 2)
create database quanLySinhVien
use quanLySinhVien

drop table sinhVien
create table sinhVien(
ma int identity unique not null,
hoTen nvarchar(50) not null,
diemLanMot float,
diemLanHai float,
primary key (ma)
)
--Với điều kiện:
--điểm không được phép nhỏ hơn 0 và lớn hơn 10
alter table sinhVien
add constraint DK_diem check(diemLanMot >= 0 and diemLanMot <= 10 and diemLanHai >= 0 and diemLanHai <= 10)

--điểm lần 1 nếu không nhập mặc định sẽ là 5
alter table sinhVien
add constraint DK_macdinhdiemlan1
default 5 for diemLanMot

--(*) điểm lần 2 không được nhập khi mà điểm lần 1 lớn hơn hoặc bằng 5
alter table sinhVien
add constraint kiemTraDiemLanHai check( (diemLanMot>=5 and diemLanHai is null) or diemLanMot <5 )

--(**) tên không được phép ngắn hơn 2 ký tự
alter table sinhVien
add constraint kiemTraTen check (Len(hoTen)>=2)


--Điền 5 sinh viên kèm điểm
insert into sinhVien
values ('Khoa',2,1)
values  ('Long', 5 ,null) ,(N'Lộc',5,null), (N'Luân',9,null), ('Phong', 4,null), ('Khoa',2,1)

--Lấy ra các bạn điểm lần 1 hoặc lần 2 lớn hơn 5
select * from sinhVien
where (diemLanMot>5 or diemLanHai>5)

--Lấy ra các bạn qua môn ngay từ lần 1
select * from sinhVien
where diemLanMot >= 5

--Lấy ra các bạn trượt môn
select * from sinhVien
where diemLanMot < 5 and diemLanHai <5 

--(*) Đếm số bạn qua môn sau khi thi lần 2
select count(*) as 'So ban qua mon khi thi lan 2'
from sinhVien
where diemLanMot < 5 and diemLanHai >=5

--(**) Đếm số bạn cần phải thi lần 2 (tức là thi lần 1 chưa qua nhưng chưa nhập điểm lần 2)

select count (*) as 'So ban can phai thi lan 2'
from sinhVien
where diemLanMot <5 and diemLanHai is null

select count (*) as 'Nhung ban da thi lan 2'
from sinhVien
where diemLanHai is not null

select count (diemLanHai) as 'Nhung ban co diem lan 1'
from sinhVien

select hoTen as 'Danh sach cac ban' from sinhVien
order by hoTen asc