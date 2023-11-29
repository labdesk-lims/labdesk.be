CREATE TABLE [dbo].[audit] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [table_name]  VARCHAR (255) NOT NULL,
    [table_id]    INT           NOT NULL,
    [action_type] CHAR (1)      NOT NULL,
    [changed_by]  VARCHAR (255) NOT NULL,
    [changed_at]  DATETIME      CONSTRAINT [DF_audit_changed_at] DEFAULT (getdate()) NOT NULL,
    [value_old]   XML           NULL,
    [value_new]   XML           NULL,
    CONSTRAINT [PK_audit] PRIMARY KEY CLUSTERED ([id] DESC)
);

