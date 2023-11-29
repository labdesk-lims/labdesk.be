-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[import_perform] 
	-- Add the parameters for the stored procedure here
	@strFolder nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT, @j INT
	DECLARE @keyword NVARCHAR(MAX), @value_txt NVARCHAR(MAX), @request INT, @method INT, @instrument INT, @measurement INT
	DECLARE @imported BIT, @cmd NVARCHAR(MAX)
	DECLARE @strCmd VARCHAR(1024)
	DECLARE @strFile nvarchar(max)
	DECLARE @files TABLE (ID INT IDENTITY, FileName VARCHAR(MAX))

	BEGIN TRY
		TRUNCATE TABLE import

		-- Concatenate command string
		SET @strCmd = CONCAT('dir ' , @strFolder, '\*.csv /b')

		-- Create file list
		INSERT INTO @files execute xp_cmdshell @strCmd
		DELETE FROM @files WHERE FileName IS NULL

		-- Import measurement values from import file
		DECLARE import_cur CURSOR FOR SELECT id FROM @files ORDER BY id
		OPEN import_cur
		FETCH NEXT FROM import_cur INTO @i
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Perform import of measurement data
			SET @strFile=CONCAT(@strFolder, '\', (SELECT FileName FROM @files WHERE id = @i))
			EXEC import_csv @strFile, @imported OUT

			-- Delete imported file
			IF @imported = 1
			BEGIN
				SET @cmd = 'xp_cmdshell ''del ' + @strFile + '"'''
				EXEC (@cmd)
			END
			
			FETCH NEXT FROM import_cur INTO @i
		END
		CLOSE import_cur
		DEALLOCATE import_cur

		-- Update measurements
		DECLARE consume_cur CURSOR FOR SELECT id FROM import ORDER BY id
		OPEN consume_cur
		FETCH NEXT FROM consume_cur INTO @j
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Consume imported values as measurement data
			SET @keyword = (SELECT keyword FROM import WHERE id = @j)
			SET @value_txt = (SELECT value_txt FROM import WHERE id = @j)
			SET @request = (SELECT request FROM import WHERE id = @j)
			SET @method = (SELECT method FROM import WHERE id = @j)
			SET @instrument = (SELECT instrument FROM import WHERE id = @j)
			
			-- Handle analysis services
			IF SUBSTRING(@keyword, 1, 1) = 'A'
			BEGIN
				SET @measurement = (SELECT id FROM measurement WHERE state = 'CP' AND analysis = CONVERT(INT, SUBSTRING(@keyword, 2, LEN(@keyword))) AND request = @request)
				
				IF ISNUMERIC(@value_txt) = 1 AND @measurement IS NOT NULL
					UPDATE measurement SET value_num = CONVERT(FLOAT, @value_txt), method = @method, instrument = @instrument, state = 'AQ' WHERE id = @measurement --state = 'CP' AND analysis = CONVERT(INT, SUBSTRING(@keyword, 2, LEN(@keyword))) AND request = @request
				
				IF ISNUMERIC(@value_txt) = 0 AND @measurement > 0
					UPDATE measurement SET value_txt = @value_txt, method = @method, instrument = @instrument, state = 'AQ' WHERE id = @measurement --state = 'CP' AND analysis = CONVERT(INT, SUBSTRING(@keyword, 2, LEN(@keyword))) AND request = @request			
			END

			-- Handle calculated fields
			IF SUBSTRING(@keyword, 1, 1) = 'F'
			BEGIN
				SET @measurement = (SELECT measurement.id FROM measurement INNER JOIN measurement_cfield ON measurement.id = measurement_cfield.measurement WHERE measurement.state = 'CP' AND measurement_cfield.cfield = CAST(SUBSTRING(@keyword, 2, LEN(@keyword)) AS INT) AND measurement.request = @request)

				IF ISNUMERIC(@value_txt) = 1 AND @measurement IS NOT NULL
					UPDATE measurement_cfield SET value_num = CONVERT(FLOAT, @value_txt) WHERE cfield = CONVERT(INT, SUBSTRING(@keyword, 2, LEN(@keyword))) AND measurement = @measurement
			END

			EXEC calculation_iterate @request

			FETCH NEXT FROM consume_cur INTO @j
		END
		CLOSE consume_cur
		DEALLOCATE consume_cur

	END TRY
	BEGIN CATCH
		DEALLOCATE import_cur
		DEALLOCATE consume_cur
	END CATCH
END
