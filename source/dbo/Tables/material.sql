CREATE TABLE [dbo].[material] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [cas]         VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [supplier]    INT            NULL,
    [price]       MONEY          CONSTRAINT [DF_material_price] DEFAULT ((0)) NOT NULL,
    [GHS_1]       BIT            CONSTRAINT [DF_material_GHS_1] DEFAULT ((0)) NULL,
    [GHS_2]       BIT            CONSTRAINT [DF_material_GHS_11] DEFAULT ((0)) NULL,
    [GHS_3]       BIT            CONSTRAINT [DF_material_GHS_12] DEFAULT ((0)) NULL,
    [GHS_4]       BIT            CONSTRAINT [DF_material_GHS_13] DEFAULT ((0)) NULL,
    [GHS_5]       BIT            CONSTRAINT [DF_material_GHS_14] DEFAULT ((0)) NULL,
    [GHS_6]       BIT            CONSTRAINT [DF_material_GHS_15] DEFAULT ((0)) NULL,
    [GHS_7]       BIT            CONSTRAINT [DF_material_GHS_16] DEFAULT ((0)) NULL,
    [GHS_8]       BIT            CONSTRAINT [DF_material_GHS_17] DEFAULT ((0)) NULL,
    [GHS_9]       BIT            CONSTRAINT [DF_material_GHS_18] DEFAULT ((0)) NULL,
    [deactivate]  BIT            CONSTRAINT [DF_material_deactivate] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_material] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_material_supplier] FOREIGN KEY ([supplier]) REFERENCES [dbo].[supplier] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[material_audit]
   ON  dbo.material
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END


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