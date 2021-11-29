
--Ban lãnh đạo thành phố yêu cầu bạn tạo bảng lưu các con vật trong sở thú
create database so_thu
use so_thu
drop database so_thu
create table dong_vat(
ten_loai_vat nvarchar(20),
so_chan int,
ngay_sinh date default getdate(),
moi_truong_song nvarchar(50),
)
drop table dong_vat 

insert into dong_vat
values ('Voi', 4, '2019-05-03', N'Cạn'), (N'Cá', 0,'2015-05-02', N'Nước'), (N'Hươu', 4, '2010-05-01',N'Cạn'), ('Heo',4,default,N'Cạn' ), (N'Khỉ',2,  default,N'Cạn'),('Voi', 4,  '2002-05-03',N'Cạn'),(N'Cá', 0,'2013-05-02', N'Nước')

--Thống kê có bao nhiêu con 4 chân
select count(*) as 'Tong so con vat co 4 chan la' from dong_vat
where so_chan = 4

--Thống kê số con tương ứng với số chân
select so_chan, count(*) as 'So_con' from dong_vat
group by so_chan


--Thống kê số con theo môi trường sống
select moi_truong_song,count(*) as 'So con' from  dong_vat
group by moi_truong_song

--Thống kê tuổi thọ trung bình theo môi trường sống
select moi_truong_song, avg(year(getdate()) - year(ngay_sinh)) as 'Tuoi trung binh' from dong_vat
group by moi_truong_song

--Lấy ra 3 con có tuổi thọ thọ cao nhất
select top 3* from dong_vat
order by ngay_sinh asc

--(*) Tách những thông tin trên thành 2 bảng cho dễ quản lý (1 môi trường sống gồm nhiều con)

create table moi_truong_song(
ma int identity,
ten_moi_truong nvarchar(50) not null unique,
primary key (ma)
)

insert into moi_truong_song(ten_moi_truong)
values (N'Trong nhà'), (N'Dưới nước'), (N'Mặt đất')

create table dong_vat(
ten_loai_vat nvarchar(20),
so_chan int,
ngay_sinh date default getdate(),
ma_moi_truong_song int not null,
foreign key (ma_moi_truong_song) references moi_truong_song(ma)
)

insert into dong_vat
values ('Voi', 4, '2019-05-03', 3), (N'Cá', 0,'2015-05-02', 2), (N'Hươu', 4, '2010-05-01',3), ('Heo',4,default,1 ), (N'Khỉ',2,  default,3),('Voi', 4,  '2002-05-03',3),(N'Cá', 0,'2013-05-02', 2)

select *
from dong_vat
join moi_truong_song on moi_truong_song.ma = dong_vat.ma_moi_truong_song

select * from moi_truong_song
select * from dong_vat
