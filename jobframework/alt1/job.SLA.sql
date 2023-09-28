if not exists(select [name] from sys.[schemas] where [name] = 'job')
begin
	Declare @sqlstmt nvarchar(500) = 'create schema job'
	Exec (@sqlstmt)
end
go

-- SLA
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [job].[SLA]
GO
CREATE TABLE [job].[SLA]
(
	[Id]       [int] IDENTITY(1,1) NOT NULL,
	[SLA]      [nvarchar](200) NOT NULL,
	[SLA_Desc] [nvarchar](500) NOT NULL,
	[Sec]      [int] NOT NULL,
	CONSTRAINT [PK_SLA] PRIMARY KEY CLUSTERED ([Id] ASC)
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [job].[SLA] ON
insert into job.[SLA] ([Id], SLA, SLA_Desc, Sec) values (-1,'<10m','Execution time should always be <10m', 10*60);
SET IDENTITY_INSERT [job].[SLA] OFF
select * from job.SLA
go

