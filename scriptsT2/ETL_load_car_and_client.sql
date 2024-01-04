use CarRepairShopDW;
go
SET IDENTITY_INSERT dbo.Car OFF;
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

if(object_id('dbo.TempCar') is not null) Drop table TempCar;
if(object_id('dbo.TempTempCar') is not null) Drop table TempTempCar;
if(object_id('dbo.TempClient') is not null) Drop table TempClient;
if(object_id('dbo.TempCarView') is not null) Drop view TempCarView;

create table TempTempCar
(
    plates nvarchar(8),
    brand nvarchar(20),
    model nvarchar(30),
    type nvarchar(20),
    year_of_production int,
    name nvarchar(20),
    surname nvarchar(30),
	introduction_date varchar(10),
	expiry_date varchar(10)
);
create table TempCar
(
    plates nvarchar(8),
    brand nvarchar(20),
    model nvarchar(30),
    type nvarchar(20),
    year_of_production int,
    name nvarchar(20),
    surname nvarchar(30),
	introduction_date date,
	expiry_date date,
	full_name nvarchar(50)
);
create table TempClient
(
	full_name nvarchar(50)
);

bulk insert dbo.TempTempCar
from 'C:\Projects\DataWarehouses\DW_Populating\data\T2\CarRepairMaster\Cars.csv'
with
(
    firstrow = 2,
    datafiletype = 'char',
    fieldterminator = ';',
    rowterminator = '\n',
    tablock
);
go
insert into TempCar
	SELECT plates, brand, model, type, year_of_production, name, surname, CONVERT(DATE, introduction_date, 103), CONVERT(DATE, expiry_date, 103), CAST(name + ' ' + surname as nvarchar(50)) from TempTempCar;
go
insert into dbo.TempClient (full_name)
select distinct full_name
from dbo.TempCar
where full_name is not null;

go
MERGE INTO dbo.Client as c
	USING dbo.TempClient as cc
		ON c.full_name = cc.full_name
			WHEN Not Matched
				THEN
					INSERT Values (cc.full_name);
go
MERGE INTO dbo.Car as car
	USING dbo.TempCar as temp
		ON car.plates=temp.plates
			WHEN Not Matched
				THEN
					INSERT  VALUES(
						temp.plates,
						(SELECT id_client from Client where Client.full_name=temp.full_name),
						temp.type,
						temp.brand,
						temp.model,
						temp.year_of_production,
						CASE
							WHEN temp.expiry_date is null THEN 1
							ELSE 0
						END
					)
			WHEN Matched AND (
				(SELECT full_name from Client where Client.id_client=car.FK_id_client) <> temp.full_name
			)
				THEN
					UPDATE
					SET car.is_current=0					
;					
go
create view TempCarView as
select
	c.plates,
	c.brand,
	c.model,
	c.type,
	c.year_of_production,
	cli.full_name
from Car as c join Client as cli on cli.id_client=c.FK_id_client;
go
alter table TempCar drop column name, surname, introduction_date, expiry_date
create table TempImportTable(
	plates nvarchar(8),
	FK_id_client int,
    brand nvarchar(20),
    model nvarchar(30),
    type nvarchar(20),
    year_of_production int,
	is_current bit,
	full_name nvarchar(50)
	);
go
insert into TempImportTable (plates, brand, model, type, year_of_production, full_name) select * from TempCar t EXCEPT SELECT * from TempCarView;
update TempImportTable set is_current=1;
update TempImportTable set FK_id_client=(SELECT id_client from Client where full_name=TempImportTable.full_name);
alter table TempImportTable drop column full_name;
go
insert into Car select * from TempImportTable;
go
drop table TempImportTable;
Drop table TempCar;
Drop table TempTempCar;
Drop table TempClient;
Drop view TempCarView;