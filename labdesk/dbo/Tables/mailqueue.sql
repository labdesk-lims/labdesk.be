CREATE TABLE [dbo].[mailqueue] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [recipients]       NVARCHAR (MAX) NULL,
    [subject]          VARCHAR (255)  NULL,
    [body]             NVARCHAR (MAX) NULL,
    [request]          INT            NULL,
    [billing_customer] INT            NULL,
    [processed_at]     DATETIME       NULL,
    CONSTRAINT [PK_mail_queue] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_mailqueue_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE
);

