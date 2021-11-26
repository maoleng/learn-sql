Sếp yêu cầu bạn thiết kế cơ sở dữ liệu quản lý lương nhân viên

create database quan_ly_luong_nhan_vien
use quan_ly_luong_nhan_vien
create table nhan_vien(
--tất cả các cột không được để trống
--mã nhân viên không được phép trùng
ma int identity unique not null,
--lương là số nguyên dương
luong int constraint dieu_kien_cua_luong check (luong>0) not null,
--tên không được phép ngắn hơn 2 ký tự
ho_ten nvarchar(50) constraint dieu_kien_cua_ten check (len(ho_ten)>1) not null,
--tuổi phải lớn hơn 18
ngay_sinh date  not null,
--giới tính mặc định là nữ
gioi_tinh bit  not null default 0,
--ngày vào làm mặc định là hôm nay
ngay_vao_lam date default getdate() not null,
-- nghề nghiệp phải nằm trong danh sách ('IT','kế toán','doanh nhân')
nghe_nghiep nvarchar(50) constraint dieu_kien_nghe_nghiep check(nghe_nghiep in('IT', N'kế toán', N'doanh nhân')) not null
)
drop table nhan_vien
alter table nhan_vien
add constraint check_tuoi check(year(ngay_sinh) < year(getdate()))

--1/Công ty có 5 nhân viên
insert into nhan_vien (luong, ho_ten, ngay_sinh, gioi_tinh,ngay_vao_lam, nghe_nghiep)
values (120,N'Lộc','2003-05-10',1,'2022-05-05', 'IT'), (150,'Long', '1999-10-05' , 1,'1990-05-05', N'kế toán') ,(200, 'Linh', '1990-05-05',0,'2012-05-05', N'doanh nhân'), (30,'Khoa', '2001-10-05',0,'2015-03-03','IT'), (45,'Anh','1999-05-05',0,default,'IT')

--2/Tháng này sinh nhật sếp, sếp tăng lương cho nhân viên sinh tháng này thành 100. )
update nhan_vien
set luong = 100
where month(ngay_vao_lam) = month(getdate())
--*tăng lương cho mỗi bạn thêm 100
update nhan_vien set luong+= 100 

--3/Dịch dã khó khăn, cắt giảm nhân sự, cho nghỉ việc bạn nào lương dưới 50.  
delete from nhan_vien
where luong < 50
--*: xoá cả bạn vừa thêm 100 nếu lương cũ dưới 50).
update nhan_vien
set luong-=100 where month(GETDATE()) = month(ngay_vao_lam)
delete from nhan_vien where luong < 50
--(**: đuổi cả nhân viên mới vào làm dưới 2 tháng)
delete from nhan_vien where (month(getdate()) - month(ngay_vao_lam) < 2) and (year(ngay_vao_lam)<year(getdate()))

delete from nhan_vien
where datediff(month, ngay_vao_lam, getdate()) < 2 and year(ngay_vao_lam) <= year(getdate())
--4/Lấy ra tổng tiền mỗi tháng sếp phải trả cho nhân viên.
select sum(luong) as 'Tong_luong_sep_phai_tra' from nhan_vien
 --*: theo từng nghề
select sum(luong) as 'Luong_cua_IT'  from nhan_vien  where nghe_nghiep = 'IT'
select sum(luong) as 'Luong_cua_doanh_nhan' from nhan_vien  where nghe_nghiep = N'doanh nhân' 
select sum(luong) as 'Luong_cua_ke_toan' from nhan_vien   where nghe_nghiep = N'kế toán'

select nghe_nghiep,sum(luong) as 'Tong_luong' from nhan_vien
group by nghe_nghiep

--5/Lấy ra trung bình lương nhân viên. 
select avg(luong) as 'Trung_binh_luong_cua_nhan_vien' from nhan_vien
--(*: theo từng nghề)
select avg(luong) as 'TB_Luong_cua_IT' from nhan_vien where nghe_nghiep ='IT'
select avg(luong) as 'TB_Luong_cua_doanh_nhan' from nhan_vien  where nghe_nghiep = N'doanh nhân' 
select avg(luong) as 'TB_Luong_cua_ke_toan' from nhan_vien   where nghe_nghiep = N'kế toán'

select nghe_nghiep, avg(luong) as 'Trung binh luong theo nghe' from nhan_vien
group by nghe_nghiep
--6/(*) Lấy ra các bạn mới vào làm hôm nay
select * from nhan_vien where day(ngay_vao_lam)=day(getdate()) and MONTH(ngay_vao_lam)=month(getdate()) and year(ngay_vao_lam) = year (getdate())

select * from nhan_vien
where ngay_vao_lam = cast(getdate() as date)

--7/(*) Lấy ra 3 bạn nhân viên cũ nhất
select top 3 * from nhan_vien
order by ma asc

--8/(**) Tách những thông tin trên thành nhiều bảng cho dễ quản lý, lương 1 nhân viên có thể nhập nhiều lần


delete from nhan_vien
select * from nhan_vien


--BT Bổ sung
SELECT * FROM nhan_vien
ORDER BY ngay_vao_lam asc
OFFSET 2 ROWS 
FETCH NEXT 3 ROWS ONLY


--Nâng cao về groupby
select  gioi_tinh,sum(luong)   from nhan_vien
group by gioi_tinh