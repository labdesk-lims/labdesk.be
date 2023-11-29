CREATE TABLE [dbo].[traversal] (
    [id]             INT           IDENTITY (1, 1) NOT NULL,
    [state]          INT           NOT NULL,
    [traversal_date] DATETIME      NOT NULL,
    [traversal_by]   VARCHAR (255) NULL,
    [request]        INT           NULL,
    CONSTRAINT [PK_traversal] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_traversal_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE
);

