/*
Bereitstellungsskript für v2-8-0

Dieser Code wurde von einem Tool generiert.
Änderungen an dieser Datei führen möglicherweise zu falschem Verhalten und gehen verloren, falls
der Code neu generiert wird.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "v2-8-0"
:setvar DefaultFilePrefix "v2-8-0"
:setvar DefaultDataPath "D:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "D:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Überprüfen Sie den SQLCMD-Modus, und deaktivieren Sie die Skriptausführung, wenn der SQLCMD-Modus nicht unterstützt wird.
Um das Skript nach dem Aktivieren des SQLCMD-Modus erneut zu aktivieren, führen Sie folgenden Befehl aus:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Der SQLCMD-Modus muss aktiviert sein, damit dieses Skript erfolgreich ausgeführt werden kann.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_setup_show_desktop]" wird gelöscht...';


GO
ALTER TABLE [dbo].[setup] DROP CONSTRAINT [DF_setup_show_desktop];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_setup_verbous]" wird gelöscht...';


GO
ALTER TABLE [dbo].[setup] DROP CONSTRAINT [DF_setup_verbous];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_setup_vat]" wird gelöscht...';


GO
ALTER TABLE [dbo].[setup] DROP CONSTRAINT [DF_setup_vat];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_setup_upload_max]" wird gelöscht...';


GO
ALTER TABLE [dbo].[setup] DROP CONSTRAINT [DF_setup_upload_max];


GO
PRINT N'DEFAULT-Einschränkung "unbenannte Einschränkungen auf [dbo].[setup]" wird gelöscht...';


GO
ALTER TABLE [dbo].[setup] DROP CONSTRAINT [DF__setup__num_forma__18B6AB08];


GO
PRINT N'DEFAULT-Einschränkung "unbenannte Einschränkungen auf [dbo].[setup]" wird gelöscht...';


GO
ALTER TABLE [dbo].[setup] DROP CONSTRAINT [DF__setup__num_cultu__19AACF41];


GO
PRINT N'Das erneute Erstellen der Tabelle "[dbo].[setup]" wird gestartet....';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_setup] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [email_profile]   VARCHAR (255) NULL,
    [alert_document]  INT           NULL,
    [show_desktop]    BIT           CONSTRAINT [DF_setup_show_desktop] DEFAULT 0 NULL,
    [verbous]         BIT           CONSTRAINT [DF_setup_verbous] DEFAULT 0 NULL,
    [vat]             FLOAT (53)    CONSTRAINT [DF_setup_vat] DEFAULT 0 NOT NULL,
    [upload_max_byte] INT           CONSTRAINT [DF_setup_upload_max] DEFAULT ((1000000)) NOT NULL,
    [nav_button]      BIT           DEFAULT 0 NOT NULL,
    [num_format]      NCHAR (1)     DEFAULT 'G' NOT NULL,
    [num_culture]     NCHAR (5)     DEFAULT 'de-de' NOT NULL,
    [version_fe]      VARCHAR (255) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_configuration1] PRIMARY KEY CLUSTERED ([id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[setup])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_setup] ON;
        INSERT INTO [dbo].[tmp_ms_xx_setup] ([id], [email_profile], [alert_document], [show_desktop], [verbous], [vat], [upload_max_byte], [num_format], [num_culture], [version_fe])
        SELECT   [id],
                 [email_profile],
                 [alert_document],
                 [show_desktop],
                 [verbous],
                 [vat],
                 [upload_max_byte],
                 [num_format],
                 [num_culture],
                 [version_fe]
        FROM     [dbo].[setup]
        ORDER BY [id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_setup] OFF;
    END

DROP TABLE [dbo].[setup];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_setup]', N'setup';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_configuration1]', N'PK_configuration', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Tabelle "[dbo].[material_hp]" wird erstellt...';


GO
CREATE TABLE [dbo].[material_hp] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [identifier] VARCHAR (255) NOT NULL,
    [applies]    BIT           NOT NULL,
    [material]   INT           NOT NULL,
    CONSTRAINT [PK_material_hp] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_hp_applies]" wird erstellt...';


GO
ALTER TABLE [dbo].[material_hp]
    ADD CONSTRAINT [DF_material_hp_applies] DEFAULT ((0)) FOR [applies];


GO
PRINT N'Fremdschlüssel "[dbo].[FK_material_hp]" wird erstellt...';


GO
ALTER TABLE [dbo].[material_hp] WITH NOCHECK
    ADD CONSTRAINT [FK_material_hp] FOREIGN KEY ([material]) REFERENCES [dbo].[material] ([id]) ON DELETE CASCADE;


GO
PRINT N'CHECK-Einschränkung "[dbo].[CK_setup]" wird erstellt...';


GO
ALTER TABLE [dbo].[setup] WITH NOCHECK
    ADD CONSTRAINT [CK_setup] CHECK ([vat]>=(0) AND [vat]<=(100));


GO
PRINT N'Trigger "[dbo].[setup_insert]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[setup_insert]
   ON  dbo.setup
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT COUNT(id) FROM setup) > 1
		THROW 51000, 'Only one row config is allowed.', 1 
END
GO
PRINT N'Trigger "[dbo].[material_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2024 December
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[material_insert_update]
   ON  dbo.material
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert material_hp cross table
	IF NOT EXISTS (SELECT id FROM deleted)
	BEGIN
		INSERT INTO material_hp (identifier, material) SELECT item, (SELECT id FROM inserted) FROM translation WHERE container = 'material' AND (item LIKE 'hazard_%' OR item LIKE '%precautionary_%' OR item LIKE 'EUH_%') ORDER BY item ASC
	END

	-- UPDATE material_hp cross table
	IF EXISTS (SELECT id FROM deleted)
	BEGIN
		INSERT INTO material_hp (identifier, material) SELECT item, (SELECT id FROM inserted) item FROM translation WHERE container = 'material' AND (item LIKE 'hazard_%' OR item LIKE '%precautionary_%' OR item LIKE 'EUH_%') AND item NOT IN (SELECT identifier FROM material_hp WHERE material = (SELECT ID FROM inserted))
	END
END
GO
PRINT N'Sicht "[dbo].[view_attachment_revision]" wird aktualisiert...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[view_attachment_revision]';


GO
PRINT N'Prozedur "[dbo].[gesd_test]" wird geändert...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	GESD test
-- =============================================
ALTER PROCEDURE [dbo].[gesd_test]
	-- Add the parameters for the stored procedure here
	@inquery nvarchar(max),
	@alpha float,
	@max_outliers int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @s nvarchar(max)

	SET @s =

N'
from scipy import stats
import pandas as pd
import numpy as np

def esd_test(df, max_outliers, alpha):
	""" Perform GESD test
	Parameters
	----------
	df : DataFrame
		DataFrame to calculate GESD from
	max_outliers : int
		Maximum outliers for GESD calculation
	alpha : float
		Alpha error of t-distribution
	"""
	ind = list(InputDataSet["id"])
	x = list(df.values)
	outliers = []
	res_lst = [] # ESD Test Statistic for each k anomaly
	lam_lst = [] # Critical Value for each k anomaly
	n = len(x)
		
	if max_outliers is None:
		max_outliers = len(x)
		
	for i in range(1,max_outliers+1):
		x_mean = np.mean(x)
		x_std = np.std(x,ddof=1)
		res = abs((x - x_mean) / x_std)
		max_res = np.max(res)
		max_ind = np.argmax(res)
		p = 1 - alpha / (2*(n-i+1))
		t_v = stats.t.ppf(p,(n-i-1)) # Get critical values from t-distribution based on p and n
		lam_i = ((n-i)*t_v)/ np.sqrt((n-i-1+t_v**2)*(n-i+1)) # Calculate critical region (lambdas)
		res_lst.append(max_res)
		lam_lst.append(lam_i)
		if max_res > lam_i:
			outliers.append((ind.pop(max_ind),x.pop(max_ind)))
				
	# Record outlier Points
	outliers_index = [x[0] for x in outliers]
	return outliers_index

OutputDataSet = pd.DataFrame(esd_test(InputDataSet["value"], ' + CAST(@max_outliers As nvarchar) + ', ' + CAST(@alpha As nvarchar) + '));
'

	EXECUTE sp_execute_external_script @language = N'Python', @script = @s, @input_data_1 = @inquery
END
GO
PRINT N'Prozedur "[dbo].[import_csv]" wird geändert...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	-
-- =============================================
ALTER PROCEDURE [dbo].[import_csv]
	-- Add the parameters for the stored procedure here
	@strPath VARCHAR(MAX),
	@message BIT OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		DECLARE @sql varchar(max)
		-- DECLARE @csv TABLE(id int, request int, method int, instrument int, keyword nvarchar(max), value_txt nvarchar(max))

		-- Import with universal file format
		SET @sql = '
		BULK INSERT import
		FROM '''+@strPath+''' WITH
		(
			DATAFILETYPE=''char'',
			FIRSTROW=2,
			FIELDTERMINATOR = '','', 
			ROWTERMINATOR = ''\n''
		)
		'
		EXEC (@sql)
		SET @message = 1
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		SET @message = 0
	END CATCH
END
GO
PRINT N'Prozedur "[dbo].[version_be]" wird geändert...';


GO
-- ==================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 June
-- Description:	Used to identify the backend version
-- ==================================================
ALTER PROCEDURE [dbo].[version_be]
	-- Add the parameters for the stored procedure here
	@version_be nvarchar(256) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @version_be = 'v2.9.0'
END
GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_attachment_revision].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "attachment"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 359
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "users"
            Begin Extent = 
               Top = 6
               Left = 442
               Bottom = 136
               Right = 612
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1830
         Width = 1500
         Width = 5340
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_attachment_revision';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_billing_position].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[24] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "billing_position"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "profile"
            Begin Extent = 
               Top = 638
               Left = 433
               Bottom = 768
               Right = 619
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "material"
            Begin Extent = 
               Top = 489
               Left = 436
               Bottom = 619
               Right = 632
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 347
               Left = 437
               Bottom = 475
               Right = 632
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "service"
            Begin Extent = 
               Top = 200
               Left = 436
               Bottom = 330
               Right = 633
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 60
               Left = 436
               Bottom = 190
               Right = 633
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width =', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_billing_position';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_billing_position].[MS_DiagramPane2]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane2', @value = N' 1815
         Width = 2040
         Width = 3105
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 19005
         Alias = 4290
         Table = 5085
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_billing_position';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_labreport_details].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[39] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "measurement"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "technique"
            Begin Extent = 
               Top = 6
               Left = 895
               Bottom = 119
               Right = 1065
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 6
               Left = 479
               Bottom = 136
               Right = 649
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 687
               Bottom = 136
               Right = 857
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_labreport_details';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_labreport_details].[MS_DiagramPane2]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane2', @value = N'1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2895
         Table = 2820
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_labreport_details';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_measurement].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[54] 4[23] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "state"
            Begin Extent = 
               Top = 365
               Left = 994
               Bottom = 495
               Right = 1164
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "request"
            Begin Extent = 
               Top = 264
               Left = 679
               Bottom = 394
               Right = 861
            End
            DisplayFlags = 280
            TopColumn = 18
         End
         Begin Table = "customer"
            Begin Extent = 
               Top = 147
               Left = 996
               Bottom = 277
               Right = 1166
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "measurement"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 346
               Right = 381
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 449
               Left = 570
               Bottom = 579
               Right = 765
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "instrument"
            Begin Extent = 
               Top = 747
               Left = 340
               Bottom = 877
               Right = 515
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 584
               Left = 437
               Bottom = 713
               Right = 607
            End
            Displ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_measurement].[MS_DiagramPane2]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane2', @value = N'ayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1575
         Alias = 2220
         Table = 2805
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_project_owner].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = -1001
      End
      Begin Tables = 
         Begin Table = "project"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 119
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 2205
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_project_owner';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_measurement].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[44] 4[25] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -188
         Left = 0
      End
      Begin Tables = 
         Begin Table = "measurement"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 723
               Right = 490
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 413
               Left = 712
               Bottom = 543
               Right = 907
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "instrument"
            Begin Extent = 
               Top = 572
               Left = 709
               Bottom = 702
               Right = 884
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "technique"
            Begin Extent = 
               Top = 447
               Left = 1158
               Bottom = 721
               Right = 1554
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 268
               Left = 712
               Bottom = 398
               Right = 882
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 528
               Bottom = 136
               Right = 698
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 20
         Width = 284
         Width = 1500
         Width = 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_measurement].[MS_DiagramPane2]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane2', @value = N'500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3375
         Alias = 3270
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_owner].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "request"
            Begin Extent = 
               Top = 12
               Left = 76
               Bottom = 259
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "audit"
            Begin Extent = 
               Top = 12
               Left = 445
               Bottom = 259
               Right = 720
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 27
         Width = 284
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_owner';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_role].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "request"
            Begin Extent = 
               Top = 12
               Left = 76
               Bottom = 671
               Right = 575
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "users"
            Begin Extent = 
               Top = 13
               Left = 1492
               Bottom = 260
               Right = 1767
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "state"
            Begin Extent = 
               Top = 363
               Left = 651
               Bottom = 610
               Right = 926
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "role"
            Begin Extent = 
               Top = 194
               Left = 1083
               Bottom = 441
               Right = 1358
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
En', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_role';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_role].[MS_DiagramPane2]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane2', @value = N'd
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_role';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_task].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[22] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "task"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "project"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 136
               Right = 432
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1470
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 3480
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_task';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_worksheet_details].[MS_DiagramPane1]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[25] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "measurement"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "technique"
            Begin Extent = 
               Top = 6
               Left = 479
               Bottom = 136
               Right = 649
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 6
               Left = 687
               Bottom = 136
               Right = 857
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 895
               Bottom = 136
               Right = 1065
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2745
         Ta', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_worksheet_details';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_worksheet_details].[MS_DiagramPane2]" wird geändert...';


GO
EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane2', @value = N'ble = 4020
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_worksheet_details';


GO
PRINT N'Prozedur "[dbo].[mail_send]" wird aktualisiert...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[mail_send]';


GO
PRINT N'Prozedur "[dbo].[mailqueue_process]" wird aktualisiert...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[mailqueue_process]';


GO
PRINT N'Prozedur "[dbo].[spa_create]" wird aktualisiert...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[spa_create]';


GO
PRINT N'Prozedur "[dbo].[import_perform]" wird aktualisiert...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[import_perform]';


GO
PRINT N'Vorhandene Daten werden auf neu erstellte Einschränkungen hin überprüft.';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[material_hp] WITH CHECK CHECK CONSTRAINT [FK_material_hp];

ALTER TABLE [dbo].[setup] WITH CHECK CHECK CONSTRAINT [CK_setup];


GO
PRINT N'Update abgeschlossen.';


GO
