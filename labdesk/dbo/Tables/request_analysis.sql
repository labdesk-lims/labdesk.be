CREATE TABLE [dbo].[request_analysis] (
    [id]       INT IDENTITY (1, 1) NOT NULL,
    [applies]  BIT CONSTRAINT [DF_request_analysis_applies] DEFAULT ((0)) NOT NULL,
    [analysis] INT NOT NULL,
    [method]   INT NULL,
    [request]  INT NOT NULL,
    CONSTRAINT [PK_request_analysis] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_request_analysis_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]),
    CONSTRAINT [FK_request_analysis_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]),
    CONSTRAINT [FK_request_analysis_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[request_analysis_update] 
   ON  [dbo].[request_analysis]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		DECLARE @request INT, @analysis INT, @method INT, @i INT, @j INT

		SET @request = (SELECT request FROM inserted)
		SET @analysis = (SELECT analysis FROM inserted)
		SET @method = (SELECT method FROM inserted)

		IF (SELECT applies FROM inserted) = 1
		BEGIN
			-- Insert measurments according selected analsis
			EXEC measurement_insert @request, @analysis, @method

			-- Insert dependant analysis if applies
			DECLARE cur CURSOR FOR SELECT analysis_id FROM cfield WHERE analysis = @analysis AND analysis_id IS NOT NULL ORDER BY id
			OPEN cur
			FETCH NEXT FROM cur INTO @i
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC measurement_insert @request, @i
				
				-- Handle any subdependence of analysis service
				IF (SELECT calculation_activate FROM analysis WHERE id = @i) = 1
				BEGIN
					DECLARE cur2 CURSOR FOR SELECT analysis_id FROM cfield WHERE analysis = @i AND analysis_id IS NOT NULL ORDER BY id
					OPEN cur2
					FETCH NEXT FROM cur2 INTO @j
					WHILE @@FETCH_STATUS = 0
					BEGIN
						EXEC measurement_insert @request, @j
						UPDATE request_analysis SET applies = 1 WHERE analysis = @j
						FETCH NEXT FROM cur2 INTO @j
					END
					CLOSE cur2
					DEALLOCATE cur2
				END

				UPDATE request_analysis SET applies = 1 WHERE analysis = @i
				FETCH NEXT FROM cur INTO @i
			END
			CLOSE cur
			DEALLOCATE cur
		END

		-- Retract if unapplied
		IF (SELECT applies FROM inserted) = 0
			UPDATE measurement SET state = 'RT' WHERE request = (SELECT request FROM inserted) AND analysis = (SELECT analysis FROM inserted)
	END
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Audit Log
-- =============================================
CREATE TRIGGER request_analysis_audit
   ON  dbo.request_analysis
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
