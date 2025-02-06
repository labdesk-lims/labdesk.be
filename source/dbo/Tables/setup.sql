CREATE TABLE [dbo].[setup] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [email_profile]   VARCHAR (255) NULL,
    [alert_document]  INT           NULL,
    [show_desktop]    BIT           CONSTRAINT [DF_setup_show_desktop] DEFAULT 0 NULL,
    [verbous]         BIT           CONSTRAINT [DF_setup_verbous] DEFAULT 0 NULL,
    [vat]             FLOAT (53)    CONSTRAINT [DF_setup_vat] DEFAULT 0 NOT NULL,
    [upload_max_byte] INT           CONSTRAINT [DF_setup_upload_max] DEFAULT ((1000000)) NOT NULL,
    [nav_button]      BIT           NOT NULL DEFAULT 0,
    [num_format] NCHAR(1) NOT NULL DEFAULT 'G', 
    [num_culture] NCHAR(5) NOT NULL DEFAULT 'de-de',
    [auto_validate] BIT NOT NULL CONSTRAINT [DF_setup_auto_validate] DEFAULT 0, 
    [version_fe]      VARCHAR (255) NULL, 
    CONSTRAINT [PK_configuration] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [CK_setup] CHECK ([vat]>=(0) AND [vat]<=(100))
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[setup_insert]
   ON  dbo.setup
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT COUNT(id) FROM setup) > 1
		THROW 51000, 'Only one row config is allowed.', 1 
END
