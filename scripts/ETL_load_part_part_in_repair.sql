use CarRepairShopDW;
go
SET IDENTITY_INSERT dbo.Part_in_repair ON;
if(object_id('dbo.TempPart') is not null) Drop table TempPart;
if(object_id('dbo.TempTempRepair') is not null) Drop table TempTempRepair;
if(object_id('dbo.TempRepair') is not null) Drop table TempRepair;
if(object_id('dbo.TempRepairView') is not null) Drop view TempRepairView;
if(object_id('dbo.TempRepairViewWithJunk') is not null) Drop view TempRepairViewWithJunk;
if(object_id('dbo.TempUniquePart') is not null) Drop table TempUniquePart;
if(object_id('dbo.TempPartInRepairView') is not null) Drop view TempPartInRepairView;
go
create table TempPart(
	id int,
	part_type varchar(30),
	producer varchar(30),
	price int,
	id_repair int
	);
create table TempTempRepair(
	id int,
	start_date varchar(10),
	end_date varchar(10),
	plates nvarchar(8),
	id_mechanic int,
	pricing int,
	used_car_transporter varchar(5),
	is_complaint varchar(5),
	repair_no int
	);
create table TempRepair(
	id int,
	start_date date,
	end_date date,
	plates nvarchar(8),
	id_mechanic int,
	pricing int,
	used_car_transporter bit,
	is_complaint bit,
	repair_no int
	);
--MECHANIK
go
if(object_id('dbo.TempMechanic') is not null) Drop table TempMechanic;

create table TempMechanic(
	id int,
	name nvarchar(20),
	lastname nvarchar(30)
	);

bulk insert TempMechanic
from 'C:\Projects\DataWarehouses\DW_Populating\data\T1\CarRepairMaster\Mechanics.csv'
with
(
    firstrow = 2,
    datafiletype = 'char',
    fieldterminator = ';',
    rowterminator = '\n',
    tablock
);
go
alter table TempMechanic add full_name nvarchar(50);
go
update TempMechanic set full_name=CAST(name+' '+lastname as nvarchar(50));
alter table TempMechanic drop column name,lastname;
--KONIEC MECHANIKA
go
bulk insert dbo.TempPart
from 'C:\Projects\DataWarehouses\DW_Populating\data\T1\CarRepairMaster\Parts.csv'
with
(
    firstrow = 2,
    datafiletype = 'char',
    fieldterminator = ';',
    rowterminator = '\n',
    tablock
);
bulk insert dbo.TempTempRepair
from 'C:\Projects\DataWarehouses\DW_Populating\data\T1\CarRepairMaster\Repairs.csv'
with
(
    firstrow = 2,
    datafiletype = 'char',
    fieldterminator = ';',
    rowterminator = '\n',
    tablock
);
go
insert into TempRepair select t.id, CONVERT(DATE, t.start_date, 103), CONVERT(DATE, t.end_date, 103), t.plates, t.id_mechanic, t.pricing, CONVERT(Bit, t.used_car_transporter), CONVERT(Bit, t.is_complaint), t.repair_no from TempTempRepair as t;
go
create view TempRepairView as
select
	temp.id as old_id,
	(SELECT c.id_car FROM Car c where c.plates=temp.plates) AS FK_id_car,
	(SELECT mech.id_mechanic FROM Mechanic mech where mech.full_name=(SELECT m.full_name FROM TempMechanic m where m.id=temp.id_mechanic)) AS FK_id_mechanic,
	(SELECT d.id_date from Date d where d.date=temp.start_date) as FK_repair_date_start,
	(SELECT d.id_date from Date d where d.date=temp.end_date) as FK_repair_date_end,
	CASE
		WHEN temp.used_car_transporter=0 THEN 'U¿yto lawety' ELSE 'Nie u¿yto lawety'
	END AS used_car_transporter,
	CASE
		WHEN temp.is_complaint=0 THEN 'Zwyk³a naprawa' ELSE 'Naprawa reklamacyjna'
	END AS is_complaint,
	temp.repair_no as repair_no,
	temp.pricing AS pricing
from TempRepair as temp;
go
create view TempRepairViewWithJunk as
select
    temp.old_id,
	temp.FK_id_car,
	temp.FK_id_mechanic,
	(SELECT j.id_junk from Junk j where j.is_complaint=temp.is_complaint and j.used_car_transporter=temp.used_car_transporter) AS FK_id_junk,
	temp.FK_repair_date_start,
	temp.FK_repair_date_end,
	temp.repair_no,
	temp.pricing
from TempRepairView as temp
go
MERGE INTO dbo.Repair as r
	USING dbo.TempRepairViewWithJunk as tr
		ON r.FK_id_car=tr.FK_id_car and r.FK_id_mechanic=tr.FK_id_mechanic and r.FK_id_junk = tr.FK_id_junk and r.FK_repair_date_start=tr.FK_repair_date_start and r.FK_repair_date_end=tr.FK_repair_date_end and r.repair_no=tr.repair_no and r.pricing=tr.pricing
			WHEN Not Matched
				THEN
					INSERT Values(tr.FK_id_car, tr.FK_id_mechanic, tr.FK_id_junk, tr.FK_repair_date_start, tr.FK_repair_date_end, tr.repair_no, tr.pricing);
--koniec dodawania Repair
create table TempUniquePart(
	part_type varchar(30),
	producer varchar(30)
	);
insert into TempUniquePart SELECT DISTINCT part_type, producer from TempPart;

merge into Part as p
using TempUniquePart as tp
	on p.part_type=tp.part_type and p.producer=tp.producer
		WHEN Not Matched
			THEN
				INSERT Values(tp.part_type, tp.producer);

--koniec dodawania Part
go
create view TempPartInRepairView as
select
	(SELECT r.id_repair FROM Repair r where r.FK_id_car=temp.FK_id_car and r.FK_id_mechanic=temp.FK_id_mechanic and r.FK_id_junk=temp.FK_id_junk and r.FK_repair_date_start=temp.FK_repair_date_start and r.FK_repair_date_end=temp.FK_repair_date_end and r.repair_no=temp.repair_no and r.pricing=temp.pricing) as FK_id_repair,
	(SELECT p.id_part from Part p where p.part_type=tp.part_type and p.producer=tp.producer and tp.id_repair=temp.old_id) as FK_id_part,
	0 as part_number,
	tp.price as purchase_price,
	CAST(tp.price*0.1 as float) as commission
from TempRepairViewWithJunk as temp join TempPart tp on temp.old_id=tp.id_repair;
go

merge into Part_in_repair as pir
using TempPartInRepairView as tpir
	on pir.FK_id_repair=tpir.FK_id_repair and pir.FK_id_part=tpir.FK_id_part and pir.part_number=tpir.part_number and pir.purchase_price=tpir.purchase_price and pir.commission=tpir.commission
		WHEN Not Matched
			THEN
				INSERT (FK_id_repair, FK_id_part, part_number, purchase_price, commission)
				Values(tpir.FK_id_repair, tpir.FK_id_part, tpir.part_number, tpir.purchase_price, tpir.commission);
go
Drop table TempPart;
Drop table TempTempRepair;
Drop table TempRepair;
Drop view TempRepairView;
Drop view TempRepairViewWithJunk;
Drop table TempUniquePart;
Drop view TempPartInRepairView;
Drop table TempMechanic;

