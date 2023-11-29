CREATE TABLE [dbo].[request_service] (
    [id]      INT            IDENTITY (1, 1) NOT NULL,
    [service] INT            NOT NULL,
    [amount]  INT            CONSTRAINT [DF_request_service_amount] DEFAULT ((0)) NOT NULL,
    [comment] NVARCHAR (MAX) NULL,
    [request] INT            NOT NULL,
    CONSTRAINT [PK_request_service] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_request_service_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_request_service_service] FOREIGN KEY ([service]) REFERENCES [dbo].[service] ([id])
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER request_service_audit 
   ON  request_service
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
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
