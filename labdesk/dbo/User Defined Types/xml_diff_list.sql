CREATE TYPE [dbo].[xml_diff_list] AS TABLE (
    [pk]        NVARCHAR (MAX) NULL,
    [elem_name] NVARCHAR (128) NULL,
    [value_old] NVARCHAR (MAX) NULL,
    [value_new] NVARCHAR (MAX) NULL);

