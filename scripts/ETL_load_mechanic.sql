use CarRepairShopDW;

if(object_id('dbo.TempMechanic') is not null) Drop table TempMechanic;

create table TempMechanic(
	id int,
	name nvarchar(20),
	lastname nvarchar(30)
	);
go
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
go
alter table TempMechanic drop column id,name,lastname;
go
merge into Mechanic as mech
	using TempMechanic as temp
		on mech.full_name=temp.full_name
			When Not Matched
				THEN
					INSERT Values(full_name);
go
drop table TempMechanic;