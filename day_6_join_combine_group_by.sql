Yêu cầu:

--Tạo cơ sở dữ liệu để quản lý sinh viên
create database quan_ly_sinh_vien
drop database quan_ly_sinh_vien
use quan_ly_sinh_vien
--có thông tin sinh viên, lớp (*: môn, điểm)
create table sinh_vien(
ma_sinh_vien int identity,
ten_sinh_vien nvarchar(50),
gioi_tinh bit default 0,
ma_lop int,
ma_mon int, 
foreign key (ma_mon) references mon(ma_mon),
foreign key (ma_lop) references lop(ma_lop),
primary key (ma_sinh_vien)
)

drop table sinh_vien
drop table lop

create table lop(
ma_lop int identity,
ten_lop nvarchar(50),
primary key (ma_lop)
)

create table mon(
ma_mon int identity,
ten_mon nvarchar(50),
primary key (ma_mon)
)

create table diem(
ma_mon int not null,
ma_sinh_vien int not null,
diem float,
foreign key (ma_mon) references mon(ma_mon),
foreign key (ma_sinh_vien) references sinh_vien(ma_sinh_vien),
primary key (ma_mon, ma_sinh_vien)
)


--có kiểm tra ràng buộc
alter table sinh_vien add constraint DK_ten_sinh_vien check (len(ten_sinh_vien) > 2)
alter table diem add constraint DK_diem check (diem >= 0 and diem <= 10)

--Thêm mỗi bảng số bản ghi nhất định
insert into lop
values('KHMT'), ('KTPM'), ('ATTT'), ('MMT')

insert into sinh_vien(ten_sinh_vien, gioi_tinh, ma_lop, ma_mon)
values (N'Lộc', 1, 1,1), ('Phong', 1, 2,2), ('Chau', 0, 3,3), ('Ben', 0, 2,1)

insert into mon
values ('SQL'), (N'Giải tích'), (N'Triết'), ('XSTK')

insert into diem(ma_mon, ma_sinh_vien, diem)
values (1,3,4), (2,4,5), (1,5,4), (3,6,6)

insert into sinh_vien(ten_sinh_vien)
values ('Been')

--Lấy ra tất cả sinh viên kèm thông tin lớp
select * from sinh_vien
left join lop on lop.ma_lop = sinh_vien.ma_lop

--Đếm số sinh viên theo từng lớp
select lop.ten_lop, count(ma_sinh_vien) as 'So sinh vien' from sinh_vien
right join lop on lop.ma_lop = sinh_vien.ma_lop
group by lop.ten_lop

--Lấy sinh viên kèm thông tin điểm và tên môn
select sinh_vien.ten_sinh_vien, diem.diem, mon.ten_mon from sinh_vien
left join mon on sinh_vien.ma_mon = mon.ma_mon
left join diem on diem.ma_sinh_vien = sinh_vien.ma_sinh_vien

--(*) Lấy điểm trung bình của sinh viên của lớp KTPM
select  avg(diem) as 'Diem cua lop KTPM' from sinh_vien
right join lop on lop.ma_lop = sinh_vien.ma_lop
join diem on diem.ma_sinh_vien = sinh_vien.ma_sinh_vien
where lop.ten_lop = 'KTPM'

--(*) Lấy điểm trung bình của sinh viên của môn SQL
select avg(diem) as 'Diem trung binh mon SQL' from diem
right join mon on mon.ma_mon = diem.ma_mon
where mon.ten_mon = 'SQl'

--(*) Lấy điểm trung bình của sinh viên theo từng lớp
select avg(diem),ten_lop from sinh_vien
join diem  on diem.ma_sinh_vien = sinh_vien.ma_sinh_vien
join lop on lop.ma_lop = sinh_vien.ma_lop
group by ten_lop
