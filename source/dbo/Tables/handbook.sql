CREATE TABLE [dbo].[handbook] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [message]    NVARCHAR (MAX) NULL,
    [message_by] VARCHAR (255)  CONSTRAINT [DF_handbook_message_by] DEFAULT (suser_name()) NULL,
    [message_at] DATETIME       CONSTRAINT [DF_handbook_message_at] DEFAULT (getdate()) NULL,
    [request]    INT            NULL,
    [project] INT NULL, 
    CONSTRAINT [PK_handbook] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_handbook_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_handbook_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE
);

