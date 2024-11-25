/*
Bereitstellungsskript für labdesk_v2-5-0

Dieser Code wurde von einem Tool generiert.
Änderungen an dieser Datei führen möglicherweise zu falschem Verhalten und gehen verloren, falls
der Code neu generiert wird.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "labdesk_v2-5-0"
:setvar DefaultFilePrefix "labdesk_v2-5-0"
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
PRINT N'Der Umgestaltungsvorgang mit Umbenennung mit Schlüssel "de9e1acc-8b35-431c-8d71-853c09436f9c" wird übersprungen; das Element "[dbo].[setup].[format_num]" (SqlSimpleColumn) wird nicht in "num_format" umbenannt.';


GO
PRINT N'Der Umgestaltungsvorgang mit Umbenennung mit Schlüssel "a2c82950-859a-4bd4-b850-6a32df402938" wird übersprungen; das Element "[dbo].[setup].[format_culture]" (SqlSimpleColumn) wird nicht in "num_culture" umbenannt.';


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
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_template_deactivate]" wird gelöscht...';


GO
ALTER TABLE [dbo].[template] DROP CONSTRAINT [DF_template_deactivate];


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_profile_template]" wird gelöscht...';


GO
ALTER TABLE [dbo].[template_profile] DROP CONSTRAINT [FK_template_profile_template];


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_customer]" wird gelöscht...';


GO
ALTER TABLE [dbo].[template] DROP CONSTRAINT [FK_template_customer];


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_customer1]" wird gelöscht...';


GO
ALTER TABLE [dbo].[template] DROP CONSTRAINT [FK_template_customer1];


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_priority]" wird gelöscht...';


GO
ALTER TABLE [dbo].[template] DROP CONSTRAINT [FK_template_priority];


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_workflow]" wird gelöscht...';


GO
ALTER TABLE [dbo].[template] DROP CONSTRAINT [FK_template_workflow];


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
    [num_format]      NCHAR (1)     DEFAULT 'G' NOT NULL,
    [num_culture]     NCHAR (5)     DEFAULT 'de-de' NOT NULL,
    [version_fe]      VARCHAR (255) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_configuration1] PRIMARY KEY CLUSTERED ([id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[setup])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_setup] ON;
        INSERT INTO [dbo].[tmp_ms_xx_setup] ([id], [email_profile], [alert_document], [show_desktop], [verbous], [vat], [upload_max_byte], [version_fe])
        SELECT   [id],
                 [email_profile],
                 [alert_document],
                 [show_desktop],
                 [verbous],
                 [vat],
                 [upload_max_byte],
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
PRINT N'Das erneute Erstellen der Tabelle "[dbo].[template]" wird gestartet....';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_template] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [customer]        INT            NOT NULL,
    [title]           VARCHAR (255)  NULL,
    [description]     NVARCHAR (MAX) NULL,
    [client_order_id] VARCHAR (255)  NULL,
    [priority]        INT            NOT NULL,
    [workflow]        INT            NOT NULL,
    [report_template] VARCHAR (255)  NULL,
    [deactivate]      BIT            CONSTRAINT [DF_template_deactivate] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_template1] PRIMARY KEY CLUSTERED ([id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[template])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_template] ON;
        INSERT INTO [dbo].[tmp_ms_xx_template] ([id], [customer], [title], [description], [priority], [workflow], [report_template], [deactivate])
        SELECT   [id],
                 [customer],
                 [title],
                 [description],
                 [priority],
                 [workflow],
                 [report_template],
                 [deactivate]
        FROM     [dbo].[template]
        ORDER BY [id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_template] OFF;
    END

DROP TABLE [dbo].[template];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_template]', N'template';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_template1]', N'PK_template', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_profile_template]" wird erstellt...';


GO
ALTER TABLE [dbo].[template_profile] WITH NOCHECK
    ADD CONSTRAINT [FK_template_profile_template] FOREIGN KEY ([template]) REFERENCES [dbo].[template] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[template] WITH NOCHECK
    ADD CONSTRAINT [FK_template_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_customer1]" wird erstellt...';


GO
ALTER TABLE [dbo].[template] WITH NOCHECK
    ADD CONSTRAINT [FK_template_customer1] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_priority]" wird erstellt...';


GO
ALTER TABLE [dbo].[template] WITH NOCHECK
    ADD CONSTRAINT [FK_template_priority] FOREIGN KEY ([priority]) REFERENCES [dbo].[priority] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_template_workflow]" wird erstellt...';


GO
ALTER TABLE [dbo].[template] WITH NOCHECK
    ADD CONSTRAINT [FK_template_workflow] FOREIGN KEY ([workflow]) REFERENCES [dbo].[workflow] ([id]);


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
PRINT N'Trigger "[dbo].[template_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2025 May
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[template_audit] 
   ON  dbo.template 
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
PRINT N'Trigger "[dbo].[analysis_insert_update]" wird geändert...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
ALTER TRIGGER [dbo].[analysis_insert_update]
   ON  dbo.analysis
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT deactivate FROM inserted) = 1 AND (SELECT COUNT(id) FROM method_analysis WHERE applies = 1 AND analysis = (SELECT (id) FROM inserted)) > 0
		THROW 51000, 'Deactivation failed. Analysis is still in use.', 1

	-- Update instrument_method and method_analysis cross table
	DECLARE @id INT

	SET @id = (SELECT id FROM inserted)

	IF NOT EXISTS (SELECT id FROM deleted)
	BEGIN
		INSERT INTO method_analysis (method, analysis) SELECT id, @id FROM method WHERE id NOT IN (SELECT method FROM method_analysis WHERE analysis = @id) AND deactivate = 0
		INSERT INTO profile_analysis (profile, analysis) SELECT DISTINCT profile.id, @id FROM analysis LEFT JOIN profile ON (profile.id <> 0)
	END

	IF (SELECT calculation_activate FROM inserted) = 1 AND (SELECT calculation FROM inserted) IS NULL
		THROW 51000, 'Activation failed. Calculation not found.', 1

	IF (SELECT ldl FROM inserted) > (SELECT udl FROM inserted)
		THROW 51000,  'LDL bigger than UDL.', 1

	IF (SELECT precision FROM inserted) < 0
		THROW 51000,  'Precision must be zero or bigger.', 1

	IF (SELECT type FROM inserted) <> 'N' AND (SELECT type FROM inserted) <> 'A' AND (SELECT type FROM inserted) <> 'T'
		THROW 51000,  'Type unknown.', 1
END
GO
PRINT N'Trigger "[dbo].[measurement_update]" wird geändert...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
ALTER TRIGGER [dbo].[measurement_update]
   ON  [dbo].[measurement]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @request INT, @analysis INT, @method INT, @instrument INT
	DECLARE @message NVARCHAR(MAX)
	DECLARE @value_changed BIT
	DECLARE @profile INT
	DECLARE @lsl FLOAT
	DECLARE @usl FLOAT
	DECLARE @lsl_include BIT
	DECLARE @usl_include BIT
	DECLARE @num_format NCHAR(1)
	DECLARE @num_culture NCHAR(5)

	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		SET @num_format = (SELECT TOP 1 num_format FROM setup)
		SET @num_culture = (SELECT TOP 1 num_culture FROM setup)

		SET @request = (SELECT request FROM deleted)
		SET @analysis = (SELECT analysis FROM deleted)

		-- Set value changed bit
		IF (SELECT value_txt FROM inserted) <> (SELECT value_txt FROM deleted) OR (SELECT value_num FROM inserted) <> (SELECT value_num FROM deleted) OR ((SELECT value_num FROM inserted) IS NOT NULL AND (SELECT value_num FROM deleted) IS NULL) OR (((SELECT value_txt FROM inserted) IS NOT NULL AND (SELECT value_txt FROM deleted) IS NULL))
			SET @value_changed = 1
		ELSE
			SET @value_changed = 0
		
		-- Prevent forbidden state traversals
		IF (SELECT state FROM inserted) <> (SELECT state FROM deleted)
		BEGIN
			IF (SELECT state FROM inserted) = 'CP'
				THROW 51000, 'State change not allowed.', 1
			IF (SELECT state FROM deleted) = 'RT' OR (SELECT state FROM deleted) = 'RE'
				THROW 51000, 'State change not allowed.', 1
		END

		-- Prevent unwanted column changes
		IF (SELECT state FROM deleted) <> 'CP' AND (SELECT calculation_activate FROM analysis WHERE id = (SELECT analysis FROM inserted)) = 0
		BEGIN
			UPDATE measurement SET request = (SELECT request FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET analysis = (SELECT analysis FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET method = (SELECT method FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET instrument = (SELECT instrument FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET value_txt = (SELECT value_txt FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET value_num = (SELECT value_num FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET uncertainty = (SELECT uncertainty FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET out_of_range = (SELECT out_of_range FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET not_detectable = (SELECT not_detectable FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET acquired_by = (SELECT acquired_by FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET acquired_at = (SELECT acquired_at FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET validated_by = (SELECT validated_by FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET validated_at = (SELECT validated_at FROM deleted) WHERE id = (SELECT id FROM inserted)
		END

		-- Capture case
		IF (SELECT state FROM deleted) = 'CP' OR (SELECT calculation_activate FROM analysis WHERE id = (SELECT analysis FROM inserted)) = 1
		BEGIN
			IF (SELECT method FROM inserted) IS NOT NULL
			BEGIN
				-- Check validity of method
				IF (SELECT method FROM inserted) NOT IN (SELECT method FROM method_analysis WHERE method = (SELECT method FROM inserted) AND analysis = (SELECT analysis FROM inserted) AND applies =1) AND (SELECT method FROM inserted) IS NOT NULL
					THROW 51000, 'Method not valid.', 1
				-- Check qualification of user
				IF (SELECT method FROM inserted) NOT IN (SELECT method FROM qualification WHERE method = (SELECT method FROM inserted) AND valid_from <= GETDATE() AND valid_till >= GETDATE() AND withdraw = 0 AND user_id = (SELECT id FROM users WHERE name = SUSER_NAME()))
					THROW 51000, 'User not qualified to acquire data using this method.', 1
				END

			IF (SELECT instrument FROM inserted) IS NOT NULL
			BEGIN
				-- Check validity of instrument
				IF (SELECT instrument FROM inserted) NOT IN (SELECT instrument FROM instrument_method WHERE method = (SELECT method FROM inserted) AND applies =1) AND (SELECT instrument FROM inserted) IS NOT NULL AND (SELECT method FROM inserted) IS NOT NULL
					THROW 51000, 'Instrument not valid.', 1
				-- Check certificate of instrument
				IF (SELECT instrument FROM inserted) NOT IN (SELECT instrument FROM certificate WHERE valid_from <= GETDATE() AND valid_till >= GETDATE() AND withdraw = 0 AND instrument = (SELECT instrument FROM inserted))
					THROW 51000, 'Instrument has no valid certificate.', 1
			END

			-- Update the state
			--IF (SELECT state FROM deleted) = 'CP'
			--	UPDATE measurement SET state = 'AQ' WHERE id = (SELECT id FROM inserted)

			-- Determine out of range results
			IF (SELECT value_num FROM inserted) > (SELECT udl FROM analysis WHERE id = (SELECT analysis FROM inserted)) OR (SELECT value_num FROM inserted) < (SELECT ldl FROM analysis WHERE id = (SELECT analysis FROM inserted))
				UPDATE measurement SET out_of_range = 1 WHERE id = (SELECT id FROM inserted)
			ELSE
				UPDATE measurement SET out_of_range = 0 WHERE id = (SELECT id FROM inserted)

			-- Determine out of specification results
			SET @profile = (SELECT request.profile FROM request INNER JOIN measurement ON (request.id = measurement.request) WHERE measurement.id = (SELECT id FROM inserted))
			IF @profile IS NOT NULL AND (SELECT tsl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) IS NULL
			BEGIN
				IF (SELECT value_num FROM inserted) >= (SELECT usl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) AND (SELECT usl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) = 0
				BEGIN
					UPDATE measurement SET out_of_spec = 1 WHERE id = (SELECT id FROM inserted)
				END
				IF (SELECT value_num FROM inserted) > (SELECT usl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) AND (SELECT usl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) = 1
				BEGIN
					UPDATE measurement SET out_of_spec = 1 WHERE id = (SELECT id FROM inserted)
				END
				IF (SELECT value_num FROM inserted) <= (SELECT lsl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) AND (SELECT lsl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) = 0
				BEGIN
					UPDATE measurement SET out_of_spec = 1 WHERE id = (SELECT id FROM inserted)
				END
				IF (SELECT value_num FROM inserted) < (SELECT lsl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) AND (SELECT lsl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) = 1
				BEGIN
					UPDATE measurement SET out_of_spec = 1 WHERE id = (SELECT id FROM inserted)
				END
			END

			-- Determine valid accreditation
			IF (SELECT COUNT(id) FROM method_smptype WHERE method = (SELECT method FROM inserted) AND applies = 1) > 0
			BEGIN
				UPDATE measurement SET accredited = 1 WHERE id = (SELECT id FROM inserted)
			END

			-- Determine uncertainty
			UPDATE measurement SET uncertainty = (SELECT uncertainty FROM uncertainty WHERE value_min <= (SELECT value_num FROM inserted) AND value_max > (SELECT value_num FROM inserted) AND analysis = (SELECT analysis FROM inserted)) WHERE id = (SELECT id FROM inserted)

			-- Set unit
			UPDATE measurement SET unit = (SELECT unit FROM analysis WHERE id = (SELECT analysis FROM inserted)) WHERE id = (SELECT id FROM inserted)

			-- Set date and user who acquired the value
			UPDATE measurement SET acquired_by = SUSER_NAME() WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET acquired_at = GETDATE() WHERE id = (SELECT id FROM inserted)

			-- Set value_txt in case of attribute results
			IF (SELECT type FROM analysis WHERE id = (SELECT analysis FROM inserted)) = 'A'
			BEGIN
				UPDATE measurement SET value_txt= (SELECT attribute.title FROM attribute INNER JOIN analysis ON (attribute.analysis = analysis.id) WHERE attribute.value = (SELECT value_num FROM inserted) AND attribute.analysis = (SELECT analysis FROM inserted)) WHERE id = (SELECT id FROM inserted)
			END

			-- Set value_txt in case of numeric values
			IF (SELECT type FROM analysis WHERE id = (SELECT analysis FROM inserted)) = 'N'
			BEGIN
				UPDATE measurement SET value_txt = FORMAT(ROUND((SELECT value_num FROM inserted), (SELECT precision FROM analysis WHERE id = (SELECT analysis FROM inserted))), @num_format, @num_culture) WHERE id = (SELECT id FROM inserted)
			END

			-- Check for qc measurement and block instrument in case of out of control event
			SET @lsl = (SELECT lsl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted))
			SET @usl = (SELECT usl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted))
			SET @lsl_include = (SELECT lsl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted))
			SET @usl_include = (SELECT usl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted))

			IF @profile IS NOT NULL AND (SELECT use_profile_qc FROM profile WHERE id = @profile) = 1
			BEGIN
				IF (@lsl > (SELECT value_num FROM inserted) AND @lsl IS NOT NULL) OR (@usl < (SELECT value_num FROM inserted) AND @usl IS NOT NULL) OR (@lsl >= (SELECT value_num FROM inserted) AND @lsl IS NOT NULL AND @lsl_include = 1) OR (@usl <= (SELECT value_num FROM inserted) AND @usl IS NOT NULL AND @usl_include = 1)
					IF (SELECT instrument FROM inserted) IS NOT NULL
						UPDATE certificate SET withdraw = 1 WHERE instrument = (SELECT instrument FROM inserted)
			END

			-- Check for expired reference materials
			--IF (SELECT COUNT(*) AS cnt FROM (profile INNER JOIN strposition ON profile.reference_material = strposition.id) INNER JOIN material ON strposition.material = material.id WHERE material.deactivate=1 OR strposition.expiration < GETDATE() AND  profile.id = @profile) > 0
			IF (SELECT COUNT(*) AS cnt FROM profile INNER JOIN profile_analysis ON profile_analysis.profile = profile.id INNER JOIN strposition ON profile.reference_material = strposition.id INNER JOIN material ON strposition.material = material.id WHERE material.deactivate=1 OR strposition.expiration < GETDATE() AND profile_analysis.applies = 1 AND profile.id = @profile AND profile_analysis.analysis = @analysis) > 0
				THROW 51000, 'Reference material expired.', 1
		END

		-- Create a new measurement if retest is chosen
		IF (SELECT state FROM inserted) = 'RE' AND (SELECT state FROM deleted) <> 'CP' EXEC measurement_insert @request, @analysis

		-- Allow to retract at any time
		IF (SELECT state FROM inserted) = 'RT'
		BEGIN
			UPDATE measurement SET state = 'RT' WHERE id = (SELECT id FROM inserted)
			UPDATE request_analysis SET applies = 0 WHERE request = @request AND analysis = @analysis
		END

		-- Allow to valdiate if state is AQ
		IF (SELECT state FROM inserted) = 'VD' AND (SELECT state FROM deleted) = 'AQ'
		BEGIN
			UPDATE measurement SET validated_by = SUSER_NAME() WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET validated_at = GETDATE() WHERE id = (SELECT id FROM inserted)
		END
	END
END
GO
PRINT N'Sicht "[dbo].[view_attachment_revision]" wird aktualisiert...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[view_attachment_revision]';


GO
PRINT N'Sicht "[dbo].[view_request_role]" wird erstellt...';


GO
CREATE VIEW dbo.view_request_role
AS
SELECT dbo.request.*, dbo.users.name
FROM  dbo.role INNER JOIN
         dbo.users ON dbo.role.id = dbo.users.role INNER JOIN
         dbo.request INNER JOIN
         dbo.state ON dbo.request.state = dbo.state.id ON dbo.role.id = dbo.state.role
WHERE (dbo.users.name = SUSER_SNAME())
GO
PRINT N'Prozedur "[dbo].[template_duplicate]" wird geändert...';


GO
-- =============================================
-- Create date: 2024 October
-- Description:	Duplicate template
-- =============================================
ALTER PROCEDURE [dbo].[template_duplicate]
	@pTemplate As INT
AS
BEGIN
	DECLARE @id_keys table([id] INT)
	DECLARE @id INT

	INSERT INTO template (customer, title, description, priority, workflow, report_template, client_order_id, deactivate) OUTPUT inserted.id INTO @id_keys VALUES((SELECT customer FROM template WHERE id = @pTemplate), (SELECT title FROM template WHERE id = @pTemplate) + '_duplicate', (SELECT description FROM template WHERE id = @pTemplate), (SELECT priority FROM template WHERE id = @pTemplate), (SELECT workflow FROM template WHERE id = @pTemplate), (SELECT report_template FROM template WHERE id = @pTemplate), (SELECT client_order_id FROM template WHERE id = @pTemplate), 1)

	SET @id = (SELECT TOP 1 id FROM @id_keys)

	INSERT INTO template_profile (template, profile, priority, workflow, smppoint) (SELECT @id, profile, priority,workflow, smppoint FROM template_profile WHERE template = @pTemplate)
END
GO
PRINT N'Prozedur "[dbo].[template_run]" wird geändert...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Create audit trail from record
-- =============================================
ALTER PROCEDURE [dbo].[template_run]
	-- Add the parameters for the stored procedure here
	@template INT,
	@priority INT,
	@workflow INT,
	@client_order_id VARCHAR (255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @id INT = NULL
	DECLARE @i INT

	INSERT INTO request (description, customer, priority, workflow, client_order_id) VALUES ((SELECT '[' + SUSER_NAME() + '] ' + convert(nvarchar(max), (SELECT SYSDATETIME()))), (SELECT customer FROM template WHERE id = @template), @priority, @workflow, @client_order_id)

	SET @id = SCOPE_IDENTITY()

	UPDATE request SET subrequest = NULL WHERE id = @id

	BEGIN
		DECLARE tmpl CURSOR FOR SELECT template_profile.id FROM template INNER JOIN template_profile ON (template.id = template_profile.template) WHERE template.id = (@template)

		OPEN tmpl
		FETCH NEXT FROM tmpl INTO @i
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO request (customer, priority, profile, workflow, smppoint) SELECT customer, template_profile.priority, template_profile.profile, template_profile.workflow, template_profile.smppoint FROM template INNER JOIN template_profile ON (template.id = template_profile.template) WHERE template_profile.id = @i
			UPDATE request SET subrequest = @id WHERE id = SCOPE_IDENTITY()
			FETCH NEXT FROM tmpl INTO @i
		END
		CLOSE tmpl
		DEALLOCATE tmpl
	END
END
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
PRINT N'Prozedur "[dbo].[report_horizontal]" wird geändert...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2024 September
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[report_horizontal]
	-- Add the parameters for the stored procedure here
	@request INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE analysis_cur CURSOR FOR SELECT analysis.id FROM analysis WHERE analysis.id IN (SELECT measurement.analysis FROM request INNER JOIN measurement ON (measurement.request = request.id) WHERE request = @request OR subrequest = @request) ORDER BY analysis.sortkey
	DECLARE request_cur CURSOR FOR SELECT request.id FROM request WHERE request.subrequest = @request
	DECLARE @q1 NVARCHAR(MAX)
	DECLARE @q2 NVARCHAR(MAX)
	DECLARE @q3 NVARCHAR(MAX)
	DECLARE @q4 NVARCHAR(MAX)
	DECLARE @q5 NVARCHAR(MAX)
	DECLARE @i INT
	DECLARE @j INT
	DECLARE @s NVARCHAR(MAX)
	DECLARE @p NVARCHAR(MAX)
	DECLARE @language VARCHAR(32)

	-- Get the language setting for acutal user
	SET @language = (SELECT language FROM users WHERE name = ORIGINAL_LOGIN())

	-- Create horizontal table for measurement values
	SET @q1 = 'CREATE TABLE ##t (# NVARCHAR(MAX),'
	
	-- Build the query to create the table
	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @q1 = @q1 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ' NVARCHAR(MAX),'
			FETCH NEXT FROM analysis_cur INTO @i
		END
	SET @q1 = LEFT(@q1, LEN(@q1)-1) + ')'
	CLOSE analysis_cur
	PRINT @q1
	-- Create table by executing query
	EXEC (@q1)

	-- Build the query to insert the analysis services
	SET @s = N'SELECT @s = ' + @language + ' FROM translation WHERE container = ' + '''' + 'analysis' + '''' + ' AND item = ' + '''' + 'caption_' + ''''
	EXEC sp_executesql @query = @s,  @params = N'@s NVARCHAR(MAX) OUTPUT', @s = @s output
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + ISNULL(@s, '') + '''' + ','

	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT TOP 1 analysis.title FROM analysis WHERE analysis.id = @i)
			SET @q2 = @q2 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
			SET @q3 = @q3 + '''' + ISNULL(@s,'') + '''' + ','
			FETCH NEXT FROM analysis_cur INTO @i
		END
	SET @q2 = LEFT(@q2, LEN(@q2)-1) + ') VALUES'
	SET @q3 = LEFT(@q3, LEN(@q3)-1) + ')'
	CLOSE analysis_cur

	-- Execute query to insert the analysis services
	EXEC (@q2 + @q3)

	-- Create an insert query for units
	SET @s = N'SELECT @s = ' + @language + ' FROM translation WHERE container = ' + '''' + 'analysis' + '''' + ' AND item = ' + '''' + 'unit_' + ''''
	EXEC sp_executesql @query = @s,  @params = N'@s NVARCHAR(MAX) OUTPUT', @s = @s output
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + ISNULL(@s, '') + '''' + ','

	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT analysis.unit FROM analysis WHERE analysis.id = @i)
			SET @q2 = @q2 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
			SET @q3 = @q3 + '''' + ISNULL(@s,'') + '''' + ','
			FETCH NEXT FROM analysis_cur INTO @i
		END
	SET @q2 = LEFT(@q2, LEN(@q2)-1) + ') VALUES'
	SET @q3 = LEFT(@q3, LEN(@q3)-1) + ')'
	CLOSE analysis_cur
	
	-- Insert values
	EXEC (@q2 + @q3)

	-- Create an insert query for measurement values
	SET @s = ''
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + @s + '''' + ','

	OPEN request_cur
	FETCH NEXT FROM request_cur INTO @j
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			-- Create an insert query for inserting values
			SET @p = (SELECT smppoint.title FROM request INNER JOIN smppoint ON (smppoint.id = request.smppoint) WHERE request.id = @j)
			SET @q4 = 'INSERT INTO ##t (#,'
			SET @q5 = '(' + '''' + @p + '''' + ','

			OPEN analysis_cur
			FETCH NEXT FROM analysis_cur INTO @i
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @p = (
					SELECT dbo.measurement.value_txt + IIF(dbo.measurement.out_of_spec = '', '', ' *') 
					FROM dbo.measurement INNER JOIN
                         dbo.analysis ON dbo.measurement.analysis = dbo.analysis.id LEFT OUTER JOIN
                         dbo.instrument ON dbo.measurement.instrument = dbo.instrument.id LEFT OUTER JOIN
                         dbo.technique ON dbo.analysis.technique = dbo.technique.id LEFT OUTER JOIN
                         dbo.method ON dbo.measurement.method = dbo.method.id LEFT OUTER JOIN
                             (SELECT        dbo.request.id, dbo.profile_analysis.analysis, dbo.profile_analysis.tsl, CONVERT(float, dbo.audit_get_value('profile_analysis', dbo.profile_analysis.id, 'lsl', dbo.audit_get_first('request', dbo.request.id))) AS lsl, 
                                                         CONVERT(float, dbo.audit_get_value('profile_analysis', dbo.profile_analysis.id, 'usl', dbo.audit_get_first('request', dbo.request.id))) AS usl
                               FROM            dbo.request INNER JOIN
                                                         dbo.profile ON dbo.request.profile = dbo.profile.id INNER JOIN
                                                         dbo.profile_analysis ON dbo.profile_analysis.profile = dbo.profile.id
                               WHERE        (dbo.profile_analysis.applies = 1)) AS t ON t.analysis = dbo.measurement.analysis AND dbo.measurement.request = t.id
					WHERE        (dbo.measurement.request = @j) AND (dbo.analysis.id = @i) AND state = 'VD'
					)
					SET @q4 = @q4 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
					SET @q5 = @q5 + '''' + ISNULL(@p,'') + '''' + ','
					FETCH NEXT FROM analysis_cur INTO @i
				END
			SET @q4 = LEFT(@q4, LEN(@q4)-1) + ') VALUES'
			SET @q5 = LEFT(@q5, LEN(@q5)-1) + ')'

			-- Insert values
			EXEC (@q4 + @q5)
			CLOSE analysis_cur
			

			FETCH NEXT FROM request_cur INTO @j
		END
	CLOSE request_cur

	-- Return table
	SELECT * FROM ##t

	-- Cleanup tables and cursors
	DROP TABLE ##t
	DEALLOCATE analysis_cur
	DEALLOCATE request_cur
END
GO
PRINT N'Prozedur "[dbo].[report_horizontal_profile]" wird geändert...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2024 September
-- Description:	Horizontal profile table
-- =============================================
ALTER PROCEDURE [dbo].[report_horizontal_profile]
	-- Add the parameters for the stored procedure here
	@request INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE analysis_cur CURSOR FOR SELECT DISTINCT profile_analysis.analysis, analysis.sortkey FROM profile_analysis INNER JOIN profile ON (profile.id = profile_analysis.profile) INNER JOIN analysis ON (analysis.id = profile_analysis.analysis) WHERE profile_analysis.applies = 1 AND profile.id IN (SELECT profile FROM request WHERE subrequest = @request) ORDER BY analysis.sortkey
	DECLARE profile_cur CURSOR FOR SELECT request.profile FROM request WHERE subrequest = @request
	DECLARE @q1 NVARCHAR(MAX)
	DECLARE @q2 NVARCHAR(MAX)
	DECLARE @q3 NVARCHAR(MAX)
	DECLARE @q4 NVARCHAR(MAX)
	DECLARE @q5 NVARCHAR(MAX)
	DECLARE @i INT
	DECLARE @j INT
	DECLARE @d INT
	DECLARE @s NVARCHAR(MAX)
	DECLARE @p NVARCHAR(MAX)
	DECLARE @a1 NVARCHAR(MAX)
	DECLARE @a2 NVARCHAR(MAX)
	DECLARE @min float
	DECLARE @max float
	DECLARE @min_inc float
	DECLARE @max_inc float
	DECLARE @language VARCHAR(32)

	-- Get the language setting for acutal user
	SET @language = (SELECT language FROM users WHERE name = ORIGINAL_LOGIN())

	-- Create horizontal table for measurement values
	SET @q1 = 'CREATE TABLE ##t (# NVARCHAR(MAX),'
	
	-- Build the query to create the table
	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i, @d
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @q1 = @q1 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ' NVARCHAR(MAX),'
			FETCH NEXT FROM analysis_cur INTO @i, @d
		END
	SET @q1 = LEFT(@q1, LEN(@q1)-1) + ')'
	CLOSE analysis_cur
	
	-- Create table by executing query
	EXEC (@q1)

	-- Build the query to insert the analysis services
	SET @s = N'SELECT @s = ' + @language + ' FROM translation WHERE container = ' + '''' + 'analysis' + '''' + ' AND item = ' + '''' + 'caption_' + ''''
	EXEC sp_executesql @query = @s,  @params = N'@s NVARCHAR(MAX) OUTPUT', @s = @s output
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + ISNULL(@s, '') + '''' + ','

	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i, @d
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT TOP 1 analysis.title FROM analysis WHERE analysis.id = @i)
			SET @q2 = @q2 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
			SET @q3 = @q3 + '''' + ISNULL(@s,'') + '''' + ','
			FETCH NEXT FROM analysis_cur INTO @i, @d
		END
	SET @q2 = LEFT(@q2, LEN(@q2)-1) + ') VALUES'
	SET @q3 = LEFT(@q3, LEN(@q3)-1) + ')'
	CLOSE analysis_cur

	-- Execute query to insert the analysis services
	EXEC (@q2 + @q3)
	
	-- Create an insert query for units
	SET @s = N'SELECT @s = ' + @language + ' FROM translation WHERE container = ' + '''' + 'analysis' + '''' + ' AND item = ' + '''' + 'unit_' + ''''
	EXEC sp_executesql @query = @s,  @params = N'@s NVARCHAR(MAX) OUTPUT', @s = @s output
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + ISNULL(@s, '') + '''' + ','

	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i, @d
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT analysis.unit FROM analysis WHERE analysis.id = @i)
			SET @q2 = @q2 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
			SET @q3 = @q3 + '''' + ISNULL(@s,'') + '''' + ','
			FETCH NEXT FROM analysis_cur INTO @i, @d
		END
	SET @q2 = LEFT(@q2, LEN(@q2)-1) + ') VALUES'
	SET @q3 = LEFT(@q3, LEN(@q3)-1) + ')'
	CLOSE analysis_cur
	
	-- Insert values
	EXEC (@q2 + @q3)

	-- Create an insert query for measurement values
	SET @s = ''
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + @s + '''' + ','

	OPEN profile_cur
	FETCH NEXT FROM profile_cur INTO @j
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			-- Create an insert query for inserting values
			SET @p = (SELECT profile.title FROM profile WHERE profile.id = @j)
			SET @q4 = 'INSERT INTO ##t (#,'
			SET @q5 = '(' + '''' + @p + '''' + ','

			OPEN analysis_cur
			FETCH NEXT FROM analysis_cur INTO @i, @d
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @min = (SELECT profile_analysis.lsl FROM profile_analysis WHERE profile_analysis.analysis = @i AND profile_analysis.profile = @j)
					SET @max = (SELECT profile_analysis.usl FROM profile_analysis WHERE profile_analysis.analysis = @i AND profile_analysis.profile = @j)
					SET @min_inc = (SELECT profile_analysis.lsl_include FROM profile_analysis WHERE profile_analysis.analysis = @i AND profile_analysis.profile = @j)
					SET @max_inc = (SELECT profile_analysis.usl_include FROM profile_analysis WHERE profile_analysis.analysis = @i AND profile_analysis.profile = @j)

					IF (SELECT COUNT(*) FROM analysis WHERE analysis.type ='A' AND analysis.id = @i) > 0
					BEGIN
						SET @a1 = (SELECT attribute.title FROM attribute WHERE attribute.analysis = @i AND attribute.value = @min)
						SET @a2 = (SELECT attribute.title FROM attribute WHERE attribute.analysis = @i AND attribute.value = @max)
						SET @p = IIF(@min = @max, @a1, IIF(@min IS NULL, '', IIF(@min_inc = 1, '>=', '>') + @s) + IIF(@min IS NULL OR @max IS NULL, '', ' ... ') + IIF(@max IS NULL, '', IIF(@max_inc = 1, '<=', '<') + @s))
						SET @q4 = @q4 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
						SET @q5 = @q5 + '''' + ISNULL(@p,'') + '''' + ','
					END
					IF (SELECT COUNT(*) FROM analysis WHERE analysis.type ='A' AND analysis.id = @i) = 0
					BEGIN
						SET @p = IIF(@min = @max, CONVERT(VARCHAR(MAX), @min), IIF(@min IS NULL, '', IIF(@min_inc = 1, '>=', '>') + CONVERT(VARCHAR(MAX), @min)) + IIF(@min IS NULL OR @max IS NULL, '', ' ... ') + IIF(@max IS NULL, '', IIF(@max_inc = 1, '<=', '<') + CONVERT(VARCHAR(MAX), @max)))
						SET @q4 = @q4 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
						SET @q5 = @q5 + '''' + ISNULL(@p,'') + '''' + ','
					END
					FETCH NEXT FROM analysis_cur INTO @i, @d
				END
			SET @q4 = LEFT(@q4, LEN(@q4)-1) + ') VALUES'
			SET @q5 = LEFT(@q5, LEN(@q5)-1) + ')'

			-- Insert values
			EXEC (@q4 + @q5)
			CLOSE analysis_cur
			

			FETCH NEXT FROM profile_cur INTO @j
		END
	CLOSE profile_cur

	-- Return table
	SELECT * FROM ##t

	-- Cleanup tables and cursors
	DROP TABLE ##t
	DEALLOCATE analysis_cur
	DEALLOCATE profile_cur
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
	SET @version_be = 'v2.6.0'
END
GO
PRINT N'Prozedur "[dbo].[profile_duplicate]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2024 November
-- Description:	Duplicate profile
-- =============================================
CREATE PROCEDURE profile_duplicate
	-- Add the parameters for the stored procedure here
	@pProfile As INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @id_keys table([id] INT)
	DECLARE @id INT

	INSERT INTO profile (title, description, use_profile_qc, reference_material, report_template, customer, price, deactivate) OUTPUT inserted.id INTO @id_keys VALUES((SELECT title FROM profile WHERE id = @pProfile) + '_duplicate', (SELECT description FROM profile WHERE id = @pProfile), (SELECT use_profile_qc FROM profile WHERE id = @pProfile), (SELECT reference_material FROM profile WHERE id = @pProfile), 
	
	(SELECT report_template FROM profile WHERE id = @pProfile), (SELECT customer FROM profile WHERE id = @pProfile), (SELECT price FROM profile WHERE id = @pProfile), 1)

	SET @id = (SELECT TOP 1 id FROM @id_keys)

	INSERT INTO profile_analysis (profile, analysis, method, sortkey, applies, true_value, acceptance, tsl, lsl, lsl_include, usl, usl_include) (SELECT @id, analysis, method, sortkey, applies, true_value, acceptance, tsl, lsl, lsl_include, usl, usl_include FROM profile_analysis WHERE profile = @pProfile)
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
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_role].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
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
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_role].[MS_DiagramPane2]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'd
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_role';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_role].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_role';


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
-- Umgestaltungsschritt zum Aktualisieren des Zielservers mit bereitgestellten Transaktionsprotokollen

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'de9e1acc-8b35-431c-8d71-853c09436f9c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('de9e1acc-8b35-431c-8d71-853c09436f9c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a2c82950-859a-4bd4-b850-6a32df402938')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a2c82950-859a-4bd4-b850-6a32df402938')

GO

GO
PRINT N'Vorhandene Daten werden auf neu erstellte Einschränkungen hin überprüft.';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[template_profile] WITH CHECK CHECK CONSTRAINT [FK_template_profile_template];

ALTER TABLE [dbo].[template] WITH CHECK CHECK CONSTRAINT [FK_template_customer];

ALTER TABLE [dbo].[template] WITH CHECK CHECK CONSTRAINT [FK_template_customer1];

ALTER TABLE [dbo].[template] WITH CHECK CHECK CONSTRAINT [FK_template_priority];

ALTER TABLE [dbo].[template] WITH CHECK CHECK CONSTRAINT [FK_template_workflow];

ALTER TABLE [dbo].[setup] WITH CHECK CHECK CONSTRAINT [CK_setup];


GO
PRINT N'Update abgeschlossen.';


GO
