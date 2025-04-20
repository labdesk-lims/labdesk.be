CREATE TABLE [dbo].[request] (
    [id]               INT             IDENTITY (1, 1) NOT NULL,
    [description]      NVARCHAR (MAX)  NULL,
    [photo]            VARBINARY (MAX) NULL,
    [customer]         INT             NULL,
    [cc_email]         NVARCHAR (MAX)  NULL,
    [smp_date]         DATETIME        NULL,
    [smptype]          INT             NULL,
    [smpmatrix]        INT             NULL,
    [smpcontainer]     INT             NULL,
    [smpcondition]     INT             NULL,
    [smppreservation]  INT             NULL,
    [smppoint]         INT             NULL,
    [sampler]          INT             NULL,
    [smp_composit]     BIT             CONSTRAINT [DF_Table_1_composit] DEFAULT ((0)) NOT NULL,
    [client_sample_id] VARCHAR (255)   NULL,
    [client_order_id]  VARCHAR (255)   NULL,
    [priority]         INT             NULL,
    [internal_use]     BIT             CONSTRAINT [DF_Table_1_internal_user] DEFAULT ((0)) NOT NULL,
    [profile]          INT             NULL,
    [project]          INT             NULL,
    [formulation]      INT             NULL,
    [workflow]         INT             NOT NULL,
    [recipients]       NVARCHAR (MAX)  NULL,
    [subject]          NVARCHAR (MAX)  NULL,
    [body]             NVARCHAR (MAX)  NULL,
    [invoice]          BIT             CONSTRAINT [DF_request_exec_invoice] DEFAULT ((0)) NOT NULL,
    [billing_customer] INT             NULL,
    [state]            INT             NULL,
    [subrequest]       INT             NULL,
    CONSTRAINT [PK_request] PRIMARY KEY CLUSTERED ([id] DESC),
    CONSTRAINT [FK_request_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE SET NULL,
    CONSTRAINT [FK_request_contact] FOREIGN KEY ([sampler]) REFERENCES [dbo].[contact] ([id]),
    CONSTRAINT [FK_request_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]),
    CONSTRAINT [FK_request_formulation] FOREIGN KEY ([formulation]) REFERENCES [dbo].[formulation] ([id]),
    CONSTRAINT [FK_request_priority] FOREIGN KEY ([priority]) REFERENCES [dbo].[priority] ([id]),
    CONSTRAINT [FK_request_profile] FOREIGN KEY ([profile]) REFERENCES [dbo].[profile] ([id]),
    CONSTRAINT [FK_request_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]),
    CONSTRAINT [FK_request_smpcondition] FOREIGN KEY ([smpcondition]) REFERENCES [dbo].[smpcondition] ([id]),
    CONSTRAINT [FK_request_smpcontainer] FOREIGN KEY ([smpcontainer]) REFERENCES [dbo].[smpcontainer] ([id]),
    CONSTRAINT [FK_request_smpmatrix] FOREIGN KEY ([smpmatrix]) REFERENCES [dbo].[smpmatrix] ([id]),
    CONSTRAINT [FK_request_smppoint] FOREIGN KEY ([smppoint]) REFERENCES [dbo].[smppoint] ([id]),
    CONSTRAINT [FK_request_smppreservation] FOREIGN KEY ([smppreservation]) REFERENCES [dbo].[smppreservation] ([id]),
    CONSTRAINT [FK_request_smptype] FOREIGN KEY ([smptype]) REFERENCES [dbo].[smptype] ([id]),
    CONSTRAINT [FK_request_state] FOREIGN KEY ([state]) REFERENCES [dbo].[state] ([id]),
    CONSTRAINT [FK_request_workflow] FOREIGN KEY ([workflow]) REFERENCES [dbo].[workflow] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[request_update]
   ON  dbo.request
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @subject NVARCHAR(256)
	DECLARE @body NVARCHAR(MAX)
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @request INT, @method INT, @i INT
	DECLARE @formulation_profile INT

	SET @request = (SELECT id FROM inserted)

	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		-- Check if invoicing is allowed
		IF (SELECT COUNT(*) FROM measurement WHERE (measurement.state = 'CP' OR measurement.state = 'AQ') AND measurement.request = (SELECT id FROM inserted)) > 0 AND (SELECT invoice FROM inserted) = 1
		THROW 51000, 'Invoicing not allowed. Measurements still in progress.', 1

		-- Check if state is allowed
		IF (SELECT state FROM inserted) NOT IN (SELECT step FROM step WHERE state = (SELECT state FROM deleted) AND applies = 1)
			THROW 51000, 'State not valid.', 1

		-- Check if subrequest is valid
		IF (SELECT COUNT(*) FROM request WHERE id = (SELECT subrequest FROM inserted)) < 1 AND (SELECT subrequest FROM inserted) IS NOT NULL
			THROW 51000, 'Invalid subrequest', 1

		-- Check if profile selection is valid
		IF (SELECT deactivate FROM profile WHERE id = (SELECT profile FROM inserted)) = 1
			THROW 51000, 'Profile invalid.', 1

		-- Check if formulation matches profile
		SET @formulation_profile = (SELECT project.profile FROM project INNER JOIN formulation ON (formulation.project = project.id) WHERE formulation.id = (SELECT formulation FROM inserted))
		IF @formulation_profile <> (SELECT profile FROM inserted) AND @formulation_profile IS NOT NULL AND (SELECT formulation FROM inserted) <> (SELECT formulation FROM deleted)
			THROW 51000, 'Invalid formulation.', 1

		-- Check if storage position is set in case of storing a sample
		IF (SELECT state.state FROM request INNER JOIN state ON (state.id = request.state) WHERE request.id = (SELECT id FROM inserted)) = 'ST' AND (SELECT COUNT(*) FROM strposition WHERE request = (SELECT id FROM inserted)) = 0
			THROW 51000, 'Storage position missing.', 1

		-- Check for valid sampling point
		IF (SELECT customer FROM inserted) IS NOT NULL AND (SELECT COUNT(*) FROM smppoint WHERE id = (SELECT smppoint FROM inserted) AND customer <> (SELECT customer FROM inserted) AND customer IS NOT NULL) > 0
			THROW 51000, 'Sampling point not valid for customer.', 1
		IF (SELECT customer FROM inserted) IS NULL AND (SELECT COUNT(*) FROM smppoint WHERE id = (SELECT smppoint FROM inserted) AND customer IS NOT NULL) > 0
			THROW 51000, 'Sampling point is not global.', 1
		
		-- Prevent samples from being disposed if they are still stored
		IF (SELECT state.state FROM request INNER JOIN state ON (state.id = request.state) WHERE request.id = (SELECT id FROM inserted)) = 'DX' AND (SELECT COUNT(*) FROM strposition WHERE request = (SELECT id FROM inserted)) > 0
			THROW 51000, 'Storage position still in place.', 1

		-- Insert all analysis services to table request_analysis
		INSERT INTO request_analysis (analysis, request) SELECT id, (SELECT id FROM inserted) FROM analysis WHERE deactivate = 0 EXCEPT SELECT analysis, request FROM request_analysis

		IF (SELECT profile FROM inserted) IS NOT NULL
		BEGIN
			DECLARE cur CURSOR FOR SELECT analysis FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND applies = 1

			OPEN cur
			FETCH NEXT FROM cur INTO @i
			WHILE @@FETCH_STATUS = 0
			BEGIN
			-- Add profile specific analysis services
			SET @method = (SELECT method FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND analysis = @i)
			EXEC measurement_insert @request, @i, @method
			-- Update request_analysis table with profile analysis services selected
			UPDATE request_analysis SET applies = 1, method = @method WHERE request = @request AND analysis = @i
			-- Update sortkey according profile seetings
			UPDATE measurement SET sortkey = (SELECT sortkey FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND analysis = @i) WHERE request = @request AND analysis = @i
			FETCH NEXT FROM cur INTO @i
			END
			CLOSE cur
			DEALLOCATE cur
		END

		-- Record state traversal date
		IF (SELECT state FROM inserted) <> (SELECT state FROM deleted)
			INSERT INTO traversal (state, traversal_date, traversal_by, request) VALUES((SELECT state FROM inserted), GETDATE(), SUSER_NAME(), (SELECT id FROM inserted))
		
		-- Prepare mail with laboratory report if applies
		--IF (SELECT state FROM state WHERE id = (SELECT state FROM inserted)) = 'MA'
		--BEGIN
		--	SET @sql = 'SELECT @subject = ' + (SELECT language FROM users WHERE name = SUSER_NAME()) + ' FROM translation WHERE container = ''labreport_std'' AND item = ''subject''' 
		--	EXEC sp_executesql @sql, N'@subject nvarchar(max) output', @subject OUT

		--	SET @sql = 'SELECT @body = ' + (SELECT language FROM users WHERE name = SUSER_NAME()) +  ' FROM translation WHERE container = ''labreport_std'' AND item = ''body''' 
		--	EXEC sp_executesql @sql, N'@body nvarchar(max) output', @body OUT
	
		--	INSERT INTO mailqueue (subject, body, request) VALUES(@subject, @body, (SELECT id FROM inserted))
		--END

		-- Prepare mail with retract advice if applies
		--IF (SELECT state FROM state WHERE id = (SELECT state FROM inserted)) = 'RT'
		--BEGIN
		--	SET @sql = 'SELECT @subject = ' + (SELECT language FROM users WHERE name = SUSER_NAME()) + ' FROM translation WHERE container = ''retract_std'' AND item = ''subject''' 
		--	EXEC sp_executesql @sql, N'@subject nvarchar(max) output', @subject OUT

		--	SET @sql = 'SELECT @body = ' + (SELECT language FROM users WHERE name = SUSER_NAME()) +  ' FROM translation WHERE container = ''retract_std'' AND item = ''body''' 
		--	EXEC sp_executesql @sql, N'@body nvarchar(max) output', @body OUT

		--	INSERT INTO mailqueue (subject, body, request) VALUES(@subject, @body, (SELECT id FROM inserted))
		--END
	END
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[request_insert]
   ON  [dbo].[request] 
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @request INT, @method INT, @i INT
	DECLARE @formulation_profile INT

	SET @request = (SELECT id FROM inserted)

	-- Check if invoicing is allowed
	IF (SELECT COUNT(*) FROM measurement WHERE (measurement.state = 'CP' OR measurement.state = 'AQ') AND measurement.request = (SELECT id FROM inserted)) > 0 AND (SELECT invoice FROM inserted) = 1
		THROW 51000, 'Invoicing not allowed. Measurements still in progress.', 1

	-- Check if profile selection is valid
	IF (SELECT deactivate FROM profile WHERE id = (SELECT profile FROM inserted)) = 1 OR (SELECT COUNT(*) FROM profile INNER JOIN strposition ON (profile.reference_material = strposition.id) INNER JOIN material ON (strposition.material = material.id) WHERE profile.id = (SELECT profile FROM inserted) AND profile.use_profile_qc = 1 AND strposition.expiration < GETDATE() AND material.deactivate = 1) > 0
		THROW 51000, 'Profile invalid.', 1

	-- Check if formulation matches profile
	SET @formulation_profile = (SELECT project.profile FROM project INNER JOIN formulation ON (formulation.project = project.id) WHERE formulation.id = (SELECT formulation FROM inserted))
	IF @formulation_profile <> (SELECT profile FROM inserted) AND @formulation_profile IS NOT NULL
		THROW 51000, 'Invalid formulation.', 1

	-- Check if subrequest is valid
	IF (SELECT COUNT(*) FROM request WHERE id = (SELECT subrequest FROM inserted)) < 1 AND (SELECT subrequest FROM inserted) IS NOT NULL
		THROW 51000, 'Invalid subrequest.', 1

	-- Check for valid sampling point
	IF (SELECT customer FROM inserted) IS NOT NULL AND (SELECT COUNT(*) FROM smppoint WHERE id = (SELECT smppoint FROM inserted) AND customer <> (SELECT customer FROM inserted) AND customer IS NOT NULL) > 0
		THROW 51000, 'Sampling point not valid for customer.', 1
	IF (SELECT customer FROM inserted) IS NULL AND (SELECT COUNT(*) FROM smppoint WHERE id = (SELECT smppoint FROM inserted) AND customer IS NOT NULL) > 0
		THROW 51000, 'Sampling point is not global.', 1

	-- Update state to the first relevant one
	UPDATE request SET state = (SELECT TOP 1 id FROM state WHERE workflow = (SELECT workflow FROM inserted)) WHERE id = (SELECT id FROM inserted)

	-- Insert all analysis services to table request_analysis
	INSERT INTO request_analysis (analysis, request) SELECT id, (SELECT id FROM inserted) FROM analysis WHERE deactivate = 0

	IF (SELECT profile FROM inserted) IS NOT NULL
	BEGIN
		DECLARE cur CURSOR FOR SELECT analysis FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND applies = 1

		OPEN cur
		FETCH NEXT FROM cur INTO @i
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Add profile specific analysis services
			SET @method = (SELECT method FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND analysis = @i)
			EXEC measurement_insert @request, @i, @method
			-- Update request_analysis table with profile analysis services selected
			UPDATE request_analysis SET applies = 1, method = @method WHERE request = @request AND analysis = @i
			-- Update sortkey according profile seetings
			UPDATE measurement SET sortkey = (SELECT sortkey FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND analysis = @i) WHERE request = @request AND analysis = @i
			FETCH NEXT FROM cur INTO @i
		END
		CLOSE cur
		DEALLOCATE cur
	END

	-- Assign subrequest to acual id
	UPDATE request SET subrequest = (SELECT id FROM inserted) WHERE id = (SELECT id FROM inserted)

	-- Insert custom fields
	INSERT INTO request_customfield (field_name, request) SELECT field_name, (SELECT id FROM inserted) FROM customfield WHERE table_name = 'request'

	-- Record state traversal date
	INSERT INTO traversal (state, traversal_date, traversal_by, request) VALUES((SELECT TOP 1 id FROM state WHERE workflow = (SELECT workflow FROM inserted)), GETDATE(), SUSER_NAME(), (SELECT id FROM inserted))
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	Delete sub requests
-- =============================================
CREATE TRIGGER request_delete
   ON  dbo.request 
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DELETE FROM request WHERE subrequest = (SELECT id FROM deleted)
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Audit Log
-- =============================================
CREATE TRIGGER [dbo].[request_audit]
   ON  dbo.request
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
