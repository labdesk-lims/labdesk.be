CREATE TABLE [dbo].[measurement] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [comment]        NVARCHAR (MAX) NULL,
    [request]        INT            NOT NULL,
    [sortkey]        INT            NULL,
    [analysis]       INT            NOT NULL,
    [method]         INT            NULL,
    [instrument]     INT            NULL,
    [value_txt]      NVARCHAR (MAX) NULL,
    [value_num]      FLOAT (53)     NULL,
    [unit]           VARCHAR (255)  NULL,
    [uncertainty]    FLOAT (53)     NULL,
    [out_of_range]   BIT            CONSTRAINT [DF_measurement_out_of_range] DEFAULT ((0)) NOT NULL,
    [not_detectable] BIT            CONSTRAINT [DF_measurement_not_detectable] DEFAULT ((0)) NOT NULL,
    [out_of_spec]    BIT            CONSTRAINT [DF_measurement_out_of_spec] DEFAULT ((0)) NOT NULL,
    [state]          CHAR (2)       NULL,
    [hide]           BIT            CONSTRAINT [DF_measurement_hide] DEFAULT ((0)) NOT NULL,
    [acquired_by]    VARCHAR (255)  NULL,
    [acquired_at]    DATETIME       NULL,
    [validated_by]   VARCHAR (255)  NULL,
    [validated_at]   DATETIME       NULL,
    [accredited]     BIT            CONSTRAINT [DF_measurement_accredited] DEFAULT ((0)) NOT NULL,
    [subcontraction] BIT            CONSTRAINT [DF_measurement_subcontracted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_measurement] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_measurement_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]),
    CONSTRAINT [FK_measurement_instrument] FOREIGN KEY ([instrument]) REFERENCES [dbo].[instrument] ([id]),
    CONSTRAINT [FK_measurement_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]),
    CONSTRAINT [FK_measurement_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_audit]
   ON  dbo.measurement 
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
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_update]
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
	DECLARE @auto_validate BIT

	SET @auto_validate = (SELECT TOP 1 auto_validate FROM setup)

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

		-- Auto-Validate if set in table setup
		IF @auto_validate = 1 AND ((SELECT state FROM inserted) = 'CP' OR (SELECT state FROM inserted) = 'AQ')
		BEGIN
			UPDATE measurement SET state = 'VD' WHERE id = (SELECT id FROM inserted)
		END
	END
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CP - Captured, AQ - Aquired, RE - Retest, RT - Retract, VD - Validated', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'measurement', @level2type = N'COLUMN', @level2name = N'state';

