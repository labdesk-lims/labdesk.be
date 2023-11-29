CREATE TABLE [dbo].[spa] (
    [id]                  INT           IDENTITY (1, 1) NOT NULL,
    [uid]                 VARCHAR (255) NULL,
    [time]                INT           NULL,
    [value]               FLOAT (53)    NULL,
    [value_minus_outlier] FLOAT (53)    NULL,
    [validated_at]        DATETIME      NULL,
    [average]             FLOAT (53)    NULL,
    [stdev]               FLOAT (53)    NULL,
    [lal]                 FLOAT (53)    NULL,
    [ual]                 FLOAT (53)    NULL,
    [lwl]                 FLOAT (53)    NULL,
    [uwl]                 FLOAT (53)    NULL,
    [lsl]                 FLOAT (53)    NULL,
    [usl]                 FLOAT (53)    NULL,
    [outlier]             FLOAT (53)    NULL,
    CONSTRAINT [PK_spa] PRIMARY KEY CLUSTERED ([id] ASC)
);

