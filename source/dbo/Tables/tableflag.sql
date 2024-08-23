CREATE TABLE [dbo].[tableflag] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [user_name]  NVARCHAR (255) NOT NULL,
    [table_name] NVARCHAR (255) NOT NULL,
    [table_id]   INT            NOT NULL,
    CONSTRAINT [PK_tableflag] PRIMARY KEY CLUSTERED ([id] ASC)
);

