CREATE TABLE [dbo].[state] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [title]    VARCHAR (255) NULL,
    [state]    CHAR (2)      NULL,
    [workflow] INT           NOT NULL,
    CONSTRAINT [PK_state] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_state_workflow] FOREIGN KEY ([workflow]) REFERENCES [dbo].[workflow] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[state_insert]
   ON  [dbo].[state]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE cur CURSOR FOR SELECT id FROM state WHERE workflow = (SELECT workflow FROM inserted) ORDER BY id
	DECLARE @i INT
	DECLARE @state CHAR(2)

	SET @state = (SELECT state FROM inserted)
	IF @state <> 'CP' AND @state <> 'RT' AND @state <> 'RC' AND @state <> 'VD' AND @state <> 'MA' AND @state <> 'DP' AND @state <> 'ST' AND @state <> 'DX'
		THROW 51000, 'State unknown.', 1

	OPEN cur
	FETCH NEXT FROM cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO step (step, state) SELECT id, @i FROM state WHERE id NOT IN (SELECT step FROM step WHERE state = @i) AND workflow = (SELECT workflow FROM inserted)
		FETCH NEXT FROM cur INTO @i
	END
	CLOSE cur
	DEALLOCATE cur
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[state_audit]
   ON  [dbo].[state] 
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
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[state_update]
   ON  dbo.state
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @state_inserted CHAR(2), @state_preceding CHAR(2)

	SET @state_inserted = (SELECT state FROM inserted) 
	SET @state_preceding = (SELECT state FROM state WHERE id = (SELECT id FROM inserted) -1)

	-- Check if state is a valid one
	IF @state_inserted <> 'CP' AND @state_inserted <> 'RT' AND @state_inserted <> 'RC' AND @state_inserted <> 'VD' AND @state_inserted <> 'MA' AND @state_inserted <> 'DP' AND @state_inserted <> 'ST' AND @state_inserted <> 'DX'
	RAISERROR (15600, -1, -1, 'State unknown.')

	-- Manage allowed state traversals
	-- -------------------------------------------------------
	-- L1 					  CP
	--                       /  \
	-- L2                   RC  RT -> DX
	--                ______|_______________________
	--                |		|		|		|		|
	-- L3             VD	DP		ST		DX		RT -> DX
	--           _____|_________
	--          |		|		|
	-- L4       MA		ST		DX
	--     _____|____
	--     |		|
	-- L5  ST		DX
	-- -------------------------------------------------------
	-- CP - Captured	RT - Retract	RC - Received
	-- VD - Validated	MA - Mailed		DP - Dispatched
	-- ST - Stored		DX - Disposed
	-- -------------------------------------------------------
		
	-- ---------------------------------------------------
	-- L1 -> L2
	-- ---------------------------------------------------

	-- Only allow states from L2
	IF @state_preceding = 'CP' AND @state_inserted <> 'RC' OR @state_inserted <> 'RT'
		RAISERROR (15600, -1, -1, 'State not valid for L1 -> L2.')

	-- ---------------------------------------------------
	-- L2 -> L3
	-- ---------------------------------------------------
		
	-- Retracted samples only can be disposed
	IF @state_preceding = 'RT' and @state_inserted <> 'RT' OR @state_inserted <> 'DX'
		RAISERROR (15600, -1, -1, 'Retracted samples can not be changed.')

	-- Only allow states from L3
	IF @state_preceding = 'RC' AND @state_inserted <> 'VD' OR @state_inserted <> 'DP' OR  @state_inserted <> 'ST' OR @state_inserted <> 'DX' OR @state_inserted <> 'RT'
		RAISERROR (15600, -1, -1, 'State not valid for L2 -> L3.')

	-- Do not allow to validate request if measurements are unvalidated
	IF @state_inserted = 'VD' AND (SELECT COUNT(*) FROM measurement WHERE request = (SELECT request FROM inserted) AND (state = 'AQ' OR state = 'CP')) > 0
		RAISERROR (15600, -1, -1, 'Validation of request failed. Non validated measurements are found.')

	-- ---------------------------------------------------
	-- L3 - > L4
	-- ---------------------------------------------------

	-- Only allow states from L4
	IF @state_preceding = 'VD' AND @state_inserted <> 'MA' OR @state_inserted <> 'ST' OR @state_inserted <> 'DX'
		RAISERROR (15600, -1, -1, 'State not valid for L3 -> L4.')

	-- ---------------------------------------------------
	-- L4 - > L5
	-- ---------------------------------------------------
		
	-- Only allow states from L5
	IF @state_preceding = 'MA' AND @state_inserted <> 'ST' OR @state_inserted <> 'DX'
		RAISERROR (15600, -1, -1, 'State not valid for L4 -> L5.')
END

GO
DISABLE TRIGGER [dbo].[state_update]
    ON [dbo].[state];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CP - Captured, IM - Intermediate, RJ - Reject, RC - Received, VD - Validated, ML - Mailed, DP - Dispatched, ST - Stored, DX - Disposed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'state', @level2type = N'COLUMN', @level2name = N'title';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CP - Captured, RT - Retract, RC - Received, VD - Validated, MA - Mailed, DP - Dispatched, ST - Stored, DX - Disposed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'state', @level2type = N'COLUMN', @level2name = N'state';

