USE [CarRepairShopDW]
GO
/****** Object:  Table [dbo].[Car]    Script Date: 19.12.2023 12:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Car](
	[id_car] [int] IDENTITY(1,1) NOT NULL,
	[plates] [nvarchar](8) NOT NULL,
	[FK_id_client] [int] NOT NULL,
	[type] [nvarchar](20) NOT NULL,
	[brand] [nvarchar](20) NOT NULL,
	[model] [nvarchar](30) NOT NULL,
	[year_of_production] [int] NOT NULL,
	[is_current] [bit] NOT NULL,
 CONSTRAINT [PK_Car] PRIMARY KEY CLUSTERED 
(
	[id_car] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Client]    Script Date: 19.12.2023 12:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Client](
	[id_client] [int] IDENTITY(1,1) NOT NULL,
	[full_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
(
	[id_client] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Date]    Script Date: 19.12.2023 12:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Date](
	[id_date] [int] IDENTITY(1,1) NOT NULL,
	[date] [date] NOT NULL,
	[year] [int] NOT NULL,
	[month] [varchar](10) NOT NULL,
	[month_number] [int] NOT NULL,
	[day_in_month] [int] NOT NULL,
 CONSTRAINT [PK_Date] PRIMARY KEY CLUSTERED 
(
	[id_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Junk]    Script Date: 19.12.2023 12:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Junk](
	[id_junk] [int] IDENTITY(1,1) NOT NULL,
	[used_car_transporter] [nvarchar](16) NOT NULL,
	[is_complaint] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Junk] PRIMARY KEY CLUSTERED 
(
	[id_junk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Mechanic]    Script Date: 19.12.2023 12:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mechanic](
	[id_mechanic] [int] IDENTITY(1,1) NOT NULL,
	[full_name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Mechanic] PRIMARY KEY CLUSTERED 
(
	[id_mechanic] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Mechanic_TA]    Script Date: 19.12.2023 12:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mechanic_TA](
	[FK_id_mechanic] [int] IDENTITY(1,1) NOT NULL,
	[FK_id_date] [int] NOT NULL,
	[number_of_hours] [float] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Part]    Script Date: 19.12.2023 12:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Part](
	[id_part] [int] IDENTITY(1,1) NOT NULL,
	[part_type] [varchar](30) NOT NULL,
	[producer] [varchar](30) NOT NULL,
 CONSTRAINT [PK_Part] PRIMARY KEY CLUSTERED 
(
	[id_part] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Part_in_repair]    Script Date: 19.12.2023 12:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Part_in_repair](
	[FK_id_repair] [int] IDENTITY(1,1) NOT NULL,
	[FK_id_part] [int] NOT NULL,
	[part_number] [int] NOT NULL,
	[purchase_price] [int] NOT NULL,
	[commission] [float] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Repair]    Script Date: 19.12.2023 12:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Repair](
	[id_repair] [int] IDENTITY(1,1) NOT NULL,
	[FK_id_car] [int] NOT NULL,
	[FK_id_mechanic] [int] NOT NULL,
	[FK_id_junk] [int] NOT NULL,
	[FK_repair_date_start] [int] NOT NULL,
	[FK_repair_date_end] [int] NOT NULL,
	[repair_no] [int] NOT NULL,
	[pricing] [int] NOT NULL,
 CONSTRAINT [PK_Repair] PRIMARY KEY CLUSTERED 
(
	[id_repair] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Car]  WITH CHECK ADD  CONSTRAINT [FK_Car_Client] FOREIGN KEY([FK_id_client])
REFERENCES [dbo].[Client] ([id_client])
GO
ALTER TABLE [dbo].[Car] CHECK CONSTRAINT [FK_Car_Client]
GO
ALTER TABLE [dbo].[Mechanic_TA]  WITH CHECK ADD  CONSTRAINT [FK_Mechanic_TA_Date] FOREIGN KEY([FK_id_date])
REFERENCES [dbo].[Date] ([id_date])
GO
ALTER TABLE [dbo].[Mechanic_TA] CHECK CONSTRAINT [FK_Mechanic_TA_Date]
GO
ALTER TABLE [dbo].[Mechanic_TA]  WITH CHECK ADD  CONSTRAINT [FK_Mechanic_TA_Mechanic] FOREIGN KEY([FK_id_mechanic])
REFERENCES [dbo].[Mechanic] ([id_mechanic])
GO
ALTER TABLE [dbo].[Mechanic_TA] CHECK CONSTRAINT [FK_Mechanic_TA_Mechanic]
GO
ALTER TABLE [dbo].[Part_in_repair]  WITH CHECK ADD  CONSTRAINT [FK_Part_in_repair_Part] FOREIGN KEY([FK_id_part])
REFERENCES [dbo].[Part] ([id_part])
GO
ALTER TABLE [dbo].[Part_in_repair] CHECK CONSTRAINT [FK_Part_in_repair_Part]
GO
ALTER TABLE [dbo].[Part_in_repair]  WITH CHECK ADD  CONSTRAINT [FK_Part_in_repair_Repair] FOREIGN KEY([FK_id_repair])
REFERENCES [dbo].[Repair] ([id_repair])
GO
ALTER TABLE [dbo].[Part_in_repair] CHECK CONSTRAINT [FK_Part_in_repair_Repair]
GO
ALTER TABLE [dbo].[Repair]  WITH CHECK ADD  CONSTRAINT [FK_Repair_Car] FOREIGN KEY([FK_id_car])
REFERENCES [dbo].[Car] ([id_car])
GO
ALTER TABLE [dbo].[Repair] CHECK CONSTRAINT [FK_Repair_Car]
GO
ALTER TABLE [dbo].[Repair]  WITH CHECK ADD  CONSTRAINT [FK_Repair_Date] FOREIGN KEY([FK_repair_date_start])
REFERENCES [dbo].[Date] ([id_date])
GO
ALTER TABLE [dbo].[Repair] CHECK CONSTRAINT [FK_Repair_Date]
GO
ALTER TABLE [dbo].[Repair]  WITH CHECK ADD  CONSTRAINT [FK_Repair_Date1] FOREIGN KEY([FK_repair_date_end])
REFERENCES [dbo].[Date] ([id_date])
GO
ALTER TABLE [dbo].[Repair] CHECK CONSTRAINT [FK_Repair_Date1]
GO
ALTER TABLE [dbo].[Repair]  WITH CHECK ADD  CONSTRAINT [FK_Repair_Junk] FOREIGN KEY([FK_id_junk])
REFERENCES [dbo].[Junk] ([id_junk])
GO
ALTER TABLE [dbo].[Repair] CHECK CONSTRAINT [FK_Repair_Junk]
GO
ALTER TABLE [dbo].[Repair]  WITH CHECK ADD  CONSTRAINT [FK_Repair_Mechanic] FOREIGN KEY([FK_id_mechanic])
REFERENCES [dbo].[Mechanic] ([id_mechanic])
GO
ALTER TABLE [dbo].[Repair] CHECK CONSTRAINT [FK_Repair_Mechanic]
GO
