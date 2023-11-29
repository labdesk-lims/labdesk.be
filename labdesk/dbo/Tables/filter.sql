CREATE TABLE [dbo].[filter] (
    [id]     INT            IDENTITY (1, 1) NOT NULL,
    [form]   VARCHAR (255)  NOT NULL,
    [userid] VARCHAR (255)  NULL,
    [title]  VARCHAR (255)  NULL,
    [filter] NVARCHAR (MAX) NULL,
    [global] BIT            CONSTRAINT [DF_filter_global] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_filter] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	Check validity of global filter
-- =============================================
CREATE TRIGGER [dbo].[filter_insert_update]
   ON  [dbo].[filter] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT userid FROM inserted) IS NULL AND (SELECT global FROM inserted) = 0
		THROW 51000, 'Filter without user id need to be global.', 1
END
