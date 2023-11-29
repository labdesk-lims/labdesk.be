CREATE TABLE [dbo].[errorlog] (
    [id]                INT            IDENTITY (1, 1) NOT NULL,
    [user_id]           VARCHAR (255)  CONSTRAINT [DF_errorlog_user_id] DEFAULT (suser_name()) NULL,
    [error_id]          VARCHAR (255)  NULL,
    [error_description] NVARCHAR (MAX) NULL,
    [created_at]        DATETIME       CONSTRAINT [DF_errorlog_created_at] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_errorlog] PRIMARY KEY CLUSTERED ([id] ASC)
);

