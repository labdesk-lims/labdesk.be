CREATE TABLE [dbo].[material_hp]
(
	[id]          INT            IDENTITY (1, 1) NOT NULL,
	[identifier]  VARCHAR(255) NOT NULL,
	[applies]     BIT CONSTRAINT [DF_material_hp_applies] DEFAULT ((0)) NOT NULL,
	[material]    INT            NOT NULL,
    CONSTRAINT [PK_material_hp] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_material_hp] FOREIGN KEY ([material]) REFERENCES [dbo].[material] ([id]) ON DELETE CASCADE
)