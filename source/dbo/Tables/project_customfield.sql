CREATE TABLE [dbo].[project_customfield] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [field_name]  NVARCHAR (MAX) NULL,
    [field_value] NVARCHAR (MAX) NULL,
    [project]     INT            NOT NULL,
    CONSTRAINT [PK_project_customfield] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_project_customfield_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE
);

