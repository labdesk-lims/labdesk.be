CREATE TABLE [dbo].[import] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [request]    INT            NOT NULL,
    [method]     INT            NULL,
    [instrument] INT            NULL,
    [keyword]    NVARCHAR (MAX) CONSTRAINT [DF_import_imported_at] DEFAULT (getdate()) NOT NULL,
    [value_txt]  NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_import] PRIMARY KEY CLUSTERED ([id] ASC)
);

