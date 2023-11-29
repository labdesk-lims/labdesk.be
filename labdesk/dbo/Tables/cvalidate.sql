CREATE TABLE [dbo].[cvalidate] (
    [id]          INT        IDENTITY (1, 1) NOT NULL,
    [cfield_id]   INT        NULL,
    [analysis_id] INT        NULL,
    [value]       FLOAT (53) NULL,
    [analysis]    INT        NOT NULL,
    CONSTRAINT [PK_cvalidate] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_cvalidate_analysis] FOREIGN KEY ([analysis_id]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[cvalidate_insert_update] 
   ON  [dbo].[cvalidate]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )  
	BEGIN
		IF (SELECT analysis_id FROM inserted) IS NULL AND (SELECT cfield_id FROM inserted) IS NULL
			THROW 51000, 'Whether cfield_id or analysis_id need to be chosen.', 1
		
		IF (SELECT analysis_id FROM inserted) IS NOT NULL AND (SELECT cfield_id FROM inserted) IS NOT NULL
			THROW 51000, 'Whether cfield_id or analysis_id need to be null.', 1

		IF ((SELECT analysis_id FROM inserted) NOT IN (SELECT id FROM analysis) AND (SELECT analysis_id FROM inserted) IS NOT NULL) OR ((SELECT cfield_id FROM inserted) NOT IN (SELECT id FROM cfield) AND (SELECT cfield_id FROM inserted) IS NOT NULL)
			THROW 51000, 'Whether cfield_id or analysis_id not known.', 1
	END
END
