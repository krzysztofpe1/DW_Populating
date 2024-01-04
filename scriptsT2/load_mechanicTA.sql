use CarRepairShopDW;

if(OBJECT_ID('TempFileNames') is not null)drop table TempFileNames;
if(OBJECT_ID('TempMechanicTAs') is not null)drop table TempMechanicTAs;
if(OBJECT_ID('TempMechanicTAsView') is not null)drop table TempMechanicTAsView;
go
Create table TempFileNames (
	FileName varchar(max),
	depth varchar(max),
	[FILE] varchar(max)
	);
create table TempMechanicTAs(
	name varchar(20),
	surname varchar(30),
	date varchar(10),
	amount varchar(5)
	);
go
INSERT INTO TempFileNames EXEC master.dbo.xp_DirTree 'C:\Projects\DataWarehouses\DW_Populating\data\T2\CEOExcel\',1,1;
go
alter table TempFileNames drop column depth, [FILE];
go
DECLARE @FILENAME VARCHAR(MAX),@SQL VARCHAR(MAX);
WHILE EXISTS(SELECT * FROM TempFileNames)
BEGIN
	SET @FILENAME = (SELECT TOP 1 FileName FROM TempFileNames)
	SET @SQL = 'bulk insert TempMechanicTAs
				from ''C:\Projects\DataWarehouses\DW_Populating\data\T2\CEOExcel\' + @FILENAME +'''
				with
				(
					firstrow = 2,
					datafiletype = ''char'',
					fieldterminator = '';'',
					rowterminator = ''\n'',
					tablock
				);'

	EXEC(@SQL)

	Delete from TempFileNames where FileName=@FILENAME
END
go

create table TempMechanicTAsView(
	FK_id_mechanic int,
	FK_id_date int,
	number_of_hours float
	);

insert into TempMechanicTAsView select 
	(SELECT m.id_mechanic from Mechanic m where m.full_name=CAST(temp.name+' '+temp.surname AS varchar(50))) AS FK_id_mechanic,
	(SELECT d.id_date from Date d where d.date=CONVERT(DATE, temp.date, 103)) AS FK_id_date,
	CONVERT(float, REPLACE(temp.amount, ',','.')) as number_of_hours
from TempMechanicTAs as temp;
go
SET IDENTITY_INSERT dbo.Mechanic_TA ON;
insert into Mechanic_TA (FK_id_mechanic, FK_id_date, number_of_hours) select tv.FK_id_mechanic, tv.FK_id_date, tv.number_of_hours from TempMechanicTAsView tv
EXCEPT
select mta.FK_id_mechanic, mta.FK_id_date, mta.number_of_hours from Mechanic_TA mta;


