CREATE TABLE [dbo].[columns] (
    [id]            INT           IDENTITY (1, 1) NOT NULL,
    [user_id]       VARCHAR (255) NOT NULL,
    [table_id]      VARCHAR (255) NOT NULL,
    [column_id]     VARCHAR (255) NOT NULL,
    [column_width]  INT           NULL,
    [column_hidden] BIT           CONSTRAINT [DF_columns_column_hidden] DEFAULT ((0)) NULL,
    [column_order]  INT           NULL,
    CONSTRAINT [PK_columns] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 OCtober
-- Description:	Delete rows with user set to ''
-- =============================================
CREATE TRIGGER [dbo].[columns_insert_udpate]
   ON  [dbo].[columns]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	IF (SELECT USER_ID FROM inserted) <> ''
		INSERT INTO columns (user_id, table_id, column_id, column_width, column_hidden, column_order) SELECT user_id, table_id, column_id, column_width, column_hidden, column_order FROM inserted

END
