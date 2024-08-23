CREATE TABLE [dbo].[method_smptype] (
    [id]      INT IDENTITY (1, 1) NOT NULL,
    [method]  INT NOT NULL,
    [smptype] INT NOT NULL,
    [applies] BIT CONSTRAINT [DF_method_smptype_applies] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_method_smptype] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_method_smptype_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_method_smptype_smptype] FOREIGN KEY ([smptype]) REFERENCES [dbo].[smptype] ([id]) ON DELETE CASCADE
);

