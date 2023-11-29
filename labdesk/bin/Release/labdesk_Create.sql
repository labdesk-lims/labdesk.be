/*
Bereitstellungsskript für labdesk

Dieser Code wurde von einem Tool generiert.
Änderungen an dieser Datei führen möglicherweise zu falschem Verhalten und gehen verloren, falls
der Code neu generiert wird.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "labdesk"
:setvar DefaultFilePrefix "labdesk"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Überprüfen Sie den SQLCMD-Modus, und deaktivieren Sie die Skriptausführung, wenn der SQLCMD-Modus nicht unterstützt wird.
Um das Skript nach dem Aktivieren des SQLCMD-Modus erneut zu aktivieren, führen Sie folgenden Befehl aus:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Der SQLCMD-Modus muss aktiviert sein, damit dieses Skript erfolgreich ausgeführt werden kann.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Datenbank "$(DatabaseName)" wird erstellt...'
GO
CREATE DATABASE [$(DatabaseName)] COLLATE Latin1_General_CI_AS
GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Die Datenbankeinstellungen können nicht geändert werden. Diese Einstellungen können nur von Systemadministratoren übernommen werden.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Die Datenbankeinstellungen können nicht geändert werden. Diese Einstellungen können nur von Systemadministratoren übernommen werden.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Benutzerdefinierter Tabellentyp "[dbo].[xml_diff_list]" wird erstellt...';


GO
CREATE TYPE [dbo].[xml_diff_list] AS TABLE (
    [pk]        NVARCHAR (MAX) NULL,
    [elem_name] NVARCHAR (128) NULL,
    [value_old] NVARCHAR (MAX) NULL,
    [value_new] NVARCHAR (MAX) NULL);


GO
PRINT N'Benutzerdefinierter Tabellentyp "[dbo].[ColumnList]" wird erstellt...';


GO
CREATE TYPE [dbo].[ColumnList] AS TABLE (
    [clmn] NVARCHAR (MAX) NULL);


GO
PRINT N'Benutzerdefinierter Tabellentyp "[dbo].[BigIntList]" wird erstellt...';


GO
CREATE TYPE [dbo].[BigIntList] AS TABLE (
    [id]    BIGINT NULL,
    [value] BIGINT NULL);


GO
PRINT N'Benutzerdefinierter Tabellentyp "[dbo].[KeyValueList]" wird erstellt...';


GO
CREATE TYPE [dbo].[KeyValueList] AS TABLE (
    [keyword] NVARCHAR (MAX) NULL,
    [value]   FLOAT (53)     NULL);


GO
PRINT N'Benutzerdefinierter Tabellentyp "[dbo].[StringList]" wird erstellt...';


GO
CREATE TYPE [dbo].[StringList] AS TABLE (
    [id]    BIGINT         NULL,
    [value] NVARCHAR (MAX) NULL);


GO
PRINT N'Tabelle "[dbo].[tableflag]" wird erstellt...';


GO
CREATE TABLE [dbo].[tableflag] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [user_name]  NVARCHAR (255) NOT NULL,
    [table_name] NVARCHAR (255) NOT NULL,
    [table_id]   INT            NOT NULL,
    CONSTRAINT [PK_tableflag] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[request_customfield]" wird erstellt...';


GO
CREATE TABLE [dbo].[request_customfield] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [field_name]  NVARCHAR (MAX) NULL,
    [field_value] NVARCHAR (MAX) NULL,
    [request]     INT            NOT NULL,
    CONSTRAINT [PK_request_customfield] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[workplace]" wird erstellt...';


GO
CREATE TABLE [dbo].[workplace] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NOT NULL,
    [department]  INT            NULL,
    CONSTRAINT [PK_workplace] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[condition]" wird erstellt...';


GO
CREATE TABLE [dbo].[condition] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [type]        CHAR (1)       NOT NULL,
    [attributes]  NVARCHAR (MAX) NULL,
    [analysis]    INT            NOT NULL,
    CONSTRAINT [PK_condition] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[component]" wird erstellt...';


GO
CREATE TABLE [dbo].[component] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [position]    VARCHAR (255) NULL,
    [material]    INT           NULL,
    [treatrate]   FLOAT (53)    NULL,
    [formulation] INT           NULL,
    CONSTRAINT [PK_component] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[uncertainty]" wird erstellt...';


GO
CREATE TABLE [dbo].[uncertainty] (
    [id]          INT        IDENTITY (1, 1) NOT NULL,
    [value_min]   FLOAT (53) NOT NULL,
    [value_max]   FLOAT (53) NOT NULL,
    [uncertainty] FLOAT (53) NOT NULL,
    [analysis]    INT        NOT NULL,
    CONSTRAINT [PK_uncertainty] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[workflow]" wird erstellt...';


GO
CREATE TABLE [dbo].[workflow] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NOT NULL,
    CONSTRAINT [PK_workflow] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[request]" wird erstellt...';


GO
CREATE TABLE [dbo].[request] (
    [id]               INT             IDENTITY (1, 1) NOT NULL,
    [description]      NVARCHAR (MAX)  NULL,
    [photo]            VARBINARY (MAX) NULL,
    [customer]         INT             NOT NULL,
    [cc_email]         NVARCHAR (MAX)  NULL,
    [smp_date]         DATETIME        NULL,
    [smptype]          INT             NULL,
    [smpmatrix]        INT             NULL,
    [smpcontainer]     INT             NULL,
    [smpcondition]     INT             NULL,
    [smppreservation]  INT             NULL,
    [smppoint]         INT             NULL,
    [sampler]          INT             NULL,
    [smp_composit]     BIT             NOT NULL,
    [client_sample_id] VARCHAR (255)   NULL,
    [client_order_id]  VARCHAR (255)   NULL,
    [priority]         INT             NOT NULL,
    [internal_use]     BIT             NOT NULL,
    [profile]          INT             NULL,
    [project]          INT             NULL,
    [formulation]      INT             NULL,
    [workflow]         INT             NOT NULL,
    [recipients]       NVARCHAR (MAX)  NULL,
    [subject]          NVARCHAR (MAX)  NULL,
    [body]             NVARCHAR (MAX)  NULL,
    [invoice]          BIT             NOT NULL,
    [billing_customer] INT             NULL,
    [state]            INT             NULL,
    [subrequest]       INT             NULL,
    CONSTRAINT [PK_request] PRIMARY KEY CLUSTERED ([id] DESC)
);


GO
PRINT N'Tabelle "[dbo].[errorlog]" wird erstellt...';


GO
CREATE TABLE [dbo].[errorlog] (
    [id]                INT            IDENTITY (1, 1) NOT NULL,
    [user_id]           VARCHAR (255)  NULL,
    [error_id]          VARCHAR (255)  NULL,
    [error_description] NVARCHAR (MAX) NULL,
    [created_at]        DATETIME       NULL,
    CONSTRAINT [PK_errorlog] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[cvalidate]" wird erstellt...';


GO
CREATE TABLE [dbo].[cvalidate] (
    [id]          INT        IDENTITY (1, 1) NOT NULL,
    [cfield_id]   INT        NULL,
    [analysis_id] INT        NULL,
    [value]       FLOAT (53) NULL,
    [analysis]    INT        NOT NULL,
    CONSTRAINT [PK_cvalidate] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[cfield]" wird erstellt...';


GO
CREATE TABLE [dbo].[cfield] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255) NULL,
    [unit]        VARCHAR (255) NULL,
    [analysis_id] INT           NULL,
    [analysis]    INT           NOT NULL,
    CONSTRAINT [PK_cfield] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[users]" wird erstellt...';


GO
CREATE TABLE [dbo].[users] (
    [id]       INT              IDENTITY (1, 1) NOT NULL,
    [name]     VARCHAR (255)    NOT NULL,
    [uid]      UNIQUEIDENTIFIER NULL,
    [licence]  NVARCHAR (MAX)   NULL,
    [role]     INT              NULL,
    [contact]  INT              NULL,
    [language] VARCHAR (32)     NOT NULL,
    CONSTRAINT [PK_users_name] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Index "[dbo].[users].[uq_users]" wird erstellt...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_users]
    ON [dbo].[users]([name] ASC);


GO
PRINT N'Tabelle "[dbo].[task]" wird erstellt...';


GO
CREATE TABLE [dbo].[task] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [title]            VARCHAR (255)  NULL,
    [description]      NVARCHAR (MAX) NULL,
    [created_by]       VARCHAR (255)  NULL,
    [created_at]       DATETIME       NULL,
    [responsible]      INT            NULL,
    [planned_start]    DATETIME       NULL,
    [planned_end]      DATETIME       NULL,
    [workload_planned] FLOAT (53)     NULL,
    [realized_start]   DATETIME       NULL,
    [realized_end]     DATETIME       NULL,
    [fulfillment]      INT            NULL,
    [project]          INT            NULL,
    [deactivate]       BIT            NULL,
    CONSTRAINT [PK_task] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[request_service]" wird erstellt...';


GO
CREATE TABLE [dbo].[request_service] (
    [id]      INT            IDENTITY (1, 1) NOT NULL,
    [service] INT            NOT NULL,
    [amount]  INT            NOT NULL,
    [comment] NVARCHAR (MAX) NULL,
    [request] INT            NOT NULL,
    CONSTRAINT [PK_request_service] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[task_service]" wird erstellt...';


GO
CREATE TABLE [dbo].[task_service] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [service]          INT            NOT NULL,
    [amount]           INT            NOT NULL,
    [comment]          NVARCHAR (MAX) NULL,
    [task]             INT            NOT NULL,
    [billing_customer] INT            NULL,
    CONSTRAINT [PK_project_service] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[task_material]" wird erstellt...';


GO
CREATE TABLE [dbo].[task_material] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [material]         INT            NOT NULL,
    [amount]           INT            NOT NULL,
    [comment]          NVARCHAR (MAX) NULL,
    [task]             INT            NOT NULL,
    [billing_customer] INT            NULL,
    CONSTRAINT [PK_project_material] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[service]" wird erstellt...';


GO
CREATE TABLE [dbo].[service] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [price]       MONEY          NOT NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_service] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[project]" wird erstellt...';


GO
CREATE TABLE [dbo].[project] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [profile]     INT            NULL,
    [owner]       VARCHAR (255)  NOT NULL,
    [started]     BIT            NULL,
    [deactivate]  BIT            NULL,
    [customer]    INT            NULL,
    [invoice]     BIT            NULL,
    CONSTRAINT [PK_project] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[project_customfield]" wird erstellt...';


GO
CREATE TABLE [dbo].[project_customfield] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [field_name]  NVARCHAR (MAX) NULL,
    [field_value] NVARCHAR (MAX) NULL,
    [project]     INT            NOT NULL,
    CONSTRAINT [PK_project_customfield] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[translation]" wird erstellt...';


GO
CREATE TABLE [dbo].[translation] (
    [id]        INT            IDENTITY (1, 1) NOT NULL,
    [container] VARCHAR (255)  NULL,
    [item]      VARCHAR (255)  NULL,
    [en]        NVARCHAR (MAX) NULL,
    [de]        NVARCHAR (MAX) NULL,
    [custom]    NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_translation] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[qualification]" wird erstellt...';


GO
CREATE TABLE [dbo].[qualification] (
    [id]            INT            IDENTITY (1, 1) NOT NULL,
    [title]         VARCHAR (255)  NULL,
    [description]   NVARCHAR (MAX) NULL,
    [creation_date] DATETIME       NULL,
    [valid_from]    DATETIME       NOT NULL,
    [valid_till]    DATETIME       NOT NULL,
    [performed_by]  INT            NULL,
    [user_id]       INT            NOT NULL,
    [withdraw]      BIT            NULL,
    [method]        INT            NOT NULL,
    CONSTRAINT [PK_method_user] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[request_material]" wird erstellt...';


GO
CREATE TABLE [dbo].[request_material] (
    [id]       INT            IDENTITY (1, 1) NOT NULL,
    [material] INT            NOT NULL,
    [amount]   INT            NOT NULL,
    [comment]  NVARCHAR (MAX) NULL,
    [request]  INT            NOT NULL,
    CONSTRAINT [PK_request_material] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[task_workload]" wird erstellt...';


GO
CREATE TABLE [dbo].[task_workload] (
    [id]               INT           IDENTITY (1, 1) NOT NULL,
    [workday]          DATETIME      NULL,
    [workload]         FLOAT (53)    NULL,
    [created_by]       VARCHAR (255) NULL,
    [created_at]       DATETIME      NULL,
    [task]             INT           NULL,
    [billing_customer] INT           NULL,
    CONSTRAINT [PK_workload] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[role_permission]" wird erstellt...';


GO
CREATE TABLE [dbo].[role_permission] (
    [id]         INT IDENTITY (1, 1) NOT NULL,
    [role]       INT NULL,
    [permission] INT NULL,
    [can_create] BIT NULL,
    [can_read]   BIT NULL,
    [can_update] BIT NULL,
    [can_delete] BIT NULL,
    CONSTRAINT [PK_role_permission] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[measurement_condition]" wird erstellt...';


GO
CREATE TABLE [dbo].[measurement_condition] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [value_txt]   NVARCHAR (MAX) NULL,
    [value_num]   FLOAT (53)     NULL,
    [condition]   INT            NOT NULL,
    [measurement] INT            NOT NULL,
    CONSTRAINT [PK_measurement_condition] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[strposition]" wird erstellt...';


GO
CREATE TABLE [dbo].[strposition] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [position]   VARCHAR (255) NULL,
    [request]    INT           NULL,
    [material]   INT           NULL,
    [batch_id]   VARCHAR (255) NULL,
    [opened_on]  DATETIME      NULL,
    [expiration] DATETIME      NULL,
    [container]  INT           NULL,
    [amount]     FLOAT (53)    NULL,
    [unit]       VARCHAR (255) NULL,
    [storage]    INT           NOT NULL,
    CONSTRAINT [PK_strposition] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[filter]" wird erstellt...';


GO
CREATE TABLE [dbo].[filter] (
    [id]     INT            IDENTITY (1, 1) NOT NULL,
    [form]   VARCHAR (255)  NOT NULL,
    [userid] VARCHAR (255)  NULL,
    [title]  VARCHAR (255)  NULL,
    [filter] NVARCHAR (MAX) NULL,
    [global] BIT            NOT NULL,
    CONSTRAINT [PK_filter] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[traversal]" wird erstellt...';


GO
CREATE TABLE [dbo].[traversal] (
    [id]             INT           IDENTITY (1, 1) NOT NULL,
    [state]          INT           NOT NULL,
    [traversal_date] DATETIME      NOT NULL,
    [traversal_by]   VARCHAR (255) NULL,
    [request]        INT           NULL,
    CONSTRAINT [PK_traversal] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[analysis]" wird erstellt...';


GO
CREATE TABLE [dbo].[analysis] (
    [id]                   INT            IDENTITY (1, 1) NOT NULL,
    [title]                VARCHAR (255)  NULL,
    [technique]            INT            NULL,
    [description]          NVARCHAR (MAX) NULL,
    [unit]                 VARCHAR (255)  NULL,
    [type]                 CHAR (1)       NOT NULL,
    [precision]            INT            NOT NULL,
    [ldl]                  FLOAT (53)     NULL,
    [udl]                  FLOAT (53)     NULL,
    [calculation]          NVARCHAR (MAX) NULL,
    [calculation_activate] BIT            NOT NULL,
    [condition_activate]   BIT            NOT NULL,
    [uncertainty_activate] BIT            NOT NULL,
    [sortkey]              INT            NULL,
    [deactivate]           BIT            NOT NULL,
    [price]                MONEY          NOT NULL,
    CONSTRAINT [PK_analysis] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[department]" wird erstellt...';


GO
CREATE TABLE [dbo].[department] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NOT NULL,
    CONSTRAINT [PK_department] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[technique]" wird erstellt...';


GO
CREATE TABLE [dbo].[technique] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [sortkey]     INT            NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_technique] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[attachment]" wird erstellt...';


GO
CREATE TABLE [dbo].[attachment] (
    [id]               INT             IDENTITY (1, 1) NOT NULL,
    [title]            VARCHAR (255)   NULL,
    [file_name]        NVARCHAR (MAX)  NULL,
    [version_control]  BIT             NULL,
    [reminder]         DATETIME        NULL,
    [responsible]      INT             NULL,
    [revision]         DATETIME        NULL,
    [repetition]       INT             NULL,
    [upload_by]        VARCHAR (255)   NULL,
    [upload_at]        DATETIME        NULL,
    [attach]           BIT             NOT NULL,
    [blob]             VARBINARY (MAX) NULL,
    [certificate]      INT             NULL,
    [qualification]    INT             NULL,
    [request]          INT             NULL,
    [method]           INT             NULL,
    [instrument]       INT             NULL,
    [customer]         INT             NULL,
    [manufacturer]     INT             NULL,
    [supplier]         INT             NULL,
    [material]         INT             NULL,
    [service]          INT             NULL,
    [project]          INT             NULL,
    [task]             INT             NULL,
    [billing_customer] INT             NULL,
    CONSTRAINT [PK_attachment] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[measurement_cfield]" wird erstellt...';


GO
CREATE TABLE [dbo].[measurement_cfield] (
    [id]          INT        IDENTITY (1, 1) NOT NULL,
    [value_num]   FLOAT (53) NULL,
    [cfield]      INT        NOT NULL,
    [measurement] INT        NOT NULL,
    CONSTRAINT [PK_measurement_cfield] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[instype]" wird erstellt...';


GO
CREATE TABLE [dbo].[instype] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NOT NULL,
    CONSTRAINT [PK_instrument_type] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[smpcontainer]" wird erstellt...';


GO
CREATE TABLE [dbo].[smpcontainer] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_container] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[permission]" wird erstellt...';


GO
CREATE TABLE [dbo].[permission] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_permission] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Index "[dbo].[permission].[uq_permission]" wird erstellt...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_permission]
    ON [dbo].[permission]([title] ASC);


GO
PRINT N'Tabelle "[dbo].[smpcondition]" wird erstellt...';


GO
CREATE TABLE [dbo].[smpcondition] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_smpcondition] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[columns]" wird erstellt...';


GO
CREATE TABLE [dbo].[columns] (
    [id]            INT           IDENTITY (1, 1) NOT NULL,
    [user_id]       VARCHAR (255) NOT NULL,
    [table_id]      VARCHAR (255) NOT NULL,
    [column_id]     VARCHAR (255) NOT NULL,
    [column_width]  INT           NULL,
    [column_hidden] BIT           NULL,
    [column_order]  INT           NULL,
    CONSTRAINT [PK_columns] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[instrument]" wird erstellt...';


GO
CREATE TABLE [dbo].[instrument] (
    [id]                INT             IDENTITY (1, 1) NOT NULL,
    [title]             VARCHAR (255)   NULL,
    [description]       NVARCHAR (MAX)  NULL,
    [asset_number]      VARCHAR (255)   NULL,
    [type]              INT             NULL,
    [manufacturer]      INT             NULL,
    [supplier]          INT             NULL,
    [model]             VARCHAR (255)   NULL,
    [serial_number]     VARCHAR (255)   NULL,
    [photo]             VARBINARY (MAX) NULL,
    [installation_date] DATETIME        NULL,
    [deactivate]        BIT             NOT NULL,
    [workplace]         INT             NULL,
    CONSTRAINT [PK_instrument] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[billing_customer]" wird erstellt...';


GO
CREATE TABLE [dbo].[billing_customer] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [cc_email]    NVARCHAR (MAX) NULL,
    [requests]    NVARCHAR (MAX) NULL,
    [projects]    NVARCHAR (MAX) NULL,
    [customer]    INT            NOT NULL,
    [revenue]     MONEY          NULL,
    [discount]    MONEY          NULL,
    [invoiced]    DATETIME       NULL,
    [delivered]   VARCHAR (MAX)  NULL,
    [recipients]  NVARCHAR (MAX) NULL,
    [subject]     NVARCHAR (MAX) NULL,
    [body]        NVARCHAR (MAX) NULL,
    [billing]     INT            NOT NULL,
    CONSTRAINT [PK_billing_customer] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[project_member]" wird erstellt...';


GO
CREATE TABLE [dbo].[project_member] (
    [id]      INT IDENTITY (1, 1) NOT NULL,
    [users]   INT NOT NULL,
    [project] INT NOT NULL,
    CONSTRAINT [PK_member] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[step]" wird erstellt...';


GO
CREATE TABLE [dbo].[step] (
    [id]      INT IDENTITY (1, 1) NOT NULL,
    [step]    INT NOT NULL,
    [applies] BIT NOT NULL,
    [state]   INT NOT NULL,
    CONSTRAINT [PK_step] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[handbook]" wird erstellt...';


GO
CREATE TABLE [dbo].[handbook] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [message]    NVARCHAR (MAX) NULL,
    [message_by] VARCHAR (255)  NULL,
    [message_at] DATETIME       NULL,
    [request]    INT            NOT NULL,
    CONSTRAINT [PK_handbook] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[method_analysis]" wird erstellt...';


GO
CREATE TABLE [dbo].[method_analysis] (
    [id]       INT IDENTITY (1, 1) NOT NULL,
    [method]   INT NOT NULL,
    [analysis] INT NOT NULL,
    [applies]  BIT NOT NULL,
    [standard] BIT NOT NULL,
    CONSTRAINT [PK_method_analysis] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[customfield]" wird erstellt...';


GO
CREATE TABLE [dbo].[customfield] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [table_name] NVARCHAR (255) NOT NULL,
    [field_name] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_customfield] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[material]" wird erstellt...';


GO
CREATE TABLE [dbo].[material] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [cas]         VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [supplier]    INT            NULL,
    [price]       MONEY          NOT NULL,
    [GHS_1]       BIT            NULL,
    [GHS_2]       BIT            NULL,
    [GHS_3]       BIT            NULL,
    [GHS_4]       BIT            NULL,
    [GHS_5]       BIT            NULL,
    [GHS_6]       BIT            NULL,
    [GHS_7]       BIT            NULL,
    [GHS_8]       BIT            NULL,
    [GHS_9]       BIT            NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_material] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[smptype]" wird erstellt...';


GO
CREATE TABLE [dbo].[smptype] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_smptype] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[manufacturer]" wird erstellt...';


GO
CREATE TABLE [dbo].[manufacturer] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NOT NULL,
    CONSTRAINT [PK_manufacturer] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[smppreservation]" wird erstellt...';


GO
CREATE TABLE [dbo].[smppreservation] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_smppreservation] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[customer]" wird erstellt...';


GO
CREATE TABLE [dbo].[customer] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [name]                VARCHAR (255)  NULL,
    [homepage]            NVARCHAR (MAX) NULL,
    [postal_country]      VARCHAR (255)  NULL,
    [postal_state]        VARCHAR (255)  NULL,
    [postal_district]     VARCHAR (255)  NULL,
    [postal_city]         VARCHAR (255)  NULL,
    [postal_postalcode]   VARCHAR (255)  NULL,
    [postal_street]       VARCHAR (255)  NULL,
    [postal_housenumber]  VARCHAR (255)  NULL,
    [billing_country]     VARCHAR (255)  NULL,
    [billing_state]       VARCHAR (255)  NULL,
    [billing_district]    VARCHAR (255)  NULL,
    [billing_city]        VARCHAR (255)  NULL,
    [billing_postalcode]  VARCHAR (255)  NULL,
    [billing_street]      VARCHAR (255)  NULL,
    [billing_housenumber] VARCHAR (255)  NULL,
    [bank]                VARCHAR (255)  NULL,
    [iban]                VARCHAR (255)  NULL,
    [bic]                 VARCHAR (255)  NULL,
    [vatnr]               VARCHAR (255)  NULL,
    [discount]            FLOAT (53)     NOT NULL,
    [deactivate]          BIT            NOT NULL,
    CONSTRAINT [PK_customer] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[measurement]" wird erstellt...';


GO
CREATE TABLE [dbo].[measurement] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [comment]        NVARCHAR (MAX) NULL,
    [request]        INT            NOT NULL,
    [sortkey]        INT            NULL,
    [analysis]       INT            NOT NULL,
    [method]         INT            NULL,
    [instrument]     INT            NULL,
    [value_txt]      NVARCHAR (MAX) NULL,
    [value_num]      FLOAT (53)     NULL,
    [unit]           VARCHAR (255)  NULL,
    [uncertainty]    FLOAT (53)     NULL,
    [out_of_range]   BIT            NOT NULL,
    [not_detectable] BIT            NOT NULL,
    [out_of_spec]    BIT            NOT NULL,
    [state]          CHAR (2)       NULL,
    [hide]           BIT            NOT NULL,
    [acquired_by]    VARCHAR (255)  NULL,
    [acquired_at]    DATETIME       NULL,
    [validated_by]   VARCHAR (255)  NULL,
    [validated_at]   DATETIME       NULL,
    [accredited]     BIT            NOT NULL,
    [subcontraction] BIT            NOT NULL,
    CONSTRAINT [PK_measurement] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[smppoint]" wird erstellt...';


GO
CREATE TABLE [dbo].[smppoint] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [customer]    INT            NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_smppoint] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[laboratory]" wird erstellt...';


GO
CREATE TABLE [dbo].[laboratory] (
    [id]                  INT             IDENTITY (1, 1) NOT NULL,
    [title]               VARCHAR (255)   NULL,
    [manager]             INT             NULL,
    [vatnr]               VARCHAR (255)   NULL,
    [fax]                 VARCHAR (255)   NULL,
    [postal_country]      VARCHAR (255)   NULL,
    [postal_state]        VARCHAR (255)   NULL,
    [postal_district]     VARCHAR (255)   NULL,
    [postal_city]         VARCHAR (255)   NULL,
    [postal_postalcode]   VARCHAR (255)   NULL,
    [postal_street]       VARCHAR (255)   NULL,
    [postal_housenumber]  VARCHAR (255)   NULL,
    [billing_country]     VARCHAR (255)   NULL,
    [billing_state]       VARCHAR (255)   NULL,
    [billing_district]    VARCHAR (255)   NULL,
    [billing_city]        VARCHAR (255)   NULL,
    [billing_postalcode]  VARCHAR (255)   NULL,
    [billing_street]      VARCHAR (255)   NULL,
    [billing_housenumber] VARCHAR (255)   NULL,
    [lab_url]             VARCHAR (2048)  NULL,
    [lab_logo]            VARBINARY (MAX) NULL,
    [account_type]        VARCHAR (255)   NULL,
    [account_iban]        VARCHAR (255)   NULL,
    [account_bic]         VARCHAR (255)   NULL,
    [account_bank]        VARCHAR (255)   NULL,
    [account_branch]      VARCHAR (255)   NULL,
    [accredited]          BIT             NULL,
    [accreditation]       VARCHAR (255)   NULL,
    [acc_uid]             VARCHAR (255)   NULL,
    [acc_body]            VARCHAR (255)   NULL,
    [acc_url]             VARCHAR (2048)  NULL,
    [acc_logo]            VARBINARY (MAX) NULL,
    [acc_letterhead]      NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_laboratory] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[setup]" wird erstellt...';


GO
CREATE TABLE [dbo].[setup] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [email_profile]   VARCHAR (255)  NULL,
    [alert_document]  INT            NULL,
    [show_desktop]    BIT            NULL,
    [licence]         NVARCHAR (MAX) NULL,
    [vat]             FLOAT (53)     NOT NULL,
    [upload_max_byte] INT            NOT NULL,
    CONSTRAINT [PK_configuration] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[smpmatrix]" wird erstellt...';


GO
CREATE TABLE [dbo].[smpmatrix] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_smpmatrix] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[profile_analysis]" wird erstellt...';


GO
CREATE TABLE [dbo].[profile_analysis] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [profile]     INT           NOT NULL,
    [analysis]    INT           NOT NULL,
    [method]      INT           NULL,
    [sortkey]     INT           NULL,
    [applies]     BIT           NOT NULL,
    [true_value]  FLOAT (53)    NULL,
    [acceptance]  FLOAT (53)    NULL,
    [tsl]         VARCHAR (255) NULL,
    [lsl]         FLOAT (53)    NULL,
    [lsl_include] BIT           NOT NULL,
    [usl]         FLOAT (53)    NULL,
    [usl_include] BIT           NOT NULL,
    CONSTRAINT [PK_profile_analysis] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[instrument_method]" wird erstellt...';


GO
CREATE TABLE [dbo].[instrument_method] (
    [id]         INT IDENTITY (1, 1) NOT NULL,
    [instrument] INT NOT NULL,
    [method]     INT NOT NULL,
    [standard]   BIT NULL,
    [applies]    BIT NULL,
    CONSTRAINT [PK_instrument_method] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[batch]" wird erstellt...';


GO
CREATE TABLE [dbo].[batch] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_batch] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[audit]" wird erstellt...';


GO
CREATE TABLE [dbo].[audit] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [table_name]  VARCHAR (255) NOT NULL,
    [table_id]    INT           NOT NULL,
    [action_type] CHAR (1)      NOT NULL,
    [changed_by]  VARCHAR (255) NOT NULL,
    [changed_at]  DATETIME      NOT NULL,
    [value_old]   XML           NULL,
    [value_new]   XML           NULL,
    CONSTRAINT [PK_audit] PRIMARY KEY CLUSTERED ([id] DESC)
);


GO
PRINT N'Tabelle "[dbo].[import]" wird erstellt...';


GO
CREATE TABLE [dbo].[import] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [request]    INT            NOT NULL,
    [method]     INT            NULL,
    [instrument] INT            NULL,
    [keyword]    NVARCHAR (MAX) NOT NULL,
    [value_txt]  NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_import] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[billing]" wird erstellt...';


GO
CREATE TABLE [dbo].[billing] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [title]        VARCHAR (255)  NULL,
    [description]  NVARCHAR (MAX) NULL,
    [billing_from] DATETIME       NOT NULL,
    [billing_till] DATETIME       NOT NULL,
    [revenue]      MONEY          NULL,
    [discount]     MONEY          NULL,
    CONSTRAINT [PK_billing] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[attribute]" wird erstellt...';


GO
CREATE TABLE [dbo].[attribute] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [title]    VARCHAR (255) NULL,
    [value]    INT           NOT NULL,
    [analysis] INT           NOT NULL,
    CONSTRAINT [PK_analysis-attribute] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[storage]" wird erstellt...';


GO
CREATE TABLE [dbo].[storage] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_storage] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[method]" wird erstellt...';


GO
CREATE TABLE [dbo].[method] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [title]          VARCHAR (255)  NULL,
    [edition]        NVARCHAR (255) NULL,
    [description]    NVARCHAR (MAX) NULL,
    [price]          MONEY          NOT NULL,
    [subcontraction] BIT            NOT NULL,
    [deactivate]     BIT            NOT NULL,
    CONSTRAINT [PK_method] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[state]" wird erstellt...';


GO
CREATE TABLE [dbo].[state] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [title]    VARCHAR (255) NULL,
    [state]    CHAR (2)      NULL,
    [workflow] INT           NOT NULL,
    CONSTRAINT [PK_state] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[spa]" wird erstellt...';


GO
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


GO
PRINT N'Tabelle "[dbo].[priority]" wird erstellt...';


GO
CREATE TABLE [dbo].[priority] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_priority] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[profile]" wird erstellt...';


GO
CREATE TABLE [dbo].[profile] (
    [id]                 INT            IDENTITY (1, 1) NOT NULL,
    [title]              VARCHAR (255)  NULL,
    [description]        NVARCHAR (MAX) NULL,
    [use_profile_qc]     BIT            NOT NULL,
    [reference_material] INT            NULL,
    [report_template]    VARCHAR (255)  NULL,
    [customer]           INT            NULL,
    [price]              MONEY          NOT NULL,
    [deactivate]         BIT            NOT NULL,
    CONSTRAINT [PK_profile] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[method_smptype]" wird erstellt...';


GO
CREATE TABLE [dbo].[method_smptype] (
    [id]      INT IDENTITY (1, 1) NOT NULL,
    [method]  INT NOT NULL,
    [smptype] INT NOT NULL,
    [applies] BIT NOT NULL,
    CONSTRAINT [PK_method_smptype] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[request_analysis]" wird erstellt...';


GO
CREATE TABLE [dbo].[request_analysis] (
    [id]       INT IDENTITY (1, 1) NOT NULL,
    [applies]  BIT NOT NULL,
    [analysis] INT NOT NULL,
    [method]   INT NULL,
    [request]  INT NOT NULL,
    CONSTRAINT [PK_request_analysis] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[certificate]" wird erstellt...';


GO
CREATE TABLE [dbo].[certificate] (
    [id]            INT            IDENTITY (1, 1) NOT NULL,
    [title]         VARCHAR (255)  NULL,
    [description]   NVARCHAR (MAX) NULL,
    [creation_date] DATETIME       NULL,
    [valid_from]    DATETIME       NOT NULL,
    [valid_till]    DATETIME       NOT NULL,
    [performed_by]  INT            NULL,
    [reviewed_by]   INT            NULL,
    [withdraw]      BIT            NOT NULL,
    [instrument]    INT            NOT NULL,
    CONSTRAINT [PK_instrument_certificate] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[mailqueue]" wird erstellt...';


GO
CREATE TABLE [dbo].[mailqueue] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [recipients]       NVARCHAR (MAX) NULL,
    [subject]          VARCHAR (255)  NULL,
    [body]             NVARCHAR (MAX) NULL,
    [request]          INT            NULL,
    [billing_customer] INT            NULL,
    [processed_at]     DATETIME       NULL,
    CONSTRAINT [PK_mail_queue] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[contact]" wird erstellt...';


GO
CREATE TABLE [dbo].[contact] (
    [id]                  INT             IDENTITY (1, 1) NOT NULL,
    [salutation]          VARCHAR (255)   NULL,
    [first_name]          VARCHAR (255)   NULL,
    [last_name]           VARCHAR (255)   NULL,
    [job_title]           VARCHAR (255)   NULL,
    [signature]           VARBINARY (MAX) NULL,
    [photo]               VARBINARY (MAX) NULL,
    [email]               VARCHAR (255)   NULL,
    [phone]               VARCHAR (255)   NULL,
    [mobile]              VARCHAR (255)   NULL,
    [fax]                 VARCHAR (255)   NULL,
    [website]             VARCHAR (255)   NULL,
    [postal_country]      VARCHAR (255)   NULL,
    [postal_state]        VARCHAR (255)   NULL,
    [postal_district]     VARCHAR (255)   NULL,
    [postal_city]         VARCHAR (255)   NULL,
    [postal_postalcode]   VARCHAR (255)   NULL,
    [postal_street]       VARCHAR (255)   NULL,
    [postal_housenumber]  VARCHAR (255)   NULL,
    [billing_country]     VARCHAR (255)   NULL,
    [billing_state]       VARCHAR (255)   NULL,
    [billing_district]    VARCHAR (255)   NULL,
    [billing_city]        VARCHAR (255)   NULL,
    [billing_postalcode]  VARCHAR (255)   NULL,
    [billing_street]      VARCHAR (255)   NULL,
    [billing_housenumber] VARCHAR (255)   NULL,
    [bank]                VARCHAR (255)   NULL,
    [iban]                VARCHAR (255)   NULL,
    [bic]                 VARCHAR (255)   NULL,
    [vatnr]               VARCHAR (255)   NULL,
    [sampler]             BIT             NULL,
    [deactivate]          BIT             NOT NULL,
    [customer]            INT             NULL,
    CONSTRAINT [PK_contact] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[formulation]" wird erstellt...';


GO
CREATE TABLE [dbo].[formulation] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [instruction] NVARCHAR (MAX) NULL,
    [owner]       VARCHAR (255)  NOT NULL,
    [project]     INT            NULL,
    [deactivate]  BIT            NULL,
    CONSTRAINT [PK_formulation] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[billing_position]" wird erstellt...';


GO
CREATE TABLE [dbo].[billing_position] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [category]         INT            NULL,
    [profile]          INT            NULL,
    [method]           INT            NULL,
    [analysis]         INT            NULL,
    [material]         INT            NULL,
    [service]          INT            NULL,
    [other]            NVARCHAR (MAX) NULL,
    [amount]           INT            NOT NULL,
    [price]            MONEY          NOT NULL,
    [billing_customer] INT            NOT NULL,
    CONSTRAINT [PK_billing_position] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[btcposition]" wird erstellt...';


GO
CREATE TABLE [dbo].[btcposition] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [position] VARCHAR (255) NULL,
    [request]  INT           NULL,
    [batch]    INT           NOT NULL,
    CONSTRAINT [PK_btcposition] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[supplier]" wird erstellt...';


GO
CREATE TABLE [dbo].[supplier] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [rating]      FLOAT (53)     NULL,
    [deactivate]  BIT            NOT NULL,
    CONSTRAINT [PK_supplier] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Tabelle "[dbo].[role]" wird erstellt...';


GO
CREATE TABLE [dbo].[role] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [title]          VARCHAR (255)  NULL,
    [description]    NVARCHAR (MAX) NULL,
    [hourly_rate]    MONEY          NOT NULL,
    [administrative] BIT            NOT NULL,
    [deactivate]     BIT            NOT NULL,
    CONSTRAINT [PK_role] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_workplace_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[workplace]
    ADD CONSTRAINT [DF_workplace_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_condition_type]" wird erstellt...';


GO
ALTER TABLE [dbo].[condition]
    ADD CONSTRAINT [DF_condition_type] DEFAULT ('N') FOR [type];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_workflow_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[workflow]
    ADD CONSTRAINT [DF_workflow_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_Table_1_composit]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [DF_Table_1_composit] DEFAULT ((0)) FOR [smp_composit];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_Table_1_internal_user]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [DF_Table_1_internal_user] DEFAULT ((0)) FOR [internal_use];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_request_exec_invoice]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [DF_request_exec_invoice] DEFAULT ((0)) FOR [invoice];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_errorlog_user_id]" wird erstellt...';


GO
ALTER TABLE [dbo].[errorlog]
    ADD CONSTRAINT [DF_errorlog_user_id] DEFAULT (suser_name()) FOR [user_id];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_errorlog_created_at]" wird erstellt...';


GO
ALTER TABLE [dbo].[errorlog]
    ADD CONSTRAINT [DF_errorlog_created_at] DEFAULT (getdate()) FOR [created_at];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_users_uid]" wird erstellt...';


GO
ALTER TABLE [dbo].[users]
    ADD CONSTRAINT [DF_users_uid] DEFAULT (newid()) FOR [uid];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_users_language]" wird erstellt...';


GO
ALTER TABLE [dbo].[users]
    ADD CONSTRAINT [DF_users_language] DEFAULT (N'en') FOR [language];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_task_created_by]" wird erstellt...';


GO
ALTER TABLE [dbo].[task]
    ADD CONSTRAINT [DF_task_created_by] DEFAULT (suser_name()) FOR [created_by];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_task_created_at]" wird erstellt...';


GO
ALTER TABLE [dbo].[task]
    ADD CONSTRAINT [DF_task_created_at] DEFAULT (getdate()) FOR [created_at];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_task_fullfillment]" wird erstellt...';


GO
ALTER TABLE [dbo].[task]
    ADD CONSTRAINT [DF_task_fullfillment] DEFAULT ((0)) FOR [fulfillment];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_task_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[task]
    ADD CONSTRAINT [DF_task_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_request_service_amount]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_service]
    ADD CONSTRAINT [DF_request_service_amount] DEFAULT ((0)) FOR [amount];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_project_service_amount]" wird erstellt...';


GO
ALTER TABLE [dbo].[task_service]
    ADD CONSTRAINT [DF_project_service_amount] DEFAULT ((0)) FOR [amount];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_project_material_amount]" wird erstellt...';


GO
ALTER TABLE [dbo].[task_material]
    ADD CONSTRAINT [DF_project_material_amount] DEFAULT ((0)) FOR [amount];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_service_price]" wird erstellt...';


GO
ALTER TABLE [dbo].[service]
    ADD CONSTRAINT [DF_service_price] DEFAULT ((0)) FOR [price];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_service_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[service]
    ADD CONSTRAINT [DF_service_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_project_owner]" wird erstellt...';


GO
ALTER TABLE [dbo].[project]
    ADD CONSTRAINT [DF_project_owner] DEFAULT (suser_name()) FOR [owner];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_project_started]" wird erstellt...';


GO
ALTER TABLE [dbo].[project]
    ADD CONSTRAINT [DF_project_started] DEFAULT ((0)) FOR [started];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_project_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[project]
    ADD CONSTRAINT [DF_project_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_project_invoice]" wird erstellt...';


GO
ALTER TABLE [dbo].[project]
    ADD CONSTRAINT [DF_project_invoice] DEFAULT ((0)) FOR [invoice];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_method_qualification_withdraw]" wird erstellt...';


GO
ALTER TABLE [dbo].[qualification]
    ADD CONSTRAINT [DF_method_qualification_withdraw] DEFAULT ((0)) FOR [withdraw];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_request_material_amount]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_material]
    ADD CONSTRAINT [DF_request_material_amount] DEFAULT ((0)) FOR [amount];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_workload_created_by]" wird erstellt...';


GO
ALTER TABLE [dbo].[task_workload]
    ADD CONSTRAINT [DF_workload_created_by] DEFAULT (suser_name()) FOR [created_by];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_Table_1_c]" wird erstellt...';


GO
ALTER TABLE [dbo].[role_permission]
    ADD CONSTRAINT [DF_Table_1_c] DEFAULT ((0)) FOR [can_create];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_Table_1_r]" wird erstellt...';


GO
ALTER TABLE [dbo].[role_permission]
    ADD CONSTRAINT [DF_Table_1_r] DEFAULT ((0)) FOR [can_read];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_Table_1_u]" wird erstellt...';


GO
ALTER TABLE [dbo].[role_permission]
    ADD CONSTRAINT [DF_Table_1_u] DEFAULT ((0)) FOR [can_update];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_Table_1_d]" wird erstellt...';


GO
ALTER TABLE [dbo].[role_permission]
    ADD CONSTRAINT [DF_Table_1_d] DEFAULT ((0)) FOR [can_delete];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_filter_global]" wird erstellt...';


GO
ALTER TABLE [dbo].[filter]
    ADD CONSTRAINT [DF_filter_global] DEFAULT ((0)) FOR [global];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_analysis_type]" wird erstellt...';


GO
ALTER TABLE [dbo].[analysis]
    ADD CONSTRAINT [DF_analysis_type] DEFAULT ('N') FOR [type];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_analysis_precision]" wird erstellt...';


GO
ALTER TABLE [dbo].[analysis]
    ADD CONSTRAINT [DF_analysis_precision] DEFAULT ((0)) FOR [precision];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_analysis_calculation_activate]" wird erstellt...';


GO
ALTER TABLE [dbo].[analysis]
    ADD CONSTRAINT [DF_analysis_calculation_activate] DEFAULT ((0)) FOR [calculation_activate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_analysis_condition_activate]" wird erstellt...';


GO
ALTER TABLE [dbo].[analysis]
    ADD CONSTRAINT [DF_analysis_condition_activate] DEFAULT ((0)) FOR [condition_activate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_analysis_uncertainty_activate]" wird erstellt...';


GO
ALTER TABLE [dbo].[analysis]
    ADD CONSTRAINT [DF_analysis_uncertainty_activate] DEFAULT ((0)) FOR [uncertainty_activate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_analysis_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[analysis]
    ADD CONSTRAINT [DF_analysis_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_analysis_price]" wird erstellt...';


GO
ALTER TABLE [dbo].[analysis]
    ADD CONSTRAINT [DF_analysis_price] DEFAULT ((0)) FOR [price];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_department_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[department]
    ADD CONSTRAINT [DF_department_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_technique_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[technique]
    ADD CONSTRAINT [DF_technique_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_attachment_version_control]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [DF_attachment_version_control] DEFAULT ((0)) FOR [version_control];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_attachment_attach]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [DF_attachment_attach] DEFAULT ((0)) FOR [attach];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_instrument_type_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[instype]
    ADD CONSTRAINT [DF_instrument_type_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_smpcontainer_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[smpcontainer]
    ADD CONSTRAINT [DF_smpcontainer_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_smpcondition_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[smpcondition]
    ADD CONSTRAINT [DF_smpcondition_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_columns_column_hidden]" wird erstellt...';


GO
ALTER TABLE [dbo].[columns]
    ADD CONSTRAINT [DF_columns_column_hidden] DEFAULT ((0)) FOR [column_hidden];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_instrument_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[instrument]
    ADD CONSTRAINT [DF_instrument_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_step_applies]" wird erstellt...';


GO
ALTER TABLE [dbo].[step]
    ADD CONSTRAINT [DF_step_applies] DEFAULT ((0)) FOR [applies];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_handbook_message_by]" wird erstellt...';


GO
ALTER TABLE [dbo].[handbook]
    ADD CONSTRAINT [DF_handbook_message_by] DEFAULT (suser_name()) FOR [message_by];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_handbook_message_at]" wird erstellt...';


GO
ALTER TABLE [dbo].[handbook]
    ADD CONSTRAINT [DF_handbook_message_at] DEFAULT (getdate()) FOR [message_at];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_method_analysis_applies]" wird erstellt...';


GO
ALTER TABLE [dbo].[method_analysis]
    ADD CONSTRAINT [DF_method_analysis_applies] DEFAULT ((0)) FOR [applies];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_method_analysis_standard]" wird erstellt...';


GO
ALTER TABLE [dbo].[method_analysis]
    ADD CONSTRAINT [DF_method_analysis_standard] DEFAULT ((0)) FOR [standard];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_price]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_price] DEFAULT ((0)) FOR [price];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_GHS_1]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_GHS_1] DEFAULT ((0)) FOR [GHS_1];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_GHS_11]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_GHS_11] DEFAULT ((0)) FOR [GHS_2];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_GHS_12]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_GHS_12] DEFAULT ((0)) FOR [GHS_3];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_GHS_13]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_GHS_13] DEFAULT ((0)) FOR [GHS_4];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_GHS_14]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_GHS_14] DEFAULT ((0)) FOR [GHS_5];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_GHS_15]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_GHS_15] DEFAULT ((0)) FOR [GHS_6];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_GHS_16]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_GHS_16] DEFAULT ((0)) FOR [GHS_7];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_GHS_17]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_GHS_17] DEFAULT ((0)) FOR [GHS_8];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_GHS_18]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_GHS_18] DEFAULT ((0)) FOR [GHS_9];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_material_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [DF_material_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_smptype_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[smptype]
    ADD CONSTRAINT [DF_smptype_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_manufacturer_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[manufacturer]
    ADD CONSTRAINT [DF_manufacturer_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_smppreservation_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[smppreservation]
    ADD CONSTRAINT [DF_smppreservation_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_customer_discount]" wird erstellt...';


GO
ALTER TABLE [dbo].[customer]
    ADD CONSTRAINT [DF_customer_discount] DEFAULT ((0)) FOR [discount];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_customer_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[customer]
    ADD CONSTRAINT [DF_customer_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_measurement_out_of_range]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [DF_measurement_out_of_range] DEFAULT ((0)) FOR [out_of_range];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_measurement_not_detectable]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [DF_measurement_not_detectable] DEFAULT ((0)) FOR [not_detectable];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_measurement_out_of_spec]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [DF_measurement_out_of_spec] DEFAULT ((0)) FOR [out_of_spec];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_measurement_hide]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [DF_measurement_hide] DEFAULT ((0)) FOR [hide];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_measurement_accredited]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [DF_measurement_accredited] DEFAULT ((0)) FOR [accredited];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_measurement_subcontracted]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [DF_measurement_subcontracted] DEFAULT ((0)) FOR [subcontraction];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_smppoint_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[smppoint]
    ADD CONSTRAINT [DF_smppoint_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_laboratory_accredited]" wird erstellt...';


GO
ALTER TABLE [dbo].[laboratory]
    ADD CONSTRAINT [DF_laboratory_accredited] DEFAULT ((0)) FOR [accredited];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_setup_show_desktop]" wird erstellt...';


GO
ALTER TABLE [dbo].[setup]
    ADD CONSTRAINT [DF_setup_show_desktop] DEFAULT ((0)) FOR [show_desktop];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_setup_vat]" wird erstellt...';


GO
ALTER TABLE [dbo].[setup]
    ADD CONSTRAINT [DF_setup_vat] DEFAULT ((0)) FOR [vat];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_setup_upload_max]" wird erstellt...';


GO
ALTER TABLE [dbo].[setup]
    ADD CONSTRAINT [DF_setup_upload_max] DEFAULT ((1000000)) FOR [upload_max_byte];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_smpmatrix_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[smpmatrix]
    ADD CONSTRAINT [DF_smpmatrix_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_profile_analysis_applies]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile_analysis]
    ADD CONSTRAINT [DF_profile_analysis_applies] DEFAULT ((0)) FOR [applies];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_profile_analysis_lsl_include]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile_analysis]
    ADD CONSTRAINT [DF_profile_analysis_lsl_include] DEFAULT ((0)) FOR [lsl_include];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_profile_analysis_usl_include]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile_analysis]
    ADD CONSTRAINT [DF_profile_analysis_usl_include] DEFAULT ((0)) FOR [usl_include];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_instrument_method_standard]" wird erstellt...';


GO
ALTER TABLE [dbo].[instrument_method]
    ADD CONSTRAINT [DF_instrument_method_standard] DEFAULT ((0)) FOR [standard];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_instrument_method_applies]" wird erstellt...';


GO
ALTER TABLE [dbo].[instrument_method]
    ADD CONSTRAINT [DF_instrument_method_applies] DEFAULT ((0)) FOR [applies];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_audit_changed_at]" wird erstellt...';


GO
ALTER TABLE [dbo].[audit]
    ADD CONSTRAINT [DF_audit_changed_at] DEFAULT (getdate()) FOR [changed_at];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_import_imported_at]" wird erstellt...';


GO
ALTER TABLE [dbo].[import]
    ADD CONSTRAINT [DF_import_imported_at] DEFAULT (getdate()) FOR [keyword];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_method_price]" wird erstellt...';


GO
ALTER TABLE [dbo].[method]
    ADD CONSTRAINT [DF_method_price] DEFAULT ((0)) FOR [price];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_method_subcontraction]" wird erstellt...';


GO
ALTER TABLE [dbo].[method]
    ADD CONSTRAINT [DF_method_subcontraction] DEFAULT ((0)) FOR [subcontraction];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_method_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[method]
    ADD CONSTRAINT [DF_method_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_priority_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[priority]
    ADD CONSTRAINT [DF_priority_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_profile_use_profile_qc]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile]
    ADD CONSTRAINT [DF_profile_use_profile_qc] DEFAULT ((0)) FOR [use_profile_qc];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_profile_price]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile]
    ADD CONSTRAINT [DF_profile_price] DEFAULT ((0)) FOR [price];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_profile_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile]
    ADD CONSTRAINT [DF_profile_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_method_smptype_applies]" wird erstellt...';


GO
ALTER TABLE [dbo].[method_smptype]
    ADD CONSTRAINT [DF_method_smptype_applies] DEFAULT ((0)) FOR [applies];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_request_analysis_applies]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_analysis]
    ADD CONSTRAINT [DF_request_analysis_applies] DEFAULT ((0)) FOR [applies];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_instrument_certificate_withdraw]" wird erstellt...';


GO
ALTER TABLE [dbo].[certificate]
    ADD CONSTRAINT [DF_instrument_certificate_withdraw] DEFAULT ((0)) FOR [withdraw];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_contact_sampler]" wird erstellt...';


GO
ALTER TABLE [dbo].[contact]
    ADD CONSTRAINT [DF_contact_sampler] DEFAULT ((0)) FOR [sampler];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_contact_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[contact]
    ADD CONSTRAINT [DF_contact_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_formulation_owner]" wird erstellt...';


GO
ALTER TABLE [dbo].[formulation]
    ADD CONSTRAINT [DF_formulation_owner] DEFAULT (suser_name()) FOR [owner];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_formulation_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[formulation]
    ADD CONSTRAINT [DF_formulation_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_supplier_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[supplier]
    ADD CONSTRAINT [DF_supplier_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_role_hourly_rate]" wird erstellt...';


GO
ALTER TABLE [dbo].[role]
    ADD CONSTRAINT [DF_role_hourly_rate] DEFAULT ((0)) FOR [hourly_rate];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_role_adminrole]" wird erstellt...';


GO
ALTER TABLE [dbo].[role]
    ADD CONSTRAINT [DF_role_adminrole] DEFAULT ((0)) FOR [administrative];


GO
PRINT N'DEFAULT-Einschränkung "[dbo].[DF_role_deactivate]" wird erstellt...';


GO
ALTER TABLE [dbo].[role]
    ADD CONSTRAINT [DF_role_deactivate] DEFAULT ((0)) FOR [deactivate];


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_customfield_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_customfield]
    ADD CONSTRAINT [FK_request_customfield_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_workplace_department]" wird erstellt...';


GO
ALTER TABLE [dbo].[workplace]
    ADD CONSTRAINT [FK_workplace_department] FOREIGN KEY ([department]) REFERENCES [dbo].[department] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_condition_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[condition]
    ADD CONSTRAINT [FK_condition_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_component_formulation]" wird erstellt...';


GO
ALTER TABLE [dbo].[component]
    ADD CONSTRAINT [FK_component_formulation] FOREIGN KEY ([formulation]) REFERENCES [dbo].[formulation] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_uncertainty_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[uncertainty]
    ADD CONSTRAINT [FK_uncertainty_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_billing_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE SET NULL;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_contact]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_contact] FOREIGN KEY ([sampler]) REFERENCES [dbo].[contact] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_formulation]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_formulation] FOREIGN KEY ([formulation]) REFERENCES [dbo].[formulation] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_priority]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_priority] FOREIGN KEY ([priority]) REFERENCES [dbo].[priority] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_profile]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_profile] FOREIGN KEY ([profile]) REFERENCES [dbo].[profile] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_project]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_smpcondition]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_smpcondition] FOREIGN KEY ([smpcondition]) REFERENCES [dbo].[smpcondition] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_smpcontainer]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_smpcontainer] FOREIGN KEY ([smpcontainer]) REFERENCES [dbo].[smpcontainer] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_smpmatrix]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_smpmatrix] FOREIGN KEY ([smpmatrix]) REFERENCES [dbo].[smpmatrix] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_smppoint]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_smppoint] FOREIGN KEY ([smppoint]) REFERENCES [dbo].[smppoint] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_smppreservation]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_smppreservation] FOREIGN KEY ([smppreservation]) REFERENCES [dbo].[smppreservation] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_smptype]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_smptype] FOREIGN KEY ([smptype]) REFERENCES [dbo].[smptype] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_state]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_state] FOREIGN KEY ([state]) REFERENCES [dbo].[state] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_workflow]" wird erstellt...';


GO
ALTER TABLE [dbo].[request]
    ADD CONSTRAINT [FK_request_workflow] FOREIGN KEY ([workflow]) REFERENCES [dbo].[workflow] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_cvalidate_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[cvalidate]
    ADD CONSTRAINT [FK_cvalidate_analysis] FOREIGN KEY ([analysis_id]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_cfield_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[cfield]
    ADD CONSTRAINT [FK_cfield_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_users_contact]" wird erstellt...';


GO
ALTER TABLE [dbo].[users]
    ADD CONSTRAINT [FK_users_contact] FOREIGN KEY ([contact]) REFERENCES [dbo].[contact] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_users_role]" wird erstellt...';


GO
ALTER TABLE [dbo].[users]
    ADD CONSTRAINT [FK_users_role] FOREIGN KEY ([role]) REFERENCES [dbo].[role] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_task_project]" wird erstellt...';


GO
ALTER TABLE [dbo].[task]
    ADD CONSTRAINT [FK_task_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_task_users]" wird erstellt...';


GO
ALTER TABLE [dbo].[task]
    ADD CONSTRAINT [FK_task_users] FOREIGN KEY ([responsible]) REFERENCES [dbo].[users] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_service_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_service]
    ADD CONSTRAINT [FK_request_service_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_service_service]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_service]
    ADD CONSTRAINT [FK_request_service_service] FOREIGN KEY ([service]) REFERENCES [dbo].[service] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_project_service_task]" wird erstellt...';


GO
ALTER TABLE [dbo].[task_service]
    ADD CONSTRAINT [FK_project_service_task] FOREIGN KEY ([task]) REFERENCES [dbo].[task] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_task_service_billing_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[task_service]
    ADD CONSTRAINT [FK_task_service_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE SET NULL;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_project_material_task]" wird erstellt...';


GO
ALTER TABLE [dbo].[task_material]
    ADD CONSTRAINT [FK_project_material_task] FOREIGN KEY ([task]) REFERENCES [dbo].[task] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_task_material_billing_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[task_material]
    ADD CONSTRAINT [FK_task_material_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE SET NULL;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_project_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[project]
    ADD CONSTRAINT [FK_project_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_project_profile]" wird erstellt...';


GO
ALTER TABLE [dbo].[project]
    ADD CONSTRAINT [FK_project_profile] FOREIGN KEY ([profile]) REFERENCES [dbo].[profile] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_project_customfield_project]" wird erstellt...';


GO
ALTER TABLE [dbo].[project_customfield]
    ADD CONSTRAINT [FK_project_customfield_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_method_qualification_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[qualification]
    ADD CONSTRAINT [FK_method_qualification_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_method_qualification_users]" wird erstellt...';


GO
ALTER TABLE [dbo].[qualification]
    ADD CONSTRAINT [FK_method_qualification_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_qualification_contact]" wird erstellt...';


GO
ALTER TABLE [dbo].[qualification]
    ADD CONSTRAINT [FK_qualification_contact] FOREIGN KEY ([performed_by]) REFERENCES [dbo].[contact] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_material_material]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_material]
    ADD CONSTRAINT [FK_request_material_material] FOREIGN KEY ([material]) REFERENCES [dbo].[material] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_material_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_material]
    ADD CONSTRAINT [FK_request_material_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_task_workload_billing_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[task_workload]
    ADD CONSTRAINT [FK_task_workload_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE SET NULL;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_workload_task]" wird erstellt...';


GO
ALTER TABLE [dbo].[task_workload]
    ADD CONSTRAINT [FK_workload_task] FOREIGN KEY ([task]) REFERENCES [dbo].[task] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_role_permission_permission]" wird erstellt...';


GO
ALTER TABLE [dbo].[role_permission]
    ADD CONSTRAINT [FK_role_permission_permission] FOREIGN KEY ([permission]) REFERENCES [dbo].[permission] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_role_permission_role]" wird erstellt...';


GO
ALTER TABLE [dbo].[role_permission]
    ADD CONSTRAINT [FK_role_permission_role] FOREIGN KEY ([role]) REFERENCES [dbo].[role] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_measurement_condition_condition]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement_condition]
    ADD CONSTRAINT [FK_measurement_condition_condition] FOREIGN KEY ([condition]) REFERENCES [dbo].[condition] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_measurement_condition_measurement]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement_condition]
    ADD CONSTRAINT [FK_measurement_condition_measurement] FOREIGN KEY ([measurement]) REFERENCES [dbo].[measurement] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_strposition_material]" wird erstellt...';


GO
ALTER TABLE [dbo].[strposition]
    ADD CONSTRAINT [FK_strposition_material] FOREIGN KEY ([material]) REFERENCES [dbo].[material] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_strposition_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[strposition]
    ADD CONSTRAINT [FK_strposition_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_strposition_smpcontainer]" wird erstellt...';


GO
ALTER TABLE [dbo].[strposition]
    ADD CONSTRAINT [FK_strposition_smpcontainer] FOREIGN KEY ([container]) REFERENCES [dbo].[smpcontainer] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_strposition_storage]" wird erstellt...';


GO
ALTER TABLE [dbo].[strposition]
    ADD CONSTRAINT [FK_strposition_storage] FOREIGN KEY ([storage]) REFERENCES [dbo].[storage] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_traversal_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[traversal]
    ADD CONSTRAINT [FK_traversal_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_analysis_technique]" wird erstellt...';


GO
ALTER TABLE [dbo].[analysis]
    ADD CONSTRAINT [FK_analysis_technique] FOREIGN KEY ([technique]) REFERENCES [dbo].[technique] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_billing_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_instrument]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_instrument] FOREIGN KEY ([instrument]) REFERENCES [dbo].[instrument] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_instrument_certificate]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_instrument_certificate] FOREIGN KEY ([certificate]) REFERENCES [dbo].[certificate] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_manufacturer]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_manufacturer] FOREIGN KEY ([manufacturer]) REFERENCES [dbo].[manufacturer] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_material]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_material] FOREIGN KEY ([material]) REFERENCES [dbo].[material] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_project]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_qualification]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_qualification] FOREIGN KEY ([qualification]) REFERENCES [dbo].[qualification] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_service]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_service] FOREIGN KEY ([service]) REFERENCES [dbo].[service] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_supplier]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_supplier] FOREIGN KEY ([supplier]) REFERENCES [dbo].[supplier] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_task]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_task] FOREIGN KEY ([task]) REFERENCES [dbo].[task] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_attachment_users]" wird erstellt...';


GO
ALTER TABLE [dbo].[attachment]
    ADD CONSTRAINT [FK_attachment_users] FOREIGN KEY ([responsible]) REFERENCES [dbo].[users] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_measurement_cfield_cfield]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement_cfield]
    ADD CONSTRAINT [FK_measurement_cfield_cfield] FOREIGN KEY ([cfield]) REFERENCES [dbo].[cfield] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_measurement_cfield_measurement]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement_cfield]
    ADD CONSTRAINT [FK_measurement_cfield_measurement] FOREIGN KEY ([measurement]) REFERENCES [dbo].[measurement] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_instrument_instrument_type]" wird erstellt...';


GO
ALTER TABLE [dbo].[instrument]
    ADD CONSTRAINT [FK_instrument_instrument_type] FOREIGN KEY ([type]) REFERENCES [dbo].[instype] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_instrument_manufacturer]" wird erstellt...';


GO
ALTER TABLE [dbo].[instrument]
    ADD CONSTRAINT [FK_instrument_manufacturer] FOREIGN KEY ([manufacturer]) REFERENCES [dbo].[manufacturer] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_instrument_supplier]" wird erstellt...';


GO
ALTER TABLE [dbo].[instrument]
    ADD CONSTRAINT [FK_instrument_supplier] FOREIGN KEY ([supplier]) REFERENCES [dbo].[supplier] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_instrument_workplace]" wird erstellt...';


GO
ALTER TABLE [dbo].[instrument]
    ADD CONSTRAINT [FK_instrument_workplace] FOREIGN KEY ([workplace]) REFERENCES [dbo].[workplace] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_billing_customer_billing]" wird erstellt...';


GO
ALTER TABLE [dbo].[billing_customer]
    ADD CONSTRAINT [FK_billing_customer_billing] FOREIGN KEY ([billing]) REFERENCES [dbo].[billing] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_project_member_project]" wird erstellt...';


GO
ALTER TABLE [dbo].[project_member]
    ADD CONSTRAINT [FK_project_member_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_project_member_users]" wird erstellt...';


GO
ALTER TABLE [dbo].[project_member]
    ADD CONSTRAINT [FK_project_member_users] FOREIGN KEY ([users]) REFERENCES [dbo].[users] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_step_state]" wird erstellt...';


GO
ALTER TABLE [dbo].[step]
    ADD CONSTRAINT [FK_step_state] FOREIGN KEY ([state]) REFERENCES [dbo].[state] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_handbook_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[handbook]
    ADD CONSTRAINT [FK_handbook_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_method_analysis_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[method_analysis]
    ADD CONSTRAINT [FK_method_analysis_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_method_analysis_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[method_analysis]
    ADD CONSTRAINT [FK_method_analysis_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_material_supplier]" wird erstellt...';


GO
ALTER TABLE [dbo].[material]
    ADD CONSTRAINT [FK_material_supplier] FOREIGN KEY ([supplier]) REFERENCES [dbo].[supplier] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_measurement_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [FK_measurement_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_measurement_instrument]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [FK_measurement_instrument] FOREIGN KEY ([instrument]) REFERENCES [dbo].[instrument] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_measurement_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [FK_measurement_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_measurement_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[measurement]
    ADD CONSTRAINT [FK_measurement_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_smppoint_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[smppoint]
    ADD CONSTRAINT [FK_smppoint_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_laboratory_contact]" wird erstellt...';


GO
ALTER TABLE [dbo].[laboratory]
    ADD CONSTRAINT [FK_laboratory_contact] FOREIGN KEY ([manager]) REFERENCES [dbo].[contact] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_profile_analysis_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile_analysis]
    ADD CONSTRAINT [FK_profile_analysis_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_profile_analysis_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile_analysis]
    ADD CONSTRAINT [FK_profile_analysis_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_profile_analysis_profile]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile_analysis]
    ADD CONSTRAINT [FK_profile_analysis_profile] FOREIGN KEY ([profile]) REFERENCES [dbo].[profile] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_instrument_method_instrument]" wird erstellt...';


GO
ALTER TABLE [dbo].[instrument_method]
    ADD CONSTRAINT [FK_instrument_method_instrument] FOREIGN KEY ([instrument]) REFERENCES [dbo].[instrument] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_instrument_method_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[instrument_method]
    ADD CONSTRAINT [FK_instrument_method_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_analysis-attribute_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[attribute]
    ADD CONSTRAINT [FK_analysis-attribute_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_state_workflow]" wird erstellt...';


GO
ALTER TABLE [dbo].[state]
    ADD CONSTRAINT [FK_state_workflow] FOREIGN KEY ([workflow]) REFERENCES [dbo].[workflow] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_profile_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile]
    ADD CONSTRAINT [FK_profile_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_profile_strposition]" wird erstellt...';


GO
ALTER TABLE [dbo].[profile]
    ADD CONSTRAINT [FK_profile_strposition] FOREIGN KEY ([reference_material]) REFERENCES [dbo].[strposition] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_method_smptype_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[method_smptype]
    ADD CONSTRAINT [FK_method_smptype_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_method_smptype_smptype]" wird erstellt...';


GO
ALTER TABLE [dbo].[method_smptype]
    ADD CONSTRAINT [FK_method_smptype_smptype] FOREIGN KEY ([smptype]) REFERENCES [dbo].[smptype] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_analysis_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_analysis]
    ADD CONSTRAINT [FK_request_analysis_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_analysis_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_analysis]
    ADD CONSTRAINT [FK_request_analysis_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_request_analysis_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[request_analysis]
    ADD CONSTRAINT [FK_request_analysis_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_instrument_certificate_contact]" wird erstellt...';


GO
ALTER TABLE [dbo].[certificate]
    ADD CONSTRAINT [FK_instrument_certificate_contact] FOREIGN KEY ([performed_by]) REFERENCES [dbo].[contact] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_instrument_certificate_contact1]" wird erstellt...';


GO
ALTER TABLE [dbo].[certificate]
    ADD CONSTRAINT [FK_instrument_certificate_contact1] FOREIGN KEY ([reviewed_by]) REFERENCES [dbo].[contact] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_instrument_certificate_instrument]" wird erstellt...';


GO
ALTER TABLE [dbo].[certificate]
    ADD CONSTRAINT [FK_instrument_certificate_instrument] FOREIGN KEY ([instrument]) REFERENCES [dbo].[instrument] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_mailqueue_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[mailqueue]
    ADD CONSTRAINT [FK_mailqueue_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_contact_customer1]" wird erstellt...';


GO
ALTER TABLE [dbo].[contact]
    ADD CONSTRAINT [FK_contact_customer1] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_formulation_project]" wird erstellt...';


GO
ALTER TABLE [dbo].[formulation]
    ADD CONSTRAINT [FK_formulation_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_billing_position_analysis]" wird erstellt...';


GO
ALTER TABLE [dbo].[billing_position]
    ADD CONSTRAINT [FK_billing_position_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_billing_position_billing_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[billing_position]
    ADD CONSTRAINT [FK_billing_position_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_billing_position_material]" wird erstellt...';


GO
ALTER TABLE [dbo].[billing_position]
    ADD CONSTRAINT [FK_billing_position_material] FOREIGN KEY ([material]) REFERENCES [dbo].[material] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_billing_position_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[billing_position]
    ADD CONSTRAINT [FK_billing_position_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_billing_position_profile]" wird erstellt...';


GO
ALTER TABLE [dbo].[billing_position]
    ADD CONSTRAINT [FK_billing_position_profile] FOREIGN KEY ([profile]) REFERENCES [dbo].[profile] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_billing_position_service]" wird erstellt...';


GO
ALTER TABLE [dbo].[billing_position]
    ADD CONSTRAINT [FK_billing_position_service] FOREIGN KEY ([service]) REFERENCES [dbo].[service] ([id]);


GO
PRINT N'Fremdschlüssel "[dbo].[FK_btcposition_batch]" wird erstellt...';


GO
ALTER TABLE [dbo].[btcposition]
    ADD CONSTRAINT [FK_btcposition_batch] FOREIGN KEY ([batch]) REFERENCES [dbo].[batch] ([id]) ON DELETE CASCADE;


GO
PRINT N'Fremdschlüssel "[dbo].[FK_btcposition_request]" wird erstellt...';


GO
ALTER TABLE [dbo].[btcposition]
    ADD CONSTRAINT [FK_btcposition_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]);


GO
PRINT N'CHECK-Einschränkung "[dbo].[CK_customer]" wird erstellt...';


GO
ALTER TABLE [dbo].[customer]
    ADD CONSTRAINT [CK_customer] CHECK ([discount]>=(0) AND [discount]<=(100));


GO
PRINT N'CHECK-Einschränkung "[dbo].[CK_setup]" wird erstellt...';


GO
ALTER TABLE [dbo].[setup]
    ADD CONSTRAINT [CK_setup] CHECK ([vat]>=(0) AND [vat]<=(100));


GO
PRINT N'CHECK-Einschränkung "[dbo].[CK_method]" wird erstellt...';


GO
ALTER TABLE [dbo].[method]
    ADD CONSTRAINT [CK_method] CHECK ([price]>=(0));


GO
PRINT N'Trigger "[dbo].[request_customfield_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2023 May
-- Description:	-
-- =============================================
CREATE TRIGGER request_customfield_audit 
   ON  dbo.request_customfield
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[workplace_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[workplace_update]
   ON  dbo.workplace 
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT COUNT(id) FROM instrument WHERE workplace = (SELECT id FROM inserted) AND deactivate = 0) > 0 AND (SELECT deactivate FROM inserted) = 1
		THROW 51000, 'Deactivation failed. Workplace still has active instruments.', 1
END
GO
PRINT N'Trigger "[dbo].[workplace_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[workplace_audit]
   ON  [dbo].[workplace]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[condition_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[condition_insert_update] 
   ON  dbo.condition 
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @type CHAR(1)
	
	SET @type = (SELECT type FROM inserted)

	IF @type != 'N' and @type != 'A' and @type != 'T'
		THROW 51000, 'Type non valid. Choose N-Numeric, A-Attributive or S-String.', 1

	IF @type = 'A' and (SELECT attributes FROM inserted) IS NULL
		THROW 51000, 'Attributes missing.', 1
END
GO
PRINT N'Trigger "[dbo].[condition_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[condition_audit] 
   ON  [dbo].[condition]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[component_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[component_audit]
   ON  [dbo].[component]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[uncertainty_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[uncertainty_insert_update]
   ON  [dbo].[uncertainty]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @min FLOAT
	DECLARE @max FLOAT

	SET @min = (SELECT value_min FROM inserted)
	SET @max = (SELECT value_max FROM inserted)

	IF (SELECT value_max FROM inserted) < (SELECT value_min FROM inserted)
		THROW 51000, 'value_max is smaller value_min', 1

	IF NOT (SELECT value_min FROM inserted) < (SELECT MIN(value_min) FROM uncertainty WHERE analysis = (SELECT analysis FROM inserted) AND value_max > (SELECT value_min FROM inserted) AND id <> (SELECT id FROM inserted))
		THROW 51000, 'value_min already covered', 1	
	
	IF NOT (SELECT value_max FROM inserted) <= (SELECT MIN(value_min) FROM uncertainty WHERE analysis = (SELECT analysis FROM inserted) AND value_min > (SELECT value_min FROM inserted) AND id <> (SELECT id FROM inserted))
		THROW 51000, 'value_max already covered', 1
END
GO
PRINT N'Trigger "[dbo].[uncertainty_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[uncertainty_audit]
   ON  [dbo].[uncertainty]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[workflow_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[workflow_audit]
   ON  [dbo].[workflow] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[request_delete]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	Delete sub requests
-- =============================================
CREATE TRIGGER request_delete
   ON  dbo.request 
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DELETE FROM request WHERE subrequest = (SELECT id FROM deleted)
END
GO
PRINT N'Trigger "[dbo].[request_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Audit Log
-- =============================================
CREATE TRIGGER [dbo].[request_audit]
   ON  dbo.request
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[cvalidate_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[cvalidate_insert_update] 
   ON  [dbo].[cvalidate]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )  
	BEGIN
		IF (SELECT analysis_id FROM inserted) IS NULL AND (SELECT cfield_id FROM inserted) IS NULL
			THROW 51000, 'Whether cfield_id or analysis_id need to be chosen.', 1
		
		IF (SELECT analysis_id FROM inserted) IS NOT NULL AND (SELECT cfield_id FROM inserted) IS NOT NULL
			THROW 51000, 'Whether cfield_id or analysis_id need to be null.', 1

		IF ((SELECT analysis_id FROM inserted) NOT IN (SELECT id FROM analysis) AND (SELECT analysis_id FROM inserted) IS NOT NULL) OR ((SELECT cfield_id FROM inserted) NOT IN (SELECT id FROM cfield) AND (SELECT cfield_id FROM inserted) IS NOT NULL)
			THROW 51000, 'Whether cfield_id or analysis_id not known.', 1
	END
END
GO
PRINT N'Trigger "[dbo].[cfield_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[cfield_audit] 
   ON  [dbo].[cfield]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[cfield_update_insert]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[cfield_update_insert]
   ON  dbo.cfield
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @id INT

	SET @id = (SELECT analysis FROM inserted)

	IF (SELECT analysis_id FROM inserted) IS NOT NULL AND (SELECT analysis_id FROM inserted) NOT IN (SELECT id FROM analysis)
		THROW 51000, 'Analysis not found.', 1

	IF (SELECT analysis_id FROM inserted) IS NOT NULL
	BEGIN
		UPDATE cfield SET title = NULL WHERE id = (SELECT id FROM inserted)
		UPDATE cfield SET unit = NULL WHERE id = (SELECT id FROM inserted)
	END

	DELETE FROM cvalidate WHERE analysis = @id
	INSERT INTO cvalidate (cfield_id, analysis_id, analysis) SELECT id, null, @id FROM cfield WHERE analysis = @id AND analysis_id IS NULL
	INSERT INTO cvalidate (cfield_id, analysis_id, analysis) SELECT null, analysis_id, @id FROM cfield WHERE analysis = @id AND analysis_id IS NOT NULL
END
GO
PRINT N'Trigger "[dbo].[cfield_delete]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[cfield_delete] 
   ON  [dbo].[cfield]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )  
	BEGIN
		DELETE FROM cvalidate WHERE analysis = (SELECT id from deleted) AND cfield_id = (SELECT id FROM deleted) OR analysis_id = (SELECT analysis_id FROM deleted)
	END
END
GO
PRINT N'Trigger "[dbo].[users_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER users_audit 
   ON  users
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[task_attachment]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 June
-- Description:	Delete attachments
-- =============================================
CREATE TRIGGER task_attachment
   ON  dbo.task
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DELETE FROM attachment WHERE task = (SELECT id FROM deleted)
END
GO
PRINT N'Trigger "[dbo].[task_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER task_audit
   ON  dbo.task
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[request_service_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER request_service_audit 
   ON  request_service
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[task_service_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER task_service_audit
   ON  task_service
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[task_material_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER task_material_audit
   ON  task_material 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[service_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2023 October
-- Description:	-
-- =============================================
CREATE TRIGGER service_audit
   ON  service
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[project_insert]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2023 June
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[project_insert]
   ON  [dbo].[project]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	-- Insert custom fields
	INSERT INTO project_customfield (field_name, project) SELECT field_name, (SELECT id FROM inserted) FROM customfield WHERE table_name = 'project'

END
GO
PRINT N'Trigger "[dbo].[project_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[project_audit]
   ON  dbo.project
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[translation_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER translation_audit 
   ON  translation
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[qualification_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[qualification_insert_update]
   ON  dbo.qualification 
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT valid_from FROM inserted) > (SELECT valid_till FROM inserted)
		THROW 51000, 'Wrong qualification dates.', 1
END
GO
PRINT N'Trigger "[dbo].[quaification_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[quaification_audit]
   ON  [dbo].[qualification] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[request_material_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER request_material_audit 
   ON  request_material 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[workload_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER workload_audit 
   ON  [dbo].[task_workload]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[role_permission_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[role_permission_audit]
   ON  [dbo].[role_permission]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[measurement_condition_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_condition_audit] 
   ON  [dbo].[measurement_condition]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[measurement_condition_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_condition_update]
   ON  [dbo].[measurement_condition]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @value_changed BIT
	DECLARE @state CHAR(2)
	DECLARE @t TABLE(id INT IDENTITY(1,1) PRIMARY KEY, value NVARCHAR(256))

	-- Check if state allow capturing
	SET @state = (SELECT state FROM measurement INNER JOIN measurement_condition ON measurement.id = measurement_condition.measurement WHERE measurement_condition.id = (SELECT id FROM inserted))
	IF @state <> 'CP' 
		THROW 51000, 'Not able to capture. State does not match CP.', 1

	-- Set value changed bit
	IF (SELECT value_txt FROM inserted) <> (SELECT value_txt FROM deleted) OR (SELECT value_num FROM inserted) <> (SELECT value_num FROM deleted) OR ((SELECT value_num FROM inserted) IS NOT NULL AND (SELECT value_num FROM deleted) IS NULL) OR (((SELECT value_txt FROM inserted) IS NOT NULL AND (SELECT value_txt FROM deleted) IS NULL))
			SET @value_changed = 1
		ELSE
			SET @value_changed = 0

	-- Set value_txt in case of attribute results
	IF (SELECT type FROM condition WHERE id = (SELECT condition FROM inserted)) = 'A'
	BEGIN
		INSERT INTO @t (value) SELECT value FROM STRING_SPLIT( (SELECT attributes FROM condition WHERE id = (SELECT condition FROM inserted)) , ',')
		UPDATE measurement_condition SET value_txt = (SELECT value FROM @t WHERE id = (SELECT value_num FROM inserted)) WHERE id = (SELECT id FROM inserted)
	END

	-- Set value_txt in case of numeric values
	IF (SELECT type FROM condition WHERE id = (SELECT condition FROM inserted)) = 'N'
	BEGIN
		UPDATE measurement_condition SET value_txt = (SELECT value_num FROM inserted) WHERE id = (SELECT id FROM inserted)
	END
END
GO
PRINT N'Trigger "[dbo].[strpostion_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[strpostion_insert_update]
   ON  [dbo].[strposition]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT COUNT(*) FROM strposition WHERE storage = (SELECT storage FROM inserted) AND request = (SELECT request FROM inserted) AND (SELECT request FROM inserted) IS NOT NULL AND id <> (SELECT id FROM inserted)) > 0
		THROW 51000, 'Already stored.', 1

	IF (SELECT COUNT(*) FROM strposition WHERE storage = (SELECT storage FROM inserted) AND position = (SELECT position FROM inserted) AND (SELECT id FROM inserted) <> id) > 0
		THROW 51000, 'Position already created.', 1
END
GO
PRINT N'Trigger "[dbo].[strposition_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[strposition_audit]
   ON  [dbo].[strposition] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[filter_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	Check validity of global filter
-- =============================================
CREATE TRIGGER [dbo].[filter_insert_update]
   ON  [dbo].[filter] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT userid FROM inserted) IS NULL AND (SELECT global FROM inserted) = 0
		THROW 51000, 'Filter without user id need to be global.', 1
END
GO
PRINT N'Trigger "[dbo].[analysis_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 April
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[analysis_audit] 
   ON  dbo.analysis
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[analysis_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[analysis_insert_update]
   ON  dbo.analysis
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT deactivate FROM inserted) = 1 AND (SELECT COUNT(id) FROM method_analysis WHERE applies = 1 AND analysis = (SELECT (id) FROM inserted)) > 0
		THROW 51000, 'Deactivation failed. Analysis is still in use.', 1

	-- Update instrument_method and method_analysis cross table
	DECLARE @id INT

	SET @id = (SELECT id FROM inserted)

	IF NOT EXISTS (SELECT id FROM deleted)
	BEGIN
		INSERT INTO method_analysis (method, analysis) SELECT id, @id FROM method WHERE id NOT IN (SELECT method FROM method_analysis WHERE analysis = @id) AND deactivate = 0
	END

	IF (SELECT calculation_activate FROM inserted) = 1 AND (SELECT calculation FROM inserted) IS NULL
		THROW 51000, 'Activation failed. Calculation not found.', 1

	IF (SELECT ldl FROM inserted) > (SELECT udl FROM inserted)
		THROW 51000,  'LDL bigger than UDL.', 1

	IF (SELECT precision FROM inserted) < 0
		THROW 51000,  'Precision must be zero or bigger.', 1

	IF (SELECT type FROM inserted) <> 'N' AND (SELECT type FROM inserted) <> 'A' AND (SELECT type FROM inserted) <> 'T'
		THROW 51000,  'Type unknown.', 1
END
GO
PRINT N'Trigger "[dbo].[analysis_delete]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[analysis_delete] 
   ON  dbo.analysis 
   INSTEAD OF DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @err_msg NVARCHAR(MAX)

	IF (SELECT COUNT(*) FROM cfield WHERE analysis_id = (SELECT id FROM deleted)) > 0 OR (SELECT COUNT(*) FROM profile_analysis WHERE analysis = (SELECT id FROM deleted) AND applies = 1) > 0
		THROW 51000, 'Can not delete. Analysis used in cfield or profile.', 1
	ELSE
		DELETE FROM analysis WHERE id = (SELECT id FROM deleted)
END
GO
PRINT N'Trigger "[dbo].[department_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[department_audit]
   ON  [dbo].[department] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[department_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[department_update]
   ON  dbo.department
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT COUNT(id) FROM workplace WHERE department = (SELECT id FROM inserted) AND deactivate = 0) > 0 AND (SELECT deactivate FROM inserted) = 1
		THROW 51000, 'Deactivation failed. Department still has active workplaces.', 1
END
GO
PRINT N'Trigger "[dbo].[technique_aduit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[technique_aduit]
   ON  dbo.technique
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[attachment_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 June
-- Description:	Version control validity check
-- ==============================================
CREATE TRIGGER [dbo].[attachment_update]
   ON  dbo.attachment
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT version_control FROM inserted) = 1 AND ((SELECT reminder FROM inserted) = NULL OR (SELECT responsible FROM inserted) = NULL OR (SELECT repetition FROM inserted) = NULL)
		THROW 51000, 'Version control needs reminder, revision and repetion values to be set.', 1 

	IF (SELECT version_control FROM inserted) = 1 AND (SELECT revision FROM inserted) <> (SELECT revision FROM deleted)
		UPDATE attachment SET reminder = DateAdd(day, (SELECT repetition FROM inserted), GetDate()) WHERE id = (SELECT id FROM inserted)
END
GO
PRINT N'Trigger "[dbo].[attachment_insert]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[attachment_insert] 
   ON  dbo.attachment
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT version_control FROM inserted) = 1 AND ((SELECT reminder FROM inserted) = NULL OR (SELECT responsible FROM inserted) = NULL OR (SELECT repetition FROM inserted) = NULL)
		THROW 51000, 'Version control needs reminder, revision and repetion values to be set.', 1 
END
GO
PRINT N'Trigger "[dbo].[attachment_audit]" wird erstellt...';


GO
-- ==================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 June
-- Description:	Audit trail support in case of
-- version control
-- ==================================================
CREATE TRIGGER [dbo].[attachment_audit]
   ON  dbo.attachment
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT version_control FROM inserted) = 1
	BEGIN
		DECLARE @table_name nvarchar(256)
		DECLARE @table_id INT
		DECLARE @action_type char(1)
		DECLARE @inserted xml, @deleted xml

		IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
		RETURN;

		-- Get table infos
		SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

		-- Get action
		IF EXISTS (SELECT * FROM inserted)
			BEGIN
				SELECT @table_id = id FROM inserted
				IF EXISTS (SELECT * FROM deleted)
					SELECT @action_type = 'U'
				ELSE
					SELECT @action_type = 'I'
			END
		ELSE
			BEGIN
				SELECT @table_id = id FROM deleted
				SELECT @action_type = 'D'
			END

		-- Create xml log
		SET @inserted = (SELECT * FROM inserted FOR XML PATH)
		SET @deleted = (SELECT * FROM deleted FOR XML PATH)

		-- Insert log
		INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
		SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
	END
END
GO
PRINT N'Trigger "[dbo].[measurement_cfield_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_cfield_audit]
   ON  [dbo].[measurement_cfield] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[measurement_cfield_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_cfield_update]
   ON  [dbo].[measurement_cfield] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		DECLARE @state CHAR(2)

		-- Check if state allow capturing
		SET @state = (SELECT state FROM measurement INNER JOIN measurement_cfield ON measurement.id = measurement_cfield.measurement WHERE measurement_cfield.id = (SELECT id FROM inserted))
		IF @state <> 'CP' 
			THROW 51000, 'Not able to capture. State does not match CP.', 1
	END
END
GO
PRINT N'Trigger "[dbo].[instype_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[instype_audit]
   ON  [dbo].[instype]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[smpcontainer_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[smpcontainer_audit] 
   ON  [dbo].[smpcontainer]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[permission_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[permission_insert_update]
   ON  dbo.permission
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @permission INT
	SET @permission = (SELECT id FROM inserted)
	INSERT INTO role_permission (role, permission)
	SELECT id, @permission FROM role WHERE id NOT IN (SELECT DISTINCT(role_permission.role) FROM role_permission WHERE permission = @permission)
END
GO
PRINT N'Trigger "[dbo].[permission_delete]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[permission_delete] 
   ON  dbo.permission 
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DELETE FROM role_permission WHERE permission = (SELECT id FROM inserted)
END
GO
PRINT N'Trigger "[dbo].[permission_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[permission_audit]
   ON  [dbo].[permission]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[smpcondition_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[smpcondition_audit]
   ON [dbo].[smpcondition]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[columns_insert_udpate]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 OCtober
-- Description:	Delete rows with user set to ''
-- =============================================
CREATE TRIGGER [dbo].[columns_insert_udpate]
   ON  [dbo].[columns]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	IF (SELECT USER_ID FROM inserted) <> ''
		INSERT INTO columns (user_id, table_id, column_id, column_width, column_hidden, column_order) SELECT user_id, table_id, column_id, column_width, column_hidden, column_order FROM inserted

END
GO
PRINT N'Trigger "[dbo].[instrument_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[instrument_audit]
   ON  [dbo].[instrument] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[instrument_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[instrument_insert_update] 
   ON  dbo.instrument 
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT deactivate FROM inserted) = 1 AND (SELECT COUNT(id) FROM instrument_method WHERE applies = 1 AND instrument = (SELECT (id) FROM inserted)) > 0
		THROW 51000, 'Deactivation failed. Instrument is still in use.', 1
	
	-- Update instrument_method cross table
	IF NOT EXISTS (SELECT id FROM deleted)
		INSERT INTO instrument_method (instrument, method) SELECT (SELECT id FROM inserted), id FROM method WHERE id NOT IN (SELECT method FROM instrument_method WHERE instrument = (SELECT id FROM inserted)) AND deactivate = 0
END
GO
PRINT N'Trigger "[dbo].[billing_customer_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER billing_customer_audit
   ON  dbo.billing_customer
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[project_member_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[project_member_audit]
   ON  [dbo].[project_member]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[step_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[step_audit]
   ON  [dbo].[step]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[method_analysis_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[method_analysis_insert_update]
   ON  [dbo].[method_analysis]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		IF (SELECT COUNT(*) FROM method_analysis WHERE analysis = (SELECT analysis FROM inserted) AND standard = 1) > 1
			THROW 51000, 'One standard method allowed only.', 1
	END
END
GO
PRINT N'Trigger "[dbo].[method_analysis_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[method_analysis_audit]
   ON  [dbo].[method_analysis]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[customfield_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER customfield_audit 
   ON  customfield 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[material_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[material_audit]
   ON  dbo.material
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[smptype_insert]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 November
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[smptype_insert]
   ON  [dbo].[smptype]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @id INT
	SET @id = (SELECT id FROM inserted)

	-- Update method_smptype cross table
	INSERT INTO method_smptype (method, smptype) SELECT id, @id FROM method WHERE id NOT IN (SELECT method FROM method_smptype WHERE smptype = @id) AND deactivate = 0
END
GO
PRINT N'Trigger "[dbo].[smptype_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[smptype_audit]
   ON  [dbo].[smptype]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[manufacturer_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[manufacturer_audit]
   ON  [dbo].[manufacturer] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[smppreservation_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[smppreservation_audit]
   ON  [dbo].[smppreservation] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[customer_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[customer_audit]
   ON  dbo.customer
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[measurement_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_audit]
   ON  dbo.measurement 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[smppoint_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[smppoint_audit]
   ON  [dbo].[smppoint]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[laboratory_insert]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[laboratory_insert] 
   ON  dbo.laboratory
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT COUNT(id) FROM laboratory) > 1
		THROW 51000, 'Only one row laboratory is allowed.', 1
END
GO
PRINT N'Trigger "[dbo].[laboratory_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[laboratory_audit]
   ON  [dbo].[laboratory]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[setup_insert]" wird erstellt...';


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
GO
PRINT N'Trigger "[dbo].[smpmatrix_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[smpmatrix_audit]
   ON  [dbo].[smpmatrix]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[profile_analysis_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[profile_analysis_audit]
   ON  dbo.profile_analysis
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[profile_analysis_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[profile_analysis_update] 
   ON  dbo.profile_analysis
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT applies FROM inserted) = 1
		UPDATE profile_analysis SET applies = 1 WHERE analysis IN (SELECT analysis_ID FROM cfield WHERE analysis = (SELECT analysis FROM inserted) AND analysis_id IS NOT NULL)

	IF (SELECT lsl FROM inserted) > (SELECT usl FROM inserted)
		THROW 51000, 'LSL bigger than USL.', 1
END
GO
PRINT N'Trigger "[dbo].[instrument_method_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[instrument_method_insert_update]
   ON  [dbo].[instrument_method]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		IF (SELECT COUNT(*) FROM instrument_method WHERE instrument = (SELECT instrument FROM inserted) AND standard = 1) > 1
			THROW 51000, 'One standard method allowed only.', 1
	END
END
GO
PRINT N'Trigger "[dbo].[instrument_method_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[instrument_method_audit]
   ON  [dbo].[instrument_method]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[batch_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 April
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[batch_audit]
   ON  dbo.batch
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[billing_insert]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[billing_insert]
   ON  [dbo].[billing] 
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @i AS int
	DECLARE @s AS nvarchar(max)
	DECLARE @t TABLE(id INT)
	DECLARE @u TABLE(project INT, customer INT)
	
    -- Insert statements for trigger here

	-- Check dates
	IF (SELECT billing.billing_from FROM billing WHERE id = (SELECT ID FROM inserted)) > (SELECT billing.billing_till FROM billing WHERE id = (SELECT ID FROM inserted))
		THROW 51000, 'From date later then till date.', 1

	-- Insert all customers to be billed into table customer_billing
	INSERT INTO @t SELECT request.customer FROM request WHERE request.invoice = 1 AND request.billing_customer IS NULL
	INSERT INTO @t SELECT project.customer FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_workload ON task.id = task_workload.task LEFT JOIN audit ON audit.table_id = task_workload.id WHERE audit.table_name = 'task_workload' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND task_workload.billing_customer IS NULL AND project.invoice = 1 AND project.customer NOT IN (SELECT id FROM @t) 
	INSERT INTO @t SELECT project.customer FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_material ON task.id = task_material.task LEFT JOIN audit ON audit.table_id = task_material.id WHERE audit.table_name = 'task_material' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND task_material.billing_customer IS NULL AND project.invoice = 1 AND project.customer NOT IN (SELECT id FROM @t)
	INSERT INTO @t SELECT project.customer FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_service ON task.id = task_service.task LEFT JOIN audit ON audit.table_id = task_service.id WHERE audit.table_name = 'task_service' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND task_service.billing_customer IS NULL AND project.invoice = 1 AND project.customer NOT IN (SELECT id FROM @t)

	-- Insert all projects and customers into @u
	INSERT INTO @u SELECT project.id, project.customer FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_workload ON task.id = task_workload.task LEFT JOIN audit ON audit.table_id = task_workload.id WHERE audit.table_name = 'task_workload' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND project.invoice = 1 AND project.id NOT IN (SELECT project FROM @u)
	INSERT INTO @u SELECT project.id, project.customer FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_material ON task.id = task_material.task LEFT JOIN audit ON audit.table_id = task_material.id WHERE audit.table_name = 'task_material' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND project.invoice = 1 AND project.id NOT IN (SELECT project FROM @u)
	INSERT INTO @u SELECT project.id, project.customer FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_service ON task.id = task_service.task LEFT JOIN audit ON audit.table_id = task_service.id WHERE audit.table_name = 'task_service' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND project.invoice = 1 AND project.id NOT IN (SELECT project FROM @u)
	INSERT INTO @t SELECT customer FROM @u WHERE customer NOT IN (SELECT id FROM @t)
	INSERT INTO billing_customer (billing, customer) SELECT (SELECT id FROM inserted), id FROM @t GROUP BY id

	-- For each customer add the requests to be billed
	DECLARE c_customer CURSOR FOR SELECT id FROM billing_customer WHERE billing = (SELECT id FROM inserted)

	OPEN c_customer
	FETCH NEXT FROM c_customer INTO @i
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Update requests for table billing_customer
		SET @s = (SELECT CAST(request.id AS varchar(255)) + ',' FROM request WHERE request.invoice = 1 AND request.billing_customer IS NULL AND request.customer = (SELECT customer from billing_customer WHERE id = @i) GROUP BY request.id FOR xml path(''))
		SET @s = SUBSTRING(@s, 1,len(@s) - 1)
		UPDATE billing_customer SET requests = @s WHERE billing_customer.id = @i

		-- Update projects for table billing_customer
		SET @s = (SELECT CAST(project AS varchar(255)) + ',' FROM @u WHERE customer = (SELECT customer from billing_customer WHERE id = @i) GROUP BY project FOR xml path(''))
		SET @s = SUBSTRING(@s, 1,len(@s) - 1)
		UPDATE billing_customer SET projects = @s WHERE billing_customer.id = @i

		-- Update date delivered for table billing_customer
		SET @s = (SELECT CAST(FORMAT(audit.changed_at, 'd', 'de-de' ) AS varchar(255)) + ',' FROM request LEFT JOIN audit ON request.id = audit.table_id WHERE audit.table_name = 'request' AND audit.action_type = 'I' AND request.invoice = 1 AND request.billing_customer IS NULL AND request.customer = (SELECT customer from billing_customer WHERE id = @i) FOR xml path(''))
		SET @s = SUBSTRING(@s, 1,len(@s) - 1)
		UPDATE billing_customer SET delivered = @s WHERE billing_customer.id = @i

		-- Insert profile based service
		;WITH t (request)
		AS (
		SELECT request.id FROM request WHERE request.invoice = 1 AND request.billing_customer IS NULL AND request.customer = (SELECT customer from billing_customer WHERE id = @i)  GROUP BY request.id
		)
		INSERT INTO billing_position (billing_customer, amount, price, profile,category)
		SELECT 
		(SELECT id from billing_customer WHERE id = @i), 
		COUNT(*), 
		(SELECT price FROM profile WHERE id = profile), 
		profile,
		1
		FROM request WHERE id IN (SELECT request FROM t) AND profile IS NOT NULL GROUP BY profile

		-- Insert provided methods
		;WITH t (request)
		AS (
		SELECT request.id FROM request WHERE request.invoice = 1 AND request.billing_customer IS NULL AND request.customer = (SELECT customer from billing_customer WHERE id = @i) GROUP BY request.id
		)
		INSERT INTO billing_position (billing_customer, amount, price, method, category) 
		SELECT 
			(SELECT id from billing_customer WHERE id = @i), 
			COUNT(*), 
			(SELECT price FROM method WHERE id = (SELECT method FROM inserted)), 
			method,
			2
		FROM measurement WHERE request IN (SELECT request FROM t) AND method IS NOT NULL AND state = 'VD' AND method NOT IN (SELECT method FROM profile_analysis WHERE profile = (SELECT profile FROM request WHERE request.id = measurement.request AND applies = 1) AND method IS NOT NULL) GROUP BY method

		-- Insert analysis services
		;WITH t (request)
		AS (
		SELECT request.id FROM request WHERE request.invoice = 1 AND request.billing_customer IS NULL AND request.customer = (SELECT customer from billing_customer WHERE id = @i) GROUP BY request.id
		)
		INSERT INTO billing_position (billing_customer, amount, price, analysis, category) 
		SELECT 
			(SELECT id from billing_customer WHERE id = @i), 
			COUNT(*), 
			(SELECT price FROM analysis WHERE id = (SELECT analysis FROM inserted)), 
			analysis,
			3
		FROM measurement WHERE request IN (SELECT request FROM t) AND method IS NULL AND state = 'VD' AND analysis NOT IN (SELECT analysis FROM profile_analysis WHERE profile = (SELECT profile FROM request WHERE request.id = measurement.request AND applies = 1) AND method IS NOT NULL) GROUP BY analysis

		-- Insert provided extra services
		;WITH t (request)
		AS (
		SELECT request.id FROM request WHERE request.invoice = 1 AND request.billing_customer IS NULL AND request.customer = (SELECT customer from billing_customer WHERE id = @i) GROUP BY request.id
		)
		INSERT INTO billing_position (billing_customer, amount, price, service, category)
		SELECT 
		(SELECT id from billing_customer WHERE id = @i), 
		Sum(amount),
		(SELECT price FROM service WHERE id = service), 
		service,
		4
		FROM request_service WHERE request IN (SELECT request FROM t) GROUP BY service

		-- Insert sold materials
		;WITH t (request)
		AS (
		SELECT request.id FROM request WHERE request.invoice = 1 AND request.billing_customer IS NULL AND request.customer = (SELECT customer from billing_customer WHERE id = @i) GROUP BY request.id
		)
		INSERT INTO billing_position (billing_customer, amount, price, material, category)
		SELECT 
		(SELECT id from billing_customer WHERE id = @i), 
		Sum(amount),
		(SELECT price FROM material WHERE id = material), 
		material,
		5
		FROM request_material WHERE request IN (SELECT request FROM t) GROUP BY material

		-- Insert project workloads
		;WITH t (project)
		AS (
		SELECT project.id FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_workload ON task.id = task_workload.task LEFT JOIN audit ON audit.table_id = task_workload.id WHERE audit.table_name = 'task_workload' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND task_workload.billing_customer IS NULL AND audit.action_type = 'I' AND project.invoice = 1 GROUP BY project.id
		)
		INSERT INTO billing_position (billing_customer, amount, price, other, category)
		SELECT
		(SELECT id from billing_customer WHERE id = @i),
		workload,
		(SELECT hourly_rate FROM role INNER JOIN users ON users.role = role.id WHERE users.name = task_workload.created_by),
		CONCAT('(P-', project.id, ') ', task_workload.created_at, ', ', task_workload.created_by),
		6
		FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_workload ON task.id = task_workload.task LEFT JOIN audit ON audit.table_id = task_workload.id WHERE audit.table_name = 'task_workload' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND task_workload.billing_customer IS NULL AND project.customer = (SELECT customer from billing_customer WHERE id = @i) AND project.invoice = 1 AND project.id IN (SELECT project FROM t)

		-- Insert project materials
		;WITH t (project)
		AS (
		SELECT project.id FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_material ON task.id = task_material.task LEFT JOIN audit ON audit.table_id = task_material.id WHERE audit.table_name = 'task_material' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND task_material.billing_customer IS NULL AND project.invoice = 1 GROUP BY project.id
		)
		INSERT INTO billing_position (billing_customer, amount, price, other, material, category)
		SELECT
		(SELECT id from billing_customer WHERE id = @i),
		Sum(amount),
		(SELECT material.price FROM material WHERE material.id = task_material.material),
		'(P) ',
		task_material.material,
		7
		FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_material ON task.id = task_material.task INNER JOIN material ON material.id = task_material.material LEFT JOIN audit ON audit.table_id = task_material.id WHERE audit.table_name = 'task_material' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND task_material.billing_customer IS NULL AND project.customer = (SELECT customer from billing_customer WHERE id = @i) AND project.invoice = 1 AND project.id IN (SELECT project FROM t) GROUP BY task_material.material

		-- Insert project services
		;WITH t (project)
		AS (
		SELECT project.id FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_service ON task.id = task_service.task LEFT JOIN audit ON audit.table_id = task_service.id WHERE audit.table_name = 'task_service' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND task_service.billing_customer IS NULL AND project.invoice = 1 GROUP BY project.id
		)
		INSERT INTO billing_position (billing_customer, amount, price, other, service, category)
		SELECT
		(SELECT id from billing_customer WHERE id = @i),
		Sum(amount),
		(SELECT service.price FROM service WHERE service.id = task_service.service),
		'(P) ',
		task_service.service,
		8
		FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_service ON task.id = task_service.task INNER JOIN material ON material.id = task_service.service LEFT JOIN audit ON audit.table_id = task_service.id WHERE audit.table_name = 'task_service' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND task_service.billing_customer IS NULL AND project.customer = (SELECT customer from billing_customer WHERE id = @i) AND project.invoice = 1 AND project.id IN (SELECT project FROM t) GROUP BY task_service.service

		-- Insert sum and vat for invoice
		UPDATE billing_customer SET revenue = (SELECT SUM(price * amount) FROM billing_position WHERE billing_customer = @i) WHERE billing_customer.id = @i

		-- Insert discount for invoice
		UPDATE billing_customer SET discount = (SELECT discount FROM customer WHERE customer.id = (SELECT customer from billing_customer WHERE id = @i)) / 100 * (SELECT SUM(price * amount) FROM billing_position WHERE billing_customer = @i) WHERE billing_customer.id = @i

		-- Insert billing_customer id in table request
		UPDATE request SET billing_customer = @i WHERE request.id IN (SELECT request.id FROM request WHERE request.invoice = 1 AND request.billing_customer IS NULL AND request.customer = (SELECT customer from billing_customer WHERE id = @i) GROUP BY request.id)

		-- Insert billing_customer id in table workload
		UPDATE task_workload SET billing_customer = @i WHERE task_workload.id IN (SELECT task_workload.id FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_workload ON task.id = task_workload.task LEFT JOIN audit ON audit.table_id = task_workload.id WHERE audit.table_name = 'task_workload' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND project.customer = (SELECT customer from billing_customer WHERE id = @i) AND project.invoice = 1) 

		-- Insert billing_customer id in table material
		UPDATE task_material SET billing_customer = @i WHERE task_material.id IN (SELECT task_material.id FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_material ON task.id = task_material.task INNER JOIN material ON material.id = task_material.material LEFT JOIN audit ON audit.table_id = task_material.id WHERE audit.table_name = 'task_material' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND project.customer = (SELECT customer from billing_customer WHERE id = @i) AND project.invoice = 1)

		-- Insert billing_customer id in table service
		UPDATE task_service SET billing_customer = @i WHERE task_service.id IN (SELECT task_service.id FROM project INNER JOIN task ON project.id = task.project INNER JOIN task_service ON task.id = task_service.task INNER JOIN material ON material.id = task_service.service LEFT JOIN audit ON audit.table_id = task_service.id WHERE audit.table_name = 'task_service' AND audit.changed_at >= (SELECT billing_from FROM inserted) AND audit.changed_at <= (SELECT billing_till FROM inserted) AND audit.action_type = 'I' AND project.customer = (SELECT customer from billing_customer WHERE id = @i) AND project.invoice = 1)

		FETCH NEXT FROM c_customer INTO @i
	END
	CLOSE c_customer
	DEALLOCATE c_customer

	UPDATE billing SET revenue = (SELECT SUM(revenue) FROM billing_customer WHERE billing = (SELECT id FROM inserted)) WHERE id = (SELECT id FROM inserted)
	UPDATE billing SET discount = (SELECT SUM(discount) FROM billing_customer WHERE billing = (SELECT id FROM inserted)) WHERE id = (SELECT id FROM inserted)
END
GO
PRINT N'Trigger "[dbo].[billing_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER billing_audit 
   ON  dbo.billing 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[billing_update]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[billing_update]
   ON  dbo.billing 
   INSTEAD OF UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	UPDATE billing SET title = (SELECT title from inserted) WHERE id = (SELECT id FROM inserted)
	UPDATE billing SET description = (SELECT description from inserted) WHERE id = (SELECT id FROM inserted)
END
GO
PRINT N'Trigger "[dbo].[billing_delete]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[billing_delete] 
   ON  [dbo].[billing] 
   INSTEAD OF DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @i AS int

    -- Insert statements for trigger here
	DECLARE c_customer CURSOR FOR SELECT id FROM billing_customer WHERE billing = (SELECT id FROM deleted)

	OPEN c_customer
	FETCH NEXT FROM c_customer INTO @i

	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE request SET billing_customer = NULL WHERE billing_customer = @i
		UPDATE task_workload SET billing_customer = NULL WHERE billing_customer = @i
		UPDATE task_material SET billing_customer = NULL WHERE billing_customer = @i
		UPDATE task_service SET billing_customer = NULL WHERE billing_customer = @i
		FETCH NEXT FROM c_customer INTO @i
	END
	CLOSE c_customer
	DEALLOCATE c_customer

	DELETE billing WHERE id = (SELECT id FROM deleted)
END
GO
PRINT N'Trigger "[dbo].[attribute_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[attribute_insert_update]
   ON dbo.attribute
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT COUNT(id) FROM attribute WHERE value = (SELECT value FROM inserted) AND analysis = (SELECT analysis FROM inserted)) > 1
		THROW 51000, 'Value duplicate found.', 1
END
GO
PRINT N'Trigger "[dbo].[attribute_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[attribute_audit]
   ON  [dbo].[attribute]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[storage_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[storage_audit]
   ON  [dbo].[storage]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[method_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[method_audit]
   ON  dbo.method
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[method_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[method_insert_update]
   ON  dbo.method
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT deactivate FROM inserted) = 1 AND (SELECT COUNT(id) FROM instrument_method WHERE applies = 1 AND method = (SELECT (id) FROM inserted)) > 0
		THROW 51000, 'Deactivation failed. Method is still in use.', 1

	-- Update instrument_method and method_analysis cross table
	IF NOT EXISTS (SELECT id FROM deleted)
	BEGIN
		INSERT INTO instrument_method (instrument, method) SELECT id, (SELECT id FROM inserted) FROM instrument WHERE id NOT IN (SELECT instrument FROM instrument_method WHERE method = (SELECT id FROM inserted)) AND deactivate = 0
		INSERT INTO method_analysis (method, analysis) SELECT (SELECT id FROM inserted), id FROM analysis WHERE id NOT IN (SELECT analysis FROM method_analysis WHERE method = (SELECT id FROM inserted)) AND deactivate = 0
	END
	
	-- Update method_smptype cross table
	IF NOT EXISTS (SELECT id FROM deleted)
	BEGIN
		INSERT INTO method_smptype (method, smptype) SELECT (SELECT id FROM inserted), id FROM smptype WHERE id NOT IN (SELECT smptype FROM method_smptype WHERE method = (SELECT id FROM inserted)) AND deactivate = 0
	END
END
GO
PRINT N'Trigger "[dbo].[state_insert]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[state_insert]
   ON  [dbo].[state]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE cur CURSOR FOR SELECT id FROM state WHERE workflow = (SELECT workflow FROM inserted) ORDER BY id
	DECLARE @i INT
	DECLARE @state CHAR(2)

	SET @state = (SELECT state FROM inserted)
	IF @state <> 'CP' AND @state <> 'RT' AND @state <> 'RC' AND @state <> 'VD' AND @state <> 'MA' AND @state <> 'DP' AND @state <> 'ST' AND @state <> 'DX'
		THROW 51000, 'State unknown.', 1

	OPEN cur
	FETCH NEXT FROM cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO step (step, state) SELECT id, @i FROM state WHERE id NOT IN (SELECT step FROM step WHERE state = @i) AND workflow = (SELECT workflow FROM inserted)
		FETCH NEXT FROM cur INTO @i
	END
	CLOSE cur
	DEALLOCATE cur
END
GO
PRINT N'Trigger "[dbo].[state_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[state_audit]
   ON  [dbo].[state] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[state_update]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[state_update]
   ON  dbo.state
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @state_inserted CHAR(2), @state_preceding CHAR(2)

	SET @state_inserted = (SELECT state FROM inserted) 
	SET @state_preceding = (SELECT state FROM state WHERE id = (SELECT id FROM inserted) -1)

	-- Check if state is a valid one
	IF @state_inserted <> 'CP' AND @state_inserted <> 'RT' AND @state_inserted <> 'RC' AND @state_inserted <> 'VD' AND @state_inserted <> 'MA' AND @state_inserted <> 'DP' AND @state_inserted <> 'ST' AND @state_inserted <> 'DX'
	RAISERROR (15600, -1, -1, 'State unknown.')

	-- Manage allowed state traversals
	-- -------------------------------------------------------
	-- L1 					  CP
	--                       /  \
	-- L2                   RC  RT -> DX
	--                ______|_______________________
	--                |		|		|		|		|
	-- L3             VD	DP		ST		DX		RT -> DX
	--           _____|_________
	--          |		|		|
	-- L4       MA		ST		DX
	--     _____|____
	--     |		|
	-- L5  ST		DX
	-- -------------------------------------------------------
	-- CP - Captured	RT - Retract	RC - Received
	-- VD - Validated	MA - Mailed		DP - Dispatched
	-- ST - Stored		DX - Disposed
	-- -------------------------------------------------------
		
	-- ---------------------------------------------------
	-- L1 -> L2
	-- ---------------------------------------------------

	-- Only allow states from L2
	IF @state_preceding = 'CP' AND @state_inserted <> 'RC' OR @state_inserted <> 'RT'
		RAISERROR (15600, -1, -1, 'State not valid for L1 -> L2.')

	-- ---------------------------------------------------
	-- L2 -> L3
	-- ---------------------------------------------------
		
	-- Retracted samples only can be disposed
	IF @state_preceding = 'RT' and @state_inserted <> 'RT' OR @state_inserted <> 'DX'
		RAISERROR (15600, -1, -1, 'Retracted samples can not be changed.')

	-- Only allow states from L3
	IF @state_preceding = 'RC' AND @state_inserted <> 'VD' OR @state_inserted <> 'DP' OR  @state_inserted <> 'ST' OR @state_inserted <> 'DX' OR @state_inserted <> 'RT'
		RAISERROR (15600, -1, -1, 'State not valid for L2 -> L3.')

	-- Do not allow to validate request if measurements are unvalidated
	IF @state_inserted = 'VD' AND (SELECT COUNT(*) FROM measurement WHERE request = (SELECT request FROM inserted) AND (state = 'AQ' OR state = 'CP')) > 0
		RAISERROR (15600, -1, -1, 'Validation of request failed. Non validated measurements are found.')

	-- ---------------------------------------------------
	-- L3 - > L4
	-- ---------------------------------------------------

	-- Only allow states from L4
	IF @state_preceding = 'VD' AND @state_inserted <> 'MA' OR @state_inserted <> 'ST' OR @state_inserted <> 'DX'
		RAISERROR (15600, -1, -1, 'State not valid for L3 -> L4.')

	-- ---------------------------------------------------
	-- L4 - > L5
	-- ---------------------------------------------------
		
	-- Only allow states from L5
	IF @state_preceding = 'MA' AND @state_inserted <> 'ST' OR @state_inserted <> 'DX'
		RAISERROR (15600, -1, -1, 'State not valid for L4 -> L5.')
END
GO
DISABLE TRIGGER [dbo].[state_update]
    ON [dbo].[state];


GO
PRINT N'Trigger "[dbo].[priority_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[priority_audit] 
   ON  [dbo].[priority]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[profile_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[profile_audit]
   ON  dbo.profile
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[profile_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER profile_insert_update
   ON  dbo.profile
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @id INT
	SET @id = (SELECT id FROM inserted)

	INSERT INTO profile_analysis (profile, analysis) SELECT @id, id FROM analysis WHERE id NOT IN (SELECT analysis FROM profile_analysis WHERE profile = @id) AND deactivate = 0
END
GO
PRINT N'Trigger "[dbo].[request_analysis_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Audit Log
-- =============================================
CREATE TRIGGER request_analysis_audit
   ON  dbo.request_analysis
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[certificate_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[certificate_audit]
   ON  [dbo].[certificate]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[certificate_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[certificate_insert_update] 
   ON  dbo.certificate
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		IF (SELECT valid_from FROM inserted) > (SELECT valid_till FROM inserted) OR (SELECT creation_date FROM inserted) > (SELECT valid_from FROM inserted)
			THROW 51000, 'Wrong certificate dates.', 1
	END
END
GO
PRINT N'Trigger "[dbo].[contact_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[contact_audit]
   ON  dbo.contact
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[formulation_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[formulation_audit]
   ON  dbo.formulation
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[billing_position_update]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER billing_position_update
   ON  dbo.billing_position 
   INSTEAD OF UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

END
GO
PRINT N'Trigger "[dbo].[billing_position_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER billing_position_audit
   ON  dbo.billing_position
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[btcposition_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[btcposition_audit]
   ON  [dbo].[btcposition]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[supplier_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[supplier_audit]
   ON  [dbo].[supplier]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Trigger "[dbo].[role_insert_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[role_insert_update]
   ON  dbo.role 
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (SELECT COUNT(*) FROM role WHERE administrative = 1) > 1
		THROW 51000, 'Only one administrative role allowed.', 1

    -- Insert statements for trigger here
	DECLARE @role INT
	SET @role = (SELECT id FROM inserted)
	INSERT INTO role_permission (role, permission)
	SELECT @role, id FROM permission WHERE id NOT IN (SELECT DISTINCT(role_permission.permission) FROM role_permission WHERE role = @role)
END
GO
PRINT N'Trigger "[dbo].[role_audit]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[role_audit]
   ON  dbo.role
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END
GO
PRINT N'Sicht "[dbo].[view_labreport_details]" wird erstellt...';


GO
CREATE VIEW dbo.view_labreport_details
AS
SELECT   TOP (100) PERCENT dbo.measurement.id AS measurement_id, dbo.measurement.request AS request_id, dbo.technique.id AS technique, dbo.technique.title AS technique_title, 
                         dbo.analysis.title AS analysis, dbo.method.title AS method, t.lsl, dbo.measurement.value_txt, t.usl, dbo.measurement.uncertainty, dbo.analysis.unit, 
                         CASE WHEN dbo.measurement.accredited = 0 THEN '* ' ELSE '' END + CASE WHEN dbo.measurement.subcontraction = 1 THEN 'x ' ELSE '' END + CASE WHEN dbo.measurement.out_of_spec
                          = 1 THEN '+ ' ELSE '' END + CASE WHEN dbo.measurement.out_of_range = 1 THEN '<> ' ELSE '' END + CASE WHEN dbo.measurement.not_detectable = 1 THEN '- ' ELSE '' END AS remark, 
                         dbo.analysis.sortkey AS sortkey_analysis, dbo.technique.sortkey AS sortkey_technique, dbo.measurement.sortkey AS sortkey_measurement
FROM         dbo.measurement INNER JOIN
                         dbo.analysis ON dbo.measurement.analysis = dbo.analysis.id LEFT OUTER JOIN
                         dbo.technique ON dbo.analysis.technique = dbo.technique.id LEFT OUTER JOIN
                         dbo.method ON dbo.measurement.method = dbo.method.id LEFT OUTER JOIN
                             (SELECT   dbo.request.id, dbo.profile_analysis.analysis, dbo.profile_analysis.lsl, dbo.profile_analysis.usl
                                FROM         dbo.request INNER JOIN
                                                         dbo.profile ON dbo.request.profile = dbo.profile.id INNER JOIN
                                                         dbo.profile_analysis ON dbo.profile_analysis.profile = dbo.profile.id
                                WHERE     (dbo.profile_analysis.applies = 1)) AS t ON t.analysis = dbo.measurement.analysis AND dbo.measurement.request = t.id
WHERE     (dbo.measurement.state = 'VD')
ORDER BY dbo.measurement.sortkey, dbo.technique.sortkey, dbo.analysis.sortkey
GO
PRINT N'Sicht "[dbo].[view_worksheet_details]" wird erstellt...';


GO
CREATE VIEW dbo.view_worksheet_details
AS
SELECT        TOP (100) PERCENT dbo.measurement.id AS measurement_id, dbo.measurement.request AS request_id, dbo.technique.id AS technique, dbo.technique.title AS technique_title, dbo.analysis.title AS analysis, 
                         dbo.method.title AS method, t.lsl, dbo.measurement.value_txt, t.usl, dbo.measurement.uncertainty, dbo.analysis.unit, 
                         CASE WHEN dbo.measurement.accredited = 0 THEN '* ' ELSE '' END + CASE WHEN dbo.measurement.subcontraction = 1 THEN 'x ' ELSE '' END + CASE WHEN dbo.measurement.out_of_spec = 1 THEN '+ ' ELSE '' END + CASE WHEN
                          dbo.measurement.out_of_range = 1 THEN '<> ' ELSE '' END + CASE WHEN dbo.measurement.not_detectable = 1 THEN '- ' ELSE '' END AS remark, dbo.analysis.sortkey AS sortkey_analysis, 
                         dbo.technique.sortkey AS sortkey_technique, dbo.measurement.sortkey AS sortkey_measurement
FROM            dbo.measurement INNER JOIN
                         dbo.analysis ON dbo.measurement.analysis = dbo.analysis.id LEFT OUTER JOIN
                         dbo.technique ON dbo.analysis.technique = dbo.technique.id LEFT OUTER JOIN
                         dbo.method ON dbo.measurement.method = dbo.method.id LEFT OUTER JOIN
                             (SELECT        dbo.request.id, dbo.profile_analysis.analysis, dbo.profile_analysis.lsl, dbo.profile_analysis.usl
                               FROM            dbo.request INNER JOIN
                                                         dbo.profile ON dbo.request.profile = dbo.profile.id INNER JOIN
                                                         dbo.profile_analysis ON dbo.profile_analysis.profile = dbo.profile.id
                               WHERE        (dbo.profile_analysis.applies = 1)) AS t ON t.analysis = dbo.measurement.analysis AND dbo.measurement.request = t.id
WHERE        (dbo.measurement.state = 'CP')
ORDER BY sortkey_measurement, sortkey_technique, sortkey_analysis
GO
PRINT N'Sicht "[dbo].[view_request_owner]" wird erstellt...';


GO
CREATE VIEW dbo.view_request_owner
AS
SELECT        dbo.request.id, dbo.request.description, dbo.request.photo, dbo.request.customer, dbo.request.cc_email, dbo.request.smp_date, dbo.request.smptype, dbo.request.smpmatrix, dbo.request.smpcontainer, 
                         dbo.request.smpcondition, dbo.request.smppreservation, dbo.request.smppoint, dbo.request.sampler, dbo.request.smp_composit, dbo.request.client_sample_id, dbo.request.client_order_id, dbo.request.priority, 
                         dbo.request.internal_use, dbo.request.profile, dbo.request.project, dbo.request.formulation, dbo.request.workflow, dbo.request.state, dbo.request.subrequest, dbo.audit.changed_by, dbo.request.recipients, dbo.request.subject, 
                         dbo.request.body
FROM            dbo.request INNER JOIN
                         dbo.audit ON dbo.request.id = dbo.audit.table_id
WHERE        (dbo.audit.table_name = 'request') AND (dbo.audit.action_type = 'I') AND (dbo.audit.changed_by = SUSER_SNAME())
GO
PRINT N'Sicht "[dbo].[view_billing_position]" wird erstellt...';


GO
CREATE VIEW dbo.view_billing_position
AS
SELECT        dbo.billing_position.id, dbo.billing_position.category, CONVERT(int, ISNULL(CONVERT(varchar(255), dbo.method.id), '') + ISNULL(CONVERT(varchar(255), dbo.service.id), '') + ISNULL(CONVERT(varchar(255), dbo.analysis.id), '') 
                         + ISNULL(CONVERT(varchar(255), dbo.material.id), '') + ISNULL(CONVERT(varchar(255), dbo.profile.id), '')) AS article_no, ISNULL(dbo.billing_position.other, '') + ISNULL(dbo.method.title, '') + ISNULL(dbo.analysis.title, '') 
                         + ISNULL(dbo.material.title, '') + ISNULL(dbo.service.title, '') + ISNULL(dbo.profile.title, '') AS description, dbo.billing_position.amount, dbo.billing_position.price, 
                         dbo.billing_position.amount * dbo.billing_position.price AS extended_price, dbo.billing_position.billing_customer
FROM            dbo.billing_position LEFT OUTER JOIN
                         dbo.profile ON dbo.billing_position.profile = dbo.profile.id LEFT OUTER JOIN
                         dbo.material ON dbo.billing_position.material = dbo.material.id LEFT OUTER JOIN
                         dbo.analysis ON dbo.billing_position.analysis = dbo.analysis.id LEFT OUTER JOIN
                         dbo.service ON dbo.billing_position.service = dbo.service.id LEFT OUTER JOIN
                         dbo.method ON dbo.billing_position.method = dbo.method.id
GO
PRINT N'Sicht "[dbo].[view_attachment_revision]" wird erstellt...';


GO
CREATE VIEW dbo.view_attachment_revision
AS
SELECT        dbo.attachment.id, dbo.users.name AS responsible, dbo.attachment.reminder, dbo.attachment.title, dbo.attachment.file_name
FROM            dbo.attachment INNER JOIN
                         dbo.users ON dbo.attachment.responsible = dbo.users.id
WHERE        (GETDATE() >= DATEADD(day, -
                             (SELECT        TOP (1) alert_document
                               FROM            dbo.setup), dbo.attachment.reminder))
GO
PRINT N'Funktion "[dbo].[users_get_hourly_rate]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: November 2023
-- Description:	Get hourly rate of users
-- =============================================
CREATE FUNCTION users_get_hourly_rate
(
	-- Add the parameters for the function here
	@user_name VARCHAR(255)
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @rate money

	-- Add the T-SQL statements to compute the return value here
	SET @rate = (SELECT role.hourly_rate FROM role INNER JOIN users ON users.role = role.id WHERE name = @user_name)

	-- Return the result of the function
	RETURN @rate

END
GO
PRINT N'Funktion "[dbo].[audit_get_first]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION audit_get_first 
(
	-- Add the parameters for the function here
	@table_name VARCHAR(255),
	@table_id INT
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @changed_at DATETIME

	-- Add the T-SQL statements to compute the return value here
	SET @changed_at = (SELECT TOP 1 changed_at FROM audit WHERE table_name = @table_name AND table_id = @table_id)

	-- Return the result of the function
	RETURN @changed_at

END
GO
PRINT N'Funktion "[dbo].[audit_get_value]" wird erstellt...';


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[audit_get_value]
(
	-- Add the parameters for the function here
	@table_name VARCHAR(255),
	@table_id INT,
	@clmn_name VARCHAR(255),
	@changed_at DATETIME
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @elem_text NVARCHAR(MAX)

	-- Add the T-SQL statements to compute the return value here
	DECLARE @x XML
	SET @x = (SELECT TOP 1 value_new FROM audit WHERE table_name = @table_name AND table_id = @table_id AND changed_at <= @changed_at ORDER BY id DESC)

	SET @elem_text =
	(
	SELECT TOP 1 elem_text FROM (SELECT
		N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
		N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
	FROM
		@x.nodes('row/*') AS N(x)) As a WHERE elem_name = @clmn_name
	)

	-- Return the result of the function
	RETURN @elem_text

END
GO
PRINT N'Funktion "[dbo].[users_get_suser]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 May
-- Description:	Get SUSER_NAME from id
-- =============================================
CREATE FUNCTION users_get_suser
(
	-- Add the parameters for the function here
	@id int
)
RETURNS nvarchar(255)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suser_name nvarchar(255)

	-- Add the T-SQL statements to compute the return value here
	SET @suser_name = (SELECT name FROM users WHERE id = @id)

	-- Return the result of the function
	RETURN @suser_name

END
GO
PRINT N'Funktion "[dbo].[users_get_id]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 May
-- Description:	Get ID of SUSER_NAME
-- =============================================
CREATE FUNCTION [dbo].[users_get_id]
(
	-- Add the parameters for the function here
	@suser_name nvarchar(255)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @id INT

	-- Add the T-SQL statements to compute the return value here
	SET @id = (SELECT id FROM users WHERE name = @suser_name)

	-- Return the result of the function
	RETURN @id

END
GO
PRINT N'Sicht "[dbo].[view_project_owner]" wird erstellt...';


GO
CREATE VIEW dbo.view_project_owner
AS
SELECT        dbo.project.id, dbo.project.title, dbo.project.description, dbo.project.profile, dbo.project.owner, dbo.project.started, dbo.project.deactivate
FROM            dbo.project LEFT OUTER JOIN
                             (SELECT        TOP (1) id, users, project
                               FROM            dbo.project_member
                               WHERE        (users = dbo.users_get_id(SUSER_NAME()))) AS a ON dbo.project.id = a.project
WHERE        (dbo.project.owner = SUSER_NAME()) OR
                         (a.project = dbo.project.id)
GO
PRINT N'Sicht "[dbo].[view_measurement]" wird erstellt...';


GO
CREATE VIEW dbo.view_measurement
AS
SELECT dbo.measurement.id, dbo.measurement.request, dbo.customer.name AS customer, dbo.analysis.title AS analysis, dbo.method.title AS method, dbo.instrument.title AS instrument, dbo.measurement.value_txt AS value, dbo.audit_get_value('analysis', dbo.analysis.id, 'unit', dbo.measurement.acquired_at) AS unit, dbo.measurement.out_of_spec, dbo.measurement.state, 
         dbo.request.profile, dbo.measurement.subcontraction
FROM  dbo.state INNER JOIN
         dbo.request ON dbo.state.id = dbo.request.state INNER JOIN
         dbo.customer ON dbo.request.customer = dbo.customer.id INNER JOIN
         dbo.measurement ON dbo.request.id = dbo.measurement.request LEFT OUTER JOIN
         dbo.analysis ON dbo.measurement.analysis = dbo.analysis.id LEFT OUTER JOIN
         dbo.instrument ON dbo.measurement.instrument = dbo.instrument.id LEFT OUTER JOIN
         dbo.method ON dbo.measurement.method = dbo.method.id
WHERE (dbo.measurement.state = 'CP') AND (dbo.state.state = 'RC') OR
         (dbo.measurement.state = 'AQ')
GO
PRINT N'Sicht "[dbo].[view_request_measurement]" wird erstellt...';


GO
CREATE VIEW dbo.view_request_measurement
AS
SELECT dbo.measurement.id, dbo.measurement.request AS request_id, dbo.measurement.sortkey, dbo.analysis.title AS analysis, dbo.method.title AS method, dbo.instrument.title AS instrument, CONVERT(float, dbo.audit_get_value('analysis', dbo.analysis.id, 'ldl', dbo.measurement.acquired_at)) AS ldl, t.tsl, t.lsl, dbo.measurement.value_txt, t.usl, CONVERT(float, dbo.audit_get_value('analysis', 
         dbo.analysis.id, 'udl', dbo.measurement.acquired_at)) AS udl, dbo.measurement.uncertainty, dbo.measurement.unit, dbo.technique.title AS technique, dbo.measurement.out_of_spec, dbo.measurement.state, dbo.measurement.hide, dbo.measurement.accredited, dbo.measurement.subcontraction
FROM  dbo.measurement INNER JOIN
         dbo.analysis ON dbo.measurement.analysis = dbo.analysis.id LEFT OUTER JOIN
         dbo.instrument ON dbo.measurement.instrument = dbo.instrument.id LEFT OUTER JOIN
         dbo.technique ON dbo.analysis.technique = dbo.technique.id LEFT OUTER JOIN
         dbo.method ON dbo.measurement.method = dbo.method.id LEFT OUTER JOIN
             (SELECT dbo.request.id, dbo.profile_analysis.analysis, dbo.profile_analysis.tsl, CONVERT(float, dbo.audit_get_value('profile_analysis', dbo.profile_analysis.id, 'lsl', dbo.audit_get_first('request', dbo.request.id))) AS lsl, CONVERT(float, dbo.audit_get_value('profile_analysis', dbo.profile_analysis.id, 'usl', dbo.audit_get_first('request', dbo.request.id))) AS usl
            FROM  dbo.request INNER JOIN
                     dbo.profile ON dbo.request.profile = dbo.profile.id INNER JOIN
                     dbo.profile_analysis ON dbo.profile_analysis.profile = dbo.profile.id
            WHERE (dbo.profile_analysis.applies = 1)) AS t ON t.analysis = dbo.measurement.analysis AND dbo.measurement.request = t.id
GO
PRINT N'Sicht "[dbo].[view_task]" wird erstellt...';


GO
CREATE VIEW dbo.view_task
AS
SELECT        dbo.task.id, dbo.task.title, dbo.project.id AS project_id, dbo.project.title AS project_title, dbo.task.description, dbo.task.created_by, dbo.task.created_at, dbo.task.planned_start, dbo.task.planned_end, dbo.task.workload_planned, 
                         dbo.task.fulfillment
FROM            dbo.task INNER JOIN
                         dbo.project ON dbo.task.project = dbo.project.id
WHERE        (dbo.task.responsible = dbo.users_get_id(SUSER_NAME())) AND (dbo.task.deactivate = 0) AND (dbo.project.started = 1)
GO
PRINT N'Funktion "[dbo].[xml_diff]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 April
-- Description:	Diff between two xmls
-- =============================================
CREATE FUNCTION [dbo].[xml_diff] 
(	
	-- Add the parameters for the function here
	@pk nvarchar(max),
	@x XML, 
	@y XML
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	WITH A AS (
	SELECT
		N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
		N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
	FROM
		@x.nodes('row/*') AS N(x)
	),
	B AS (
	SELECT
		N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
		N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
	FROM
		@y.nodes('row/*') AS N(x)
	)
	SELECT
		@pk AS pk,
		COALESCE(A.elem_name, B.elem_name) AS elem_name,
		--A.elem_text AS value_old,
		--B.elem_text AS value_new
		-- Use cast to reduce max length
		CAST(A.elem_text AS nvarchar(256)) AS value_old,
		CAST(B.elem_text AS nvarchar(256)) AS value_new
	FROM
		A
		FULL OUTER JOIN
		B
		ON A.elem_name = B.elem_name
	WHERE
		A.elem_text <> B.elem_text
)
GO
PRINT N'Prozedur "[dbo].[gesd_test]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	GESD test
-- =============================================
CREATE PROCEDURE [dbo].[gesd_test]
	-- Add the parameters for the stored procedure here
	@inquery nvarchar(max),
	@alpha float,
	@max_outliers int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @s nvarchar(max)

	SET @s =

N'
from scipy import stats
import pandas as pd
import numpy as np

def esd_test(df, max_outliers, alpha):
	""" Perform GESD test
	Parameters
	----------
	df : DataFrame
		DataFrame to calculate GESD from
	max_outliers : int
		Maximum outliers for GESD calculation
	alpha : float
		Alpha error of t-distribution
	"""
	ind = list(InputDataSet["id"])
	x = list(df.values)
	outliers = []
	res_lst = [] # ESD Test Statistic for each k anomaly
	lam_lst = [] # Critical Value for each k anomaly
	n = len(x)
		
	if max_outliers is None:
		max_outliers = len(x)
		
	for i in range(1,max_outliers+1):
		x_mean = np.mean(x)
		x_std = np.std(x,ddof=1)
		res = abs((x - x_mean) / x_std)
		max_res = np.max(res)
		max_ind = np.argmax(res)
		p = 1 - alpha / (2*(n-i+1))
		t_v = stats.t.ppf(p,(n-i-1)) # Get critical values from t-distribution based on p and n
		lam_i = ((n-i)*t_v)/ np.sqrt((n-i-1+t_v**2)*(n-i+1)) # Calculate critical region (lambdas)
		res_lst.append(max_res)
		lam_lst.append(lam_i)
		if max_res > lam_i:
			outliers.append((ind.pop(max_ind),x.pop(max_ind)))
				
	# Record outlier Points
	outliers_index = [x[0] for x in outliers]
	return outliers_index

OutputDataSet = pd.DataFrame(esd_test(InputDataSet["value"], ' + CAST(@max_outliers As nvarchar) + ', ' + CAST(@alpha As nvarchar) + '));
'

	EXECUTE sp_execute_external_script @language = N'Python', @script = @s, @input_data_1 = @inquery
END
GO
PRINT N'Prozedur "[dbo].[lims_initialize]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Initialize specific settings
-- =============================================
CREATE PROCEDURE [dbo].[lims_initialize]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	EXEC sp_configure 'external scripts enabled', 1;
	EXEC sp_configure 'xp_cmdshell', 1;
	EXEC sp_configure 'Ole Automation Procedures', 1;
	RECONFIGURE WITH OVERRIDE;
END
GO
PRINT N'Prozedur "[dbo].[measurement_insert]" wird erstellt...';


GO
-- =======================================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Insert a measurement with conditions and calculated fields
-- =======================================================================
CREATE PROCEDURE [dbo].[measurement_insert]
	-- Add the parameters for the stored procedure here
	@request INT,
	@analysis INT,
	@method INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- DECLARE @method INT, @instrument INT
	DECLARE @unit VARCHAR(255)
	DECLARE @id_keys table([id] INT)
	DECLARE @id INT

	 IF @method IS NULL
	 	SET @method = (SELECT TOP 1 method FROM method_analysis WHERE analysis = @analysis AND standard = 1 AND applies = 1)

	-- SET @method = (SELECT method FROM method_analysis WHERE analysis = @analysis AND standard = 1 AND applies = 1 AND method IN (SELECT method FROM qualification WHERE valid_from <= GETDATE() AND valid_till >= GETDATE() AND withdraw = 0))
	-- SET @instrument = (SELECT instrument FROM instrument_method WHERE method = @method AND standard = 1 AND applies = 1 AND instrument IN (SELECT instrument FROM certificate WHERE valid_from <= GETDATE() AND valid_till >= GETDATE() AND withdraw = 0))

	-- INSERT INTO measurement (request, analysis, method, instrument, state) OUTPUT inserted.id INTO @id_keys SELECT @request, @analysis, @method, @instrument, 'CP' WHERE @analysis NOT IN (SELECT @analysis FROM measurement WHERE request = @request AND analysis = @analysis AND (state = 'CP' OR state = 'AQ' OR state = 'VD')) 

	INSERT INTO measurement (request, analysis, method, state) OUTPUT inserted.id INTO @id_keys SELECT @request, @analysis, @method, 'CP' WHERE @analysis NOT IN (SELECT @analysis FROM measurement WHERE request = @request AND analysis = @analysis AND (state = 'CP' OR state = 'AQ' OR state = 'VD')) 
	
	SET @id = (SELECT TOP 1 id FROM @id_keys)

	-- Set unit
	UPDATE measurement SET unit = (SELECT unit FROM analysis WHERE id = (SELECT analysis FROM measurement WHERE id = @id)) WHERE id = @id

	-- Set subcontraction
	IF @method IS NOT NULL UPDATE measurement SET subcontraction = (SELECT subcontraction FROM method WHERE id = @method) WHERE id = @id

	IF (SELECT condition_activate FROM analysis WHERE id = @analysis) = 1
	BEGIN
		-- Insert analysis specific conditions
		INSERT INTO measurement_condition (condition, measurement) SELECT id, @id FROM condition WHERE analysis = (SELECT analysis FROM measurement WHERE id = @id)
	END

	IF (SELECT calculation_activate FROM analysis WHERE id = @analysis) = 1
	BEGIN
		-- Insert analysis specific cfield
		INSERT INTO measurement_cfield (cfield, measurement) SELECT id, @id FROM cfield WHERE analysis = (SELECT analysis FROM measurement WHERE id = @id) AND analysis_id IS NULL
	END
END
GO
PRINT N'Prozedur "[dbo].[users_get_name]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE PROCEDURE [dbo].[users_get_name]
	-- Add the parameters for the stored procedure here
	@response_message NVARCHAR(256) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	BEGIN TRY
		SET @response_message = SUSER_NAME()
	END TRY

	BEGIN CATCH
		SET @response_message = NULL
	END CATCH
END
GO
PRINT N'Prozedur "[dbo].[audit_xml_diff]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Create audit trail from record
-- =============================================
CREATE PROCEDURE [dbo].[audit_xml_diff]
	-- Add the parameters for the stored procedure here
	@table_name nvarchar(128),
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @x XML, @y XML
	DECLARE @l xml_diff_list
	DECLARE audit_xml_diff CURSOR FOR SELECT id FROM audit WHERE table_name = @table_name AND table_id = @id

	OPEN audit_xml_diff
	FETCH NEXT FROM audit_xml_diff INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @x = (SELECT value_old FROM audit WHERE id = @i)
		SET @y = (SELECT value_new FROM audit WHERE id = @i)

		IF @x IS NOT NULL AND @y IS NOT NULL
			INSERT INTO @l SELECT * FROM xml_diff(@i, @x, @y)

		IF @x IS NULL
		BEGIN
			WITH A AS (
			SELECT
				N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
				N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
			FROM
				@y.nodes('row/*') AS N(x)
			) INSERT INTO @l SELECT @i, elem_name, NULL, elem_text FROM A
		END

		IF @y IS NULL
			BEGIN
			WITH A AS (
			SELECT
				N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
				N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
			FROM
				@x.nodes('row/*') AS N(x)
			) INSERT INTO @l SELECT @i, elem_name, NULL, elem_text FROM A
		END

		FETCH NEXT FROM audit_xml_diff INTO @i
	END
	CLOSE audit_xml_diff
	DEALLOCATE audit_xml_diff

	SELECT l.elem_name, l.value_old, l.value_new, a.changed_by, a.changed_at FROM @l AS l INNER JOIN audit AS a ON l.pk = a.id ORDER BY a.id ASC
END
GO
PRINT N'Prozedur "[dbo].[row_duplicate]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	Dublicate row
-- =============================================
CREATE PROCEDURE [dbo].[row_duplicate]
	-- Add the parameters for the stored procedure here
	@p_tablename NVARCHAR(256),
	@p_ignore ColumnList READONLY,
	@p_id INT,
	@p_identity INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure herew
	DECLARE @i NVARCHAR(256)
	DECLARE @t TABLE(id INT)
	DECLARE @clmn NVARCHAR(MAX)
	DECLARE @vlus NVARCHAR(MAX)
	DECLARE @sql NVARCHAR(MAX)
	DECLARE copy_cur CURSOR FOR SELECT c.name from sys.columns c inner join sys.tables t on c.object_id = t.object_id where t.name = @p_tablename
	
	OPEN copy_cur
	FETCH NEXT FROM copy_cur INTO @i
	WHILE @@FETCH_STATUS = 0

	BEGIN
		IF @i <> (SELECT DISTINCT Column_Name As [Column] FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE Table_Name = 'manufacturer') AND @i NOT IN (SELECT clmn FROM @p_ignore)
		BEGIN
			IF @vlus IS NOT NULL
				SET @vlus = @vlus + ',' + '(' + 'SELECT ' + @i + ' FROM ' + @p_tablename + ' WHERE id = ' + CONVERT(varchar, @p_id) + ')'
			ELSE
				SET @vlus = '(' + 'SELECT ' + @i + ' FROM ' + @p_tablename + ' WHERE id = ' + CONVERT(varchar, @p_id) + ')'

			IF @clmn IS NOT NULL
				SET @clmn = @clmn + ',' + @i
			ELSE
				SET @clmn = @i
		END
		
		FETCH NEXT FROM copy_cur INTO @i
	END

	SELECT @sql = 'INSERT INTO ' + @p_tablename + '(' + @clmn + ') VALUES (' + @vlus + '); SELECT SCOPE_IDENTITY();'

	INSERT INTO @t (id) EXEC (@sql)

	SET @p_identity = (SELECT TOP 1 * from @t)

	CLOSE copy_cur
	DEALLOCATE copy_cur
END
GO
PRINT N'Prozedur "[dbo].[spa_create]" wird erstellt...';


GO
-- ================================================
-- Author:		Kogel, Lutz
-- Create date: 2022-03-10
-- Description:	Peform Statistical Process Analysis
-- ================================================
CREATE PROCEDURE [dbo].[spa_create] 
	-- Add the parameters for the stored procedure here
	@uid NVARCHAR(256),
	@profile INT,
	@analysis INT,
	@from DATETIME,
	@till DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @usl FLOAT
	DECLARE @lsl FLOAT

	-- Set limits
	SET @usl = (SELECT usl FROM profile_analysis WHERE profile = @profile AND analysis = @analysis)
	SET @lsl = (SELECT lsl FROM profile_analysis WHERE profile = @profile AND analysis = @analysis)

	-- Delete old values
	DELETE FROM spa WHERE uid = @uid

	-- Insert measurement values
	INSERT INTO spa (uid, value, validated_at) SELECT @uid, measurement.value_num, measurement.validated_at FROM measurement INNER JOIN request ON (measurement.request = request.id) WHERE request.profile = @profile AND measurement.analysis = @analysis AND measurement.validated_at >= @from AND measurement.validated_at <= @till

	-- Set outlier values
	DECLARE @sql NVARCHAR(max)
	DECLARE @o INT
	DECLARE @i INT
	DECLARE @t table (id int)
	SET @o = (SELECT COUNT(*) FROM spa WHERE uid = @uid) * 0.5
	SET @sql = 'SELECT id, value FROM spa WHERE uid = ''' + @uid + ''''
	INSERT INTO @t EXEC gesd_test @sql, 0.05, @o
	DECLARE gesd_cursor CURSOR FOR SELECT id FROM @t
	OPEN gesd_cursor
	FETCH NEXT FROM gesd_cursor INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE spa SET outlier = (SELECT value FROM spa WHERE id = @i) WHERE id = @i
		FETCH NEXT FROM gesd_cursor INTO @i
	END
	CLOSE gesd_cursor
	DEALLOCATE gesd_cursor

	-- Unpdate measurement values minus outliers
	UPDATE spa SET value_minus_outlier = value FROM spa WHERE outlier IS NULL

	-- Set average
	UPDATE spa SET average = (SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) WHERE uid = @uid

	-- Set standard deviation
	UPDATE spa SET stdev = (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid) WHERE uid = @uid

	-- Set action limit
	UPDATE spa SET ual = ((SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) +  3 * (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid)) WHERE uid = @uid
	UPDATE spa SET lal = ((SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) -  3 * (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid)) WHERE uid = @uid

	-- Set warning limit
	UPDATE spa SET uwl = ((SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) +  2 * (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid)) WHERE uid = @uid
	UPDATE spa SET lwl = ((SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) -  2 * (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid)) WHERE uid = @uid

	-- Set time series
	UPDATE spa SET time = id - (SELECT MIN(id) FROM spa WHERE uid = @uid) + 1 WHERE uid = @uid

	-- Set usl and lsl
	UPDATE spa SET usl = @usl WHERE uid = @uid
	UPDATE spa SET lsl = @lsl WHERE uid = @uid
END
GO
PRINT N'Prozedur "[dbo].[measurement_pool]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022-07-27
-- Description:	Pool all measurements in batch
-- =============================================
CREATE PROCEDURE [dbo].[measurement_pool] 
	-- Add the parameters for the stored procedure here
	@p_id INT -- ID of the measurment to pool in batch
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @batch INT
	DECLARE @analysis INT
	DECLARE @i INT
	DECLARE @method INT, @instrument INT, @value_num INT, @value_txt INT, @state CHAR(2)

	SET @batch = (SELECT batch FROM btcposition WHERE request = (SELECT request FROM measurement WHERE id = @p_id))
	SET @analysis = (SELECT analysis FROM measurement WHERE id = @p_id)
	SET @method = (SELECT method FROM measurement WHERE id = @p_id)
	SET @instrument = (SELECT instrument FROM measurement WHERE id = @p_id)
	SET @value_num = (SELECT value_num FROM measurement WHERE id = @p_id)
	SET @value_txt = (SELECT value_txt FROM measurement WHERE id = @p_id)
	SET @state = (SELECT state FROM measurement WHERE id = @p_id)

	DECLARE msmt_cur CURSOR FOR SELECT measurement.id FROM measurement INNER JOIN request ON (measurement.request = request.id) INNER JOIN btcposition ON (request.id = btcposition.request) WHERE btcposition.batch = @batch AND measurement.analysis = @analysis ORDER BY measurement.id

	OPEN msmt_cur
	FETCH NEXT FROM msmt_cur INTO @i
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Update the measurements in the pool based on values of @p_id
			UPDATE measurement SET value_txt = @value_txt, value_num = @value_num, method = @method, instrument = @instrument, state = @state WHERE id = @i AND state = 'CP'
			FETCH NEXT FROM msmt_cur INTO @i
		END
	CLOSE msmt_cur
	DEALLOCATE msmt_cur
END
GO
PRINT N'Prozedur "[dbo].[version_be]" wird erstellt...';


GO
-- ==================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 June
-- Description:	Used to identify the backend version
-- ==================================================
CREATE PROCEDURE [dbo].[version_be]
	-- Add the parameters for the stored procedure here
	@version_be nvarchar(256) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @version_be = 'v2.0.0'
END
GO
PRINT N'Prozedur "[dbo].[users_get_Customer]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 April
-- Description:	Get customer id from user
-- =============================================
CREATE PROCEDURE users_get_Customer 
	-- Add the parameters for the stored procedure here
	@response_message INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @response_message = (SELECT customer.id FROM customer INNER JOIN contact ON (customer.id = contact.customer) WHERE contact.id = (SELECT contact FROM users WHERE name = SUSER_NAME()))
END
GO
PRINT N'Prozedur "[dbo].[datetime_get]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2023 October
-- Description:	Get SystemDateTime
-- =============================================
CREATE PROCEDURE [dbo].[datetime_get]
	-- Add the parameters for the stored procedure here
	@response_message date OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @response_message = (SELECT SYSDATETIME())
END
GO
PRINT N'Prozedur "[dbo].[role_duplicate]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Duplicate role
-- =============================================
CREATE PROCEDURE [dbo].[role_duplicate]
	-- Add the parameters for the stored procedure here
	@pRole As INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE role_cur CURSOR FOR SELECT id FROM role_permission WHERE role = @pRole
	DECLARE @id_keys table([id] INT)
	DECLARE @id INT
	DECLARE @i INT
	DECLARE @permission INT

	INSERT INTO role (title, description) OUTPUT inserted.id INTO @id_keys VALUES((SELECT title FROM role WHERE id = @pRole) + '_duplicate', (SELECT description FROM role WHERE id = @pRole))

	SET @id = (SELECT TOP 1 id FROM @id_keys)

	OPEN role_cur
	FETCH NEXT FROM role_cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @permission = (SELECT permission FROM role_permission WHERE id = @i)
		UPDATE role_permission
		SET
		can_create = (SELECT can_create FROM role_permission WHERE role = @pRole and permission = @permission),
		can_read = (SELECT can_read FROM role_permission WHERE role = @pRole and permission = @permission),
		can_update = (SELECT can_update FROM role_permission WHERE role = @pRole and permission = @permission),
		can_delete = (SELECT can_delete FROM role_permission WHERE role = @pRole and permission = @permission) WHERE role = @id AND permission = @permission
		FETCH NEXT FROM role_cur INTO @i
	END
	CLOSE role_cur
	DEALLOCATE role_cur
END
GO
PRINT N'Prozedur "[dbo].[folder_create]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[folder_create]
	-- Add the parameters for the stored procedure here
	@strFolder NVARCHAR(200) -- Folder to be created
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ResultSet TABLE(Directory NVARCHAR(200))
	DECLARE @s NVARCHAR(200)
	DECLARE @tmpFolder NVARCHAR(MAX)

	-- Create table with subfolder names
	INSERT INTO @ResultSet EXEC master.dbo.xp_subdirs 'c:\'

	-- Check if folder already exists
	IF (SELECT COUNT(*) FROM @ResultSet where Directory = @strFolder) = 0
	BEGIN
		-- Create folder
		SET @s = 'MD ' + 'c:\' + @strFolder
		exec master.dbo.xp_cmdshell @s
	END
END
GO
PRINT N'Prozedur "[dbo].[calculation_substitute_keyword]" wird erstellt...';


GO
-- ===============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Substitute keywords in calculation
-- ===============================================
CREATE PROCEDURE [dbo].[calculation_substitute_keyword] 
	-- Add the parameters for the stored procedure here
	@keywords StringList READONLY,
	@values KeyValueList READONLY,
	@equation NVARCHAR(MAX),
	@return_message NVARCHAR(MAX) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @key NVARCHAR(MAX)
	DECLARE @value NVARCHAR(MAX)

	SET @i = 0
	WHILE @i < (SELECT COUNT(*) FROM @keywords)
	BEGIN
		SET @key = (SELECT value FROM @keywords WHERE id = @i)
		SET @value = (SELECT value FROM @values WHERE keyword = @key)
		IF CHARINDEX('.', @value) = 0
			SET @value = @value + '.0'
		SET @equation = REPLACE(@equation, @key, @value )
		SET @i = @i + 1
	END

	SET @return_message = @equation
END
GO
PRINT N'Prozedur "[dbo].[calculation_extract_keyword]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[calculation_extract_keyword]
	-- Add the parameters for the stored procedure here
	@equation NVARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @key_open BigIntList, @key_close BigIntList, @keys StringList, @pos INT, @i INT

	-- Store the position of opening brackets
	SET @i = 0
	SET @pos = 1
	WHILE CHARINDEX('[', @equation, @pos) > 0
	BEGIN
		INSERT INTO @key_open VALUES(@i, CHARINDEX('[', @equation, @pos))
		SET @pos = (SELECT value FROM @key_open WHERE id = @i) + 1
		SET @i = @i + 1
	END

	-- Store the position of closing brackets
	SET @i = 0
	SET @pos = 1
	WHILE CHARINDEX(']', @equation, @pos) > 0
	BEGIN
		INSERT INTO @key_close VALUES(@i, CHARINDEX(']', @equation, @pos))
		SET @pos = (SELECT value FROM @key_close WHERE id = @i) + 1
		SET @i = @i + 1
	END

	-- Store the fields named in brackets
	SET @i = 0
	WHILE @i < (SELECT COUNT(*) FROM @key_Open)
	BEGIN
		INSERT INTO @keys VALUES(@i, SUBSTRING(@equation, (SELECT value FROM @key_open WHERE id = @i), (SELECT value FROM @key_close WHERE id = @i) - (SELECT value FROM @key_open WHERE id = @i) + 1))
		SET @i = @i + 1
	END

	-- Delete field duplicates
	DELETE T FROM (SELECT *, DupRank = ROW_NUMBER() OVER (PARTITION BY value ORDER BY (SELECT NULL)) FROM @keys) AS T WHERE DupRank > 1 

	SELECT * FROM @keys
END
GO
PRINT N'Prozedur "[dbo].[calculation_perform]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[calculation_perform]
	@measurement INT,
	@response_message FLOAT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @f KeyValueList
	DECLARE @t StringList
	DECLARE @equation NVARCHAR(MAX)
	DECLARE @i INT
	DECLARE @id INT
	DECLARE @s NVARCHAR(MAX)
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @result FLOAT
	DECLARE @analysis INT

	SET @analysis = (SELECT analysis FROM measurement WHERE id = @measurement)

	DECLARE cur CURSOR FOR SELECT id FROM cvalidate WHERE analysis = @analysis ORDER BY id

	SET @equation = (SELECT calculation FROM analysis WHERE id = @analysis)
	
	-- Get key and value
	OPEN cur
	FETCH NEXT FROM cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (SELECT analysis_id FROM cvalidate WHERE id = @i) IS NULL
		BEGIN
			SET @id = (SELECT cfield_id FROM cvalidate WHERE id = @i)
			INSERT INTO @f
				VALUES ('[F'+CAST(@id As NVARCHAR(MAX))+']', (SELECT value_num FROM measurement_cfield WHERE measurement = @measurement AND cfield = @id))
		END

		IF (SELECT cfield_id FROM cvalidate WHERE id = @i) IS NULL
		BEGIN
			SET @id = (SELECT analysis_id FROM cvalidate WHERE id = @i)
			INSERT INTO @f
				VALUES ('[A'+CAST(@id As NVARCHAR(MAX))+']', (SELECT value_num FROM measurement WHERE request = (SELECT request FROM measurement WHERE id = @measurement) AND analysis = @id AND state = 'VD'))
		END

		FETCH NEXT FROM cur INTO @i
	END
	CLOSE cur
	DEALLOCATE cur

	-- SELECT * FROM @f

	-- Extract keywors of equation
	INSERT INTO @t
	EXEC calculation_extract_keyword @equation

	-- Substitute keywords by value
	EXEC calculation_substitute_keyword @t, @f, @equation, @s OUT

	-- Evaluate euqation
	SET @sql = 'select @result = ' + @s
	EXEC sp_executesql @sql, N'@result float output', @result OUT

	-- Return value being calculated
	SET @response_message = @result
END
GO
PRINT N'Prozedur "[dbo].[import_csv]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[import_csv]
	-- Add the parameters for the stored procedure here
	@strPath VARCHAR(MAX),
	@message BIT OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		DECLARE @sql varchar(max)
		-- DECLARE @csv TABLE(id int, request int, method int, instrument int, keyword nvarchar(max), value_txt nvarchar(max))

		-- Import with universal file format
		SET @sql = '
		BULK INSERT import
		FROM '''+@strPath+''' WITH
		(
			DATAFILETYPE=''char'',
			FIRSTROW=2,
			FIELDTERMINATOR = '','', 
			ROWTERMINATOR = ''\n''
		)
		'
		EXEC (@sql)
		SET @message = 1
	END TRY
	BEGIN CATCH
		SET @message = 0
	END CATCH
END
GO
PRINT N'Prozedur "[dbo].[message_extract_sql]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Extract keywords in message
-- =============================================
CREATE PROCEDURE [dbo].[message_extract_sql] 
	-- Add the parameters for the stored procedure here
	@p_message NVARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @key_open BigIntList, @key_close BigIntList, @keys StringList, @pos INT, @i INT

	-- Store the position of opening brackets
	SET @i = 0
	SET @pos = 1
	WHILE CHARINDEX('[', @p_message, @pos) > 0
	BEGIN
		INSERT INTO @key_open VALUES(@i, CHARINDEX('[', @p_message, @pos))
		SET @pos = (SELECT value FROM @key_open WHERE id = @i) + 1
		SET @i = @i + 1
	END

	-- Store the position of closing brackets
	SET @i = 0
	SET @pos = 1
	WHILE CHARINDEX(']', @p_message, @pos) > 0
	BEGIN
		INSERT INTO @key_close VALUES(@i, CHARINDEX(']', @p_message, @pos))
		SET @pos = (SELECT value FROM @key_close WHERE id = @i) + 1
		SET @i = @i + 1
	END

	-- Store the fields named in brackets
	SET @i = 0
	WHILE @i < (SELECT COUNT(*) FROM @key_Open)
	BEGIN
		INSERT INTO @keys VALUES(@i, SUBSTRING(@p_message, (SELECT value FROM @key_open WHERE id = @i), (SELECT value FROM @key_close WHERE id = @i) - (SELECT value FROM @key_open WHERE id = @i) + 1))
		SET @i = @i + 1
	END

	-- Delete field duplicates
	DELETE T FROM (SELECT *, DupRank = ROW_NUMBER() OVER (PARTITION BY value ORDER BY (SELECT NULL)) FROM @keys) AS T WHERE DupRank > 1 

	SELECT * FROM @keys
END
GO
PRINT N'Trigger "[dbo].[request_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[request_update]
   ON  [dbo].[request]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @subject NVARCHAR(256)
	DECLARE @body NVARCHAR(MAX)
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @request INT, @method INT, @i INT
	DECLARE @formulation_profile INT

	SET @request = (SELECT id FROM inserted)

	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		-- Check if invoicing is allowed
		IF (SELECT COUNT(*) FROM measurement WHERE (measurement.state = 'CP' OR measurement.state = 'AQ') AND measurement.request = (SELECT id FROM inserted)) > 0 AND (SELECT invoice FROM inserted) = 1
		THROW 51000, 'Invoicing not allowed. Measurements still in progress.', 1

		-- Check if state is allowed
		IF (SELECT state FROM inserted) NOT IN (SELECT step FROM step WHERE state = (SELECT state FROM deleted) AND applies = 1)
			THROW 51000, 'State not valid.', 1

		-- Check if subrequest is valid
		IF (SELECT COUNT(*) FROM request WHERE id = (SELECT subrequest FROM inserted)) < 1 AND (SELECT subrequest FROM inserted) IS NOT NULL
			THROW 51000, 'Invalid subrequest', 1

		-- Check if profile selection is valid
		IF (SELECT deactivate FROM profile WHERE id = (SELECT profile FROM inserted)) = 1
			THROW 51000, 'Profile invalid.', 1

		-- Check if formulation matches profile
		SET @formulation_profile = (SELECT project.profile FROM project INNER JOIN formulation ON (formulation.project = project.id) WHERE formulation.id = (SELECT formulation FROM inserted))
		IF @formulation_profile <> (SELECT profile FROM inserted) AND @formulation_profile IS NOT NULL AND (SELECT formulation FROM inserted) <> (SELECT formulation FROM deleted)
			THROW 51000, 'Invalid formulation.', 1

		-- Check if storage position is set in case of storing a sample
		IF (SELECT state.state FROM request INNER JOIN state ON (state.id = request.state) WHERE request.id = (SELECT id FROM inserted)) = 'ST' AND (SELECT COUNT(*) FROM strposition WHERE request = (SELECT id FROM inserted)) = 0
			THROW 51000, 'Storage position missing.', 1

		-- Check for valid sampling point
		IF (SELECT customer FROM inserted) IS NOT NULL AND (SELECT COUNT(*) FROM smppoint WHERE id = (SELECT smppoint FROM inserted) AND customer <> (SELECT customer FROM inserted) AND customer IS NOT NULL) > 0
			THROW 51000, 'Sampling point not valid for customer.', 1
		IF (SELECT customer FROM inserted) IS NULL AND (SELECT COUNT(*) FROM smppoint WHERE id = (SELECT smppoint FROM inserted) AND customer IS NOT NULL) > 0
			THROW 51000, 'Sampling point is not global.', 1
		
		-- Prevent samples from being disposed if they are still stored
		IF (SELECT state.state FROM request INNER JOIN state ON (state.id = request.state) WHERE request.id = (SELECT id FROM inserted)) = 'DX' AND (SELECT COUNT(*) FROM strposition WHERE request = (SELECT id FROM inserted)) > 0
			THROW 51000, 'Storage position still in place.', 1

		-- Insert all analysis services to table request_analysis
		INSERT INTO request_analysis (analysis, request) SELECT id, (SELECT id FROM inserted) FROM analysis WHERE deactivate = 0 EXCEPT SELECT analysis, request FROM request_analysis

		IF (SELECT profile FROM inserted) IS NOT NULL
		BEGIN
			DECLARE cur CURSOR FOR SELECT analysis FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND applies = 1

			OPEN cur
			FETCH NEXT FROM cur INTO @i
			WHILE @@FETCH_STATUS = 0
			BEGIN
			-- Add profile specific analysis services
			SET @method = (SELECT method FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND analysis = @i)
			EXEC measurement_insert @request, @i, @method
			-- Update request_analysis table with profile analysis services selected
			UPDATE request_analysis SET applies = 1, method = @method WHERE request = @request AND analysis = @i
			-- Update sortkey according profile seetings
			UPDATE measurement SET sortkey = (SELECT sortkey FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND analysis = @i) WHERE request = @request AND analysis = @i
			FETCH NEXT FROM cur INTO @i
			END
			CLOSE cur
			DEALLOCATE cur
		END

		-- Record state traversal date
		IF (SELECT state FROM inserted) <> (SELECT state FROM deleted)
			INSERT INTO traversal (state, traversal_date, traversal_by, request) VALUES((SELECT state FROM inserted), GETDATE(), SUSER_NAME(), (SELECT id FROM inserted))
		
		-- Prepare mail with laboratory report if applies
		--IF (SELECT state FROM state WHERE id = (SELECT state FROM inserted)) = 'MA'
		--BEGIN
		--	SET @sql = 'SELECT @subject = ' + (SELECT language FROM users WHERE name = SUSER_NAME()) + ' FROM translation WHERE container = ''labreport_std'' AND item = ''subject''' 
		--	EXEC sp_executesql @sql, N'@subject nvarchar(max) output', @subject OUT

		--	SET @sql = 'SELECT @body = ' + (SELECT language FROM users WHERE name = SUSER_NAME()) +  ' FROM translation WHERE container = ''labreport_std'' AND item = ''body''' 
		--	EXEC sp_executesql @sql, N'@body nvarchar(max) output', @body OUT
	
		--	INSERT INTO mailqueue (subject, body, request) VALUES(@subject, @body, (SELECT id FROM inserted))
		--END

		-- Prepare mail with retract advice if applies
		--IF (SELECT state FROM state WHERE id = (SELECT state FROM inserted)) = 'RT'
		--BEGIN
		--	SET @sql = 'SELECT @subject = ' + (SELECT language FROM users WHERE name = SUSER_NAME()) + ' FROM translation WHERE container = ''retract_std'' AND item = ''subject''' 
		--	EXEC sp_executesql @sql, N'@subject nvarchar(max) output', @subject OUT

		--	SET @sql = 'SELECT @body = ' + (SELECT language FROM users WHERE name = SUSER_NAME()) +  ' FROM translation WHERE container = ''retract_std'' AND item = ''body''' 
		--	EXEC sp_executesql @sql, N'@body nvarchar(max) output', @body OUT

		--	INSERT INTO mailqueue (subject, body, request) VALUES(@subject, @body, (SELECT id FROM inserted))
		--END
	END
END
GO
PRINT N'Trigger "[dbo].[request_insert]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[request_insert]
   ON  [dbo].[request] 
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @request INT, @method INT, @i INT
	DECLARE @formulation_profile INT

	SET @request = (SELECT id FROM inserted)

	-- Check if invoicing is allowed
	IF (SELECT COUNT(*) FROM measurement WHERE (measurement.state = 'CP' OR measurement.state = 'AQ') AND measurement.request = (SELECT id FROM inserted)) > 0 AND (SELECT invoice FROM inserted) = 1
		THROW 51000, 'Invoicing not allowed. Measurements still in progress.', 1

	-- Check if profile selection is valid
	IF (SELECT deactivate FROM profile WHERE id = (SELECT profile FROM inserted)) = 1 OR (SELECT COUNT(*) FROM profile INNER JOIN strposition ON (profile.reference_material = strposition.id) INNER JOIN material ON (strposition.material = material.id) WHERE profile.id = (SELECT profile FROM inserted) AND profile.use_profile_qc = 1 AND strposition.expiration < GETDATE() AND material.deactivate = 1) > 0
		THROW 51000, 'Profile invalid.', 1

	-- Check if formulation matches profile
	SET @formulation_profile = (SELECT project.profile FROM project INNER JOIN formulation ON (formulation.project = project.id) WHERE formulation.id = (SELECT formulation FROM inserted))
	IF @formulation_profile <> (SELECT profile FROM inserted) AND @formulation_profile IS NOT NULL
		THROW 51000, 'Invalid formulation.', 1

	-- Check if subrequest is valid
	IF (SELECT COUNT(*) FROM request WHERE id = (SELECT subrequest FROM inserted)) < 1 AND (SELECT subrequest FROM inserted) IS NOT NULL
		THROW 51000, 'Invalid subrequest.', 1

	-- Check for valid sampling point
	IF (SELECT customer FROM inserted) IS NOT NULL AND (SELECT COUNT(*) FROM smppoint WHERE id = (SELECT smppoint FROM inserted) AND customer <> (SELECT customer FROM inserted) AND customer IS NOT NULL) > 0
		THROW 51000, 'Sampling point not valid for customer.', 1
	IF (SELECT customer FROM inserted) IS NULL AND (SELECT COUNT(*) FROM smppoint WHERE id = (SELECT smppoint FROM inserted) AND customer IS NOT NULL) > 0
		THROW 51000, 'Sampling point is not global.', 1

	-- Update state to the first relevant one
	UPDATE request SET state = (SELECT TOP 1 id FROM state WHERE workflow = (SELECT workflow FROM inserted)) WHERE id = (SELECT id FROM inserted)

	-- Insert all analysis services to table request_analysis
	INSERT INTO request_analysis (analysis, request) SELECT id, (SELECT id FROM inserted) FROM analysis WHERE deactivate = 0

	IF (SELECT profile FROM inserted) IS NOT NULL
	BEGIN
		DECLARE cur CURSOR FOR SELECT analysis FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND applies = 1

		OPEN cur
		FETCH NEXT FROM cur INTO @i
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Add profile specific analysis services
			SET @method = (SELECT method FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND analysis = @i)
			EXEC measurement_insert @request, @i, @method
			-- Update request_analysis table with profile analysis services selected
			UPDATE request_analysis SET applies = 1, method = @method WHERE request = @request AND analysis = @i
			-- Update sortkey according profile seetings
			UPDATE measurement SET sortkey = (SELECT sortkey FROM profile_analysis WHERE profile = (SELECT profile FROM inserted) AND analysis = @i) WHERE request = @request AND analysis = @i
			FETCH NEXT FROM cur INTO @i
		END
		CLOSE cur
		DEALLOCATE cur
	END

	-- Assign subrequest to acual id
	UPDATE request SET subrequest = (SELECT id FROM inserted) WHERE id = (SELECT id FROM inserted)

	-- Insert custom fields
	INSERT INTO request_customfield (field_name, request) SELECT field_name, (SELECT id FROM inserted) FROM customfield WHERE table_name = 'request'

	-- Record state traversal date
	INSERT INTO traversal (state, traversal_date, traversal_by, request) VALUES((SELECT TOP 1 id FROM state WHERE workflow = (SELECT workflow FROM inserted)), GETDATE(), SUSER_NAME(), (SELECT id FROM inserted))
END
GO
PRINT N'Trigger "[dbo].[measurement_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_update]
   ON  [dbo].[measurement]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @request INT, @analysis INT, @method INT, @instrument INT
	DECLARE @message NVARCHAR(MAX)
	DECLARE @value_changed BIT
	DECLARE @profile INT
	DECLARE @lsl FLOAT
	DECLARE @usl FLOAT
	DECLARE @lsl_include BIT
	DECLARE @usl_include BIT

	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		SET @request = (SELECT request FROM deleted)
		SET @analysis = (SELECT analysis FROM deleted)

		-- Set value changed bit
		IF (SELECT value_txt FROM inserted) <> (SELECT value_txt FROM deleted) OR (SELECT value_num FROM inserted) <> (SELECT value_num FROM deleted) OR ((SELECT value_num FROM inserted) IS NOT NULL AND (SELECT value_num FROM deleted) IS NULL) OR (((SELECT value_txt FROM inserted) IS NOT NULL AND (SELECT value_txt FROM deleted) IS NULL))
			SET @value_changed = 1
		ELSE
			SET @value_changed = 0
		
		-- Prevent forbidden state traversals
		IF (SELECT state FROM inserted) <> (SELECT state FROM deleted)
		BEGIN
			IF (SELECT state FROM inserted) = 'CP'
				THROW 51000, 'State change not allowed.', 1
			IF (SELECT state FROM deleted) = 'RT' OR (SELECT state FROM deleted) = 'RE'
				THROW 51000, 'State change not allowed.', 1
		END

		-- Prevent unwanted column changes
		IF (SELECT state FROM deleted) <> 'CP' AND (SELECT calculation_activate FROM analysis WHERE id = (SELECT analysis FROM inserted)) = 0
		BEGIN
			UPDATE measurement SET request = (SELECT request FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET analysis = (SELECT analysis FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET method = (SELECT method FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET instrument = (SELECT instrument FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET value_txt = (SELECT value_txt FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET value_num = (SELECT value_num FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET uncertainty = (SELECT uncertainty FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET out_of_range = (SELECT out_of_range FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET not_detectable = (SELECT not_detectable FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET acquired_by = (SELECT acquired_by FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET acquired_at = (SELECT acquired_at FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET validated_by = (SELECT validated_by FROM deleted) WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET validated_at = (SELECT validated_at FROM deleted) WHERE id = (SELECT id FROM inserted)
		END

		-- Capture case
		IF (SELECT state FROM deleted) = 'CP' OR (SELECT calculation_activate FROM analysis WHERE id = (SELECT analysis FROM inserted)) = 1
		BEGIN
			IF (SELECT method FROM inserted) IS NOT NULL
			BEGIN
				-- Check validity of method
				IF (SELECT method FROM inserted) NOT IN (SELECT method FROM method_analysis WHERE method = (SELECT method FROM inserted) AND analysis = (SELECT analysis FROM inserted) AND applies =1) AND (SELECT method FROM inserted) IS NOT NULL
					THROW 51000, 'Method not valid.', 1
				-- Check qualification of user
				IF (SELECT method FROM inserted) NOT IN (SELECT method FROM qualification WHERE method = (SELECT method FROM inserted) AND valid_from <= GETDATE() AND valid_till >= GETDATE() AND withdraw = 0 AND user_id = (SELECT id FROM users WHERE name = SUSER_NAME()))
					THROW 51000, 'User not qualified to acquire data using this method.', 1
				END

			IF (SELECT instrument FROM inserted) IS NOT NULL
			BEGIN
				-- Check validity of instrument
				IF (SELECT instrument FROM inserted) NOT IN (SELECT instrument FROM instrument_method WHERE method = (SELECT method FROM inserted) AND applies =1) AND (SELECT instrument FROM inserted) IS NOT NULL AND (SELECT method FROM inserted) IS NOT NULL
					THROW 51000, 'Instrument not valid.', 1
				-- Check certificate of instrument
				IF (SELECT instrument FROM inserted) NOT IN (SELECT instrument FROM certificate WHERE valid_from <= GETDATE() AND valid_till >= GETDATE() AND withdraw = 0 AND instrument = (SELECT instrument FROM inserted))
					THROW 51000, 'Instrument has no valid certificate.', 1
			END

			-- Update the state
			--IF (SELECT state FROM deleted) = 'CP'
			--	UPDATE measurement SET state = 'AQ' WHERE id = (SELECT id FROM inserted)

			-- Determine out of range results
			IF (SELECT value_num FROM inserted) > (SELECT udl FROM analysis WHERE id = (SELECT analysis FROM inserted)) OR (SELECT value_num FROM inserted) < (SELECT ldl FROM analysis WHERE id = (SELECT analysis FROM inserted))
				UPDATE measurement SET out_of_range = 1 WHERE id = (SELECT id FROM inserted)
			ELSE
				UPDATE measurement SET out_of_range = 0 WHERE id = (SELECT id FROM inserted)

			-- Determine out of specification results
			SET @profile = (SELECT request.profile FROM request INNER JOIN measurement ON (request.id = measurement.request) WHERE measurement.id = (SELECT id FROM inserted))
			IF @profile IS NOT NULL AND (SELECT tsl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) IS NULL
			BEGIN
				IF (SELECT value_num FROM inserted) > (SELECT usl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) AND (SELECT usl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) = 0
				BEGIN
					UPDATE measurement SET out_of_spec = 1 WHERE id = (SELECT id FROM inserted)
				END
				IF (SELECT value_num FROM inserted) >= (SELECT usl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) AND (SELECT usl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) = 1
				BEGIN
					UPDATE measurement SET out_of_spec = 1 WHERE id = (SELECT id FROM inserted)
				END
				IF (SELECT value_num FROM inserted) < (SELECT lsl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) AND (SELECT lsl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) = 0
				BEGIN
					UPDATE measurement SET out_of_spec = 1 WHERE id = (SELECT id FROM inserted)
				END
				IF (SELECT value_num FROM inserted) <= (SELECT lsl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) AND (SELECT lsl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted)) = 1
				BEGIN
					UPDATE measurement SET out_of_spec = 1 WHERE id = (SELECT id FROM inserted)
				END
			END

			-- Determine valid accreditation
			IF (SELECT COUNT(id) FROM method_smptype WHERE method = (SELECT method FROM inserted) AND applies = 1) > 0
			BEGIN
				UPDATE measurement SET accredited = 1 WHERE id = (SELECT id FROM inserted)
			END

			-- Determine uncertainty
			UPDATE measurement SET uncertainty = (SELECT uncertainty FROM uncertainty WHERE value_min <= (SELECT value_num FROM inserted) AND value_max > (SELECT value_num FROM inserted) AND analysis = (SELECT analysis FROM inserted)) WHERE id = (SELECT id FROM inserted)

			-- Set unit
			UPDATE measurement SET unit = (SELECT unit FROM analysis WHERE id = (SELECT analysis FROM inserted)) WHERE id = (SELECT id FROM inserted)

			-- Set date and user who acquired the value
			UPDATE measurement SET acquired_by = SUSER_NAME() WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET acquired_at = GETDATE() WHERE id = (SELECT id FROM inserted)

			-- Set value_txt in case of attribute results
			IF (SELECT type FROM analysis WHERE id = (SELECT analysis FROM inserted)) = 'A'
			BEGIN
				UPDATE measurement SET value_txt= (SELECT attribute.title FROM attribute INNER JOIN analysis ON (attribute.analysis = analysis.id) WHERE attribute.value = (SELECT value_num FROM inserted) AND attribute.analysis = (SELECT analysis FROM inserted)) WHERE id = (SELECT id FROM inserted)
			END

			-- Set value_txt in case of numeric values
			IF (SELECT type FROM analysis WHERE id = (SELECT analysis FROM inserted)) = 'N'
			BEGIN
				UPDATE measurement SET value_txt = (ROUND((SELECT value_num FROM inserted), (SELECT precision FROM analysis WHERE id = (SELECT analysis FROM inserted)))) WHERE id = (SELECT id FROM inserted)
			END

			-- Check for qc measurement and block instrument in case of out of control event
			SET @lsl = (SELECT lsl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted))
			SET @usl = (SELECT usl FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted))
			SET @lsl_include = (SELECT lsl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted))
			SET @usl_include = (SELECT usl_include FROM profile_analysis WHERE profile = @profile AND analysis = (SELECT analysis FROM inserted))

			IF @profile IS NOT NULL AND (SELECT use_profile_qc FROM profile WHERE id = @profile) = 1
			BEGIN
				IF (@lsl > (SELECT value_num FROM inserted) AND @lsl IS NOT NULL) OR (@usl < (SELECT value_num FROM inserted) AND @usl IS NOT NULL) OR (@lsl >= (SELECT value_num FROM inserted) AND @lsl IS NOT NULL AND @lsl_include = 1) OR (@usl <= (SELECT value_num FROM inserted) AND @usl IS NOT NULL AND @usl_include = 1)
					IF (SELECT instrument FROM inserted) IS NOT NULL
						UPDATE certificate SET withdraw = 1 WHERE instrument = (SELECT instrument FROM inserted)
			END

			-- Check for expired reference materials
			--IF (SELECT COUNT(*) AS cnt FROM (profile INNER JOIN strposition ON profile.reference_material = strposition.id) INNER JOIN material ON strposition.material = material.id WHERE material.deactivate=1 OR strposition.expiration < GETDATE() AND  profile.id = @profile) > 0
			IF (SELECT COUNT(*) AS cnt FROM profile INNER JOIN profile_analysis ON profile_analysis.profile = profile.id INNER JOIN strposition ON profile.reference_material = strposition.id INNER JOIN material ON strposition.material = material.id WHERE material.deactivate=1 OR strposition.expiration < GETDATE() AND profile_analysis.applies = 1 AND profile.id = @profile AND profile_analysis.analysis = @analysis) > 0
				THROW 51000, 'Reference material expired.', 1
		END

		-- Create a new measurement if retest is chosen
		IF (SELECT state FROM inserted) = 'RE' AND (SELECT state FROM deleted) <> 'CP' EXEC measurement_insert @request, @analysis

		-- Allow to retract at any time
		IF (SELECT state FROM inserted) = 'RT'
		BEGIN
			UPDATE measurement SET state = 'RT' WHERE id = (SELECT id FROM inserted)
			UPDATE request_analysis SET applies = 0 WHERE request = @request AND analysis = @analysis
		END

		-- Allow to valdiate if state is AQ
		IF (SELECT state FROM inserted) = 'VD' AND (SELECT state FROM deleted) = 'AQ'
		BEGIN
			UPDATE measurement SET validated_by = SUSER_NAME() WHERE id = (SELECT id FROM inserted)
			UPDATE measurement SET validated_at = GETDATE() WHERE id = (SELECT id FROM inserted)
		END
	END
END
GO
PRINT N'Trigger "[dbo].[request_analysis_update]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[request_analysis_update] 
   ON  [dbo].[request_analysis]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		DECLARE @request INT, @analysis INT, @method INT, @i INT, @j INT

		SET @request = (SELECT request FROM inserted)
		SET @analysis = (SELECT analysis FROM inserted)
		SET @method = (SELECT method FROM inserted)

		IF (SELECT applies FROM inserted) = 1
		BEGIN
			-- Insert measurments according selected analsis
			EXEC measurement_insert @request, @analysis, @method

			-- Insert dependant analysis if applies
			DECLARE cur CURSOR FOR SELECT analysis_id FROM cfield WHERE analysis = @analysis AND analysis_id IS NOT NULL ORDER BY id
			OPEN cur
			FETCH NEXT FROM cur INTO @i
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC measurement_insert @request, @i
				
				-- Handle any subdependence of analysis service
				IF (SELECT calculation_activate FROM analysis WHERE id = @i) = 1
				BEGIN
					DECLARE cur2 CURSOR FOR SELECT analysis_id FROM cfield WHERE analysis = @i AND analysis_id IS NOT NULL ORDER BY id
					OPEN cur2
					FETCH NEXT FROM cur2 INTO @j
					WHILE @@FETCH_STATUS = 0
					BEGIN
						EXEC measurement_insert @request, @j
						UPDATE request_analysis SET applies = 1 WHERE analysis = @j
						FETCH NEXT FROM cur2 INTO @j
					END
					CLOSE cur2
					DEALLOCATE cur2
				END

				UPDATE request_analysis SET applies = 1 WHERE analysis = @i
				FETCH NEXT FROM cur INTO @i
			END
			CLOSE cur
			DEALLOCATE cur
		END

		-- Retract if unapplied
		IF (SELECT applies FROM inserted) = 0
			UPDATE measurement SET state = 'RT' WHERE request = (SELECT request FROM inserted) AND analysis = (SELECT analysis FROM inserted)
	END
END
GO
PRINT N'Prozedur "[dbo].[message_substitute_sql]" wird erstellt...';


GO
-- =======================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Substitute SQL statements in message texts
-- =======================================================
CREATE PROCEDURE [dbo].[message_substitute_sql]
	-- Add the parameters for the stored procedure here
	@p_message NVARCHAR(MAX),
	@return_message NVARCHAR(MAX) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @t StringList
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @tmp NVARCHAR(MAX)
	DECLARE @value NVARCHAR(MAX)

	-- Create list with sql statements to execute
	INSERT INTO @t EXEC message_extract_sql @p_message

	SET @i = 0
	WHILE @i < (SELECT COUNT(*) FROM @t)
	BEGIN
		-- Get the sql statement with paranthesis for substitiution
		SET @sql = (SELECT value FROM @t WHERE id = @i)

		-- Exclude parantheses for execution
		SET @tmp = REPLACE(REPLACE(@sql, ']', ''), '[', '')

		-- Prevent data from being manipulated
		IF CHARINDEX('INSERT', @tmp) <> 0 OR CHARINDEX('UPDATE', @tmp) <> 0 OR CHARINDEX('DELETE', @tmp) <> 0 
			THROW 51000, 'Forbidden statement.', 1

		-- Execute sql statement
		EXEC sp_executesql @tmp, N'@value nvarchar(max) output', @value OUT

		-- Substitute sql statement with value
		SET @p_message = REPLACE(@p_message, @sql, @value)

		SET @i = @i + 1
	END

	SET @return_message = @p_message
END
GO
PRINT N'Prozedur "[dbo].[calculation_iterate]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[calculation_iterate]
	-- Add the parameters for the stored procedure here
	@request INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @f FLOAT
	DECLARE c_cur CURSOR FOR SELECT measurement.id FROM measurement INNER JOIN analysis ON (analysis.id = measurement.analysis) WHERE measurement.request = @request AND (measurement.state = 'CP' Or measurement.state = 'AQ' Or measurement.state = 'VD') AND analysis.calculation_activate = 1 ORDER BY measurement.id

	OPEN c_cur
	FETCH NEXT FROM c_cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC calculation_perform @i, @f OUTPUT
		UPDATE measurement SET value_num = @f WHERE id = @i AND (state = 'AQ' Or state = 'CP')
		FETCH NEXT FROM c_cur INTO @i
	END
	CLOSE c_cur
	DEALLOCATE c_cur
END
GO
PRINT N'Prozedur "[dbo].[request_create_subrequest]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[request_create_subrequest] 
	-- Add the parameters for the stored procedure here
	@p_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @pk INT
	DECLARE @ignore ColumnList

	INSERT INTO @ignore VALUES('profile')

	-- Duplicate record of choice
	EXEC row_duplicate 'request', @ignore, @p_id, @pk OUTPUT

	-- Attach newly created request to parent
	UPDATE request SET subrequest = @p_id WHERE id = @p_id
	UPDATE request SET subrequest = @p_id WHERE id = @pk
END
GO
PRINT N'Prozedur "[dbo].[mail_send]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[mail_send] 
	-- Add the parameters for the stored procedure here
	@p_recipients VARCHAR(MAX),
	@p_subject VARCHAR(256),
	@p_body VARCHAR(MAX),
	@p_filenames VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @mail_profile VARCHAR(256)
	DECLARE @s_subject NVARCHAR(MAX)
	DECLARE @s_body NVARCHAR(MAX)

	SET @mail_profile = (SELECT TOP 1 email_profile FROM setup)

	-- Substitue sql statements if applies
	EXEC message_substitute_sql @p_subject, @s_subject OUT
	EXEC message_substitute_sql @p_body, @s_body OUT

	EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = @mail_profile,  
    @recipients = @p_recipients,  
	@body_format = 'HTML',
	@subject = @s_subject,
    @body = @s_body,
	@file_attachments = @p_filenames;
END
GO
PRINT N'Prozedur "[dbo].[attachment_save]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[attachment_save] 
	-- Add the parameters for the stored procedure here
	@id INT, -- ID of the attachment to be saved
	@strFolder NVARCHAR(200), -- the temporary folder
	@strFile NVARCHAR(200) OUTPUT -- Returns the filename as string
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @init INT
    DECLARE @Data VARBINARY(MAX)
	DECLARE @strPath VARCHAR(MAX)
	DECLARE @fileName NVARCHAR(MAX)

	-- Check if folder exists otherwise create
	EXEC folder_create @strFolder

	SET @FileName = (SELECT file_name FROM attachment WHERE ID = @id)
	
	SELECT @data = blob, @strPath = 'C:\' + @strFolder + '\' + CONVERT(nvarchar, @id) + '_' + @FileName FROM attachment WHERE id = @id;
	
	EXEC sp_OACreate 'ADODB.Stream', @init OUTPUT; -- Create Object
	EXEC sp_OASetProperty @init, 'Type', 1;
	EXEC sp_OAMethod @init, 'Open';
	EXEC sp_OAMethod @init, 'Write', NULL, @data;
	EXEC sp_OAMethod @init, 'SaveToFile', NULL, @strPath, 2;
	EXEC sp_OAMethod @init, 'Close';
	EXEC sp_OADestroy @init; -- Destroy Object

	SET @strFile = @strPath
END
GO
PRINT N'Prozedur "[dbo].[import_perform]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[import_perform] 
	-- Add the parameters for the stored procedure here
	@strFolder nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT, @j INT
	DECLARE @keyword NVARCHAR(MAX), @value_txt NVARCHAR(MAX), @request INT, @method INT, @instrument INT, @measurement INT
	DECLARE @imported BIT, @cmd NVARCHAR(MAX)
	DECLARE @strCmd VARCHAR(1024)
	DECLARE @strFile nvarchar(max)
	DECLARE @files TABLE (ID INT IDENTITY, FileName VARCHAR(MAX))

	BEGIN TRY
		TRUNCATE TABLE import

		-- Concatenate command string
		SET @strCmd = CONCAT('dir ' , @strFolder, '\*.csv /b')

		-- Create file list
		INSERT INTO @files execute xp_cmdshell @strCmd
		DELETE FROM @files WHERE FileName IS NULL

		-- Import measurement values from import file
		DECLARE import_cur CURSOR FOR SELECT id FROM @files ORDER BY id
		OPEN import_cur
		FETCH NEXT FROM import_cur INTO @i
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Perform import of measurement data
			SET @strFile=CONCAT(@strFolder, '\', (SELECT FileName FROM @files WHERE id = @i))
			EXEC import_csv @strFile, @imported OUT

			-- Delete imported file
			IF @imported = 1
			BEGIN
				SET @cmd = 'xp_cmdshell ''del ' + @strFile + '"'''
				EXEC (@cmd)
			END
			
			FETCH NEXT FROM import_cur INTO @i
		END
		CLOSE import_cur
		DEALLOCATE import_cur

		-- Update measurements
		DECLARE consume_cur CURSOR FOR SELECT id FROM import ORDER BY id
		OPEN consume_cur
		FETCH NEXT FROM consume_cur INTO @j
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Consume imported values as measurement data
			SET @keyword = (SELECT keyword FROM import WHERE id = @j)
			SET @value_txt = (SELECT value_txt FROM import WHERE id = @j)
			SET @request = (SELECT request FROM import WHERE id = @j)
			SET @method = (SELECT method FROM import WHERE id = @j)
			SET @instrument = (SELECT instrument FROM import WHERE id = @j)
			
			-- Handle analysis services
			IF SUBSTRING(@keyword, 1, 1) = 'A'
			BEGIN
				SET @measurement = (SELECT id FROM measurement WHERE state = 'CP' AND analysis = CONVERT(INT, SUBSTRING(@keyword, 2, LEN(@keyword))) AND request = @request)
				
				IF ISNUMERIC(@value_txt) = 1 AND @measurement IS NOT NULL
					UPDATE measurement SET value_num = CONVERT(FLOAT, @value_txt), method = @method, instrument = @instrument, state = 'AQ' WHERE id = @measurement --state = 'CP' AND analysis = CONVERT(INT, SUBSTRING(@keyword, 2, LEN(@keyword))) AND request = @request
				
				IF ISNUMERIC(@value_txt) = 0 AND @measurement > 0
					UPDATE measurement SET value_txt = @value_txt, method = @method, instrument = @instrument, state = 'AQ' WHERE id = @measurement --state = 'CP' AND analysis = CONVERT(INT, SUBSTRING(@keyword, 2, LEN(@keyword))) AND request = @request			
			END

			-- Handle calculated fields
			IF SUBSTRING(@keyword, 1, 1) = 'F'
			BEGIN
				SET @measurement = (SELECT measurement.id FROM measurement INNER JOIN measurement_cfield ON measurement.id = measurement_cfield.measurement WHERE measurement.state = 'CP' AND measurement_cfield.cfield = CAST(SUBSTRING(@keyword, 2, LEN(@keyword)) AS INT) AND measurement.request = @request)

				IF ISNUMERIC(@value_txt) = 1 AND @measurement IS NOT NULL
					UPDATE measurement_cfield SET value_num = CONVERT(FLOAT, @value_txt) WHERE cfield = CONVERT(INT, SUBSTRING(@keyword, 2, LEN(@keyword))) AND measurement = @measurement
			END

			EXEC calculation_iterate @request

			FETCH NEXT FROM consume_cur INTO @j
		END
		CLOSE consume_cur
		DEALLOCATE consume_cur

	END TRY
	BEGIN CATCH
		DEALLOCATE import_cur
		DEALLOCATE consume_cur
	END CATCH
END
GO
PRINT N'Prozedur "[dbo].[calculation_test]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- ==============================================
CREATE PROCEDURE [dbo].[calculation_test] 
	-- Add the parameters for the stored procedure here
	@analysis INT,
	@response_message FLOAT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @f KeyValueList
	DECLARE @t StringList
	DECLARE @equation NVARCHAR(MAX)
	DECLARE @i INT
	DECLARE @id INT
	DECLARE @s NVARCHAR(MAX)
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @result FLOAT
	DECLARE cur CURSOR FOR SELECT id FROM cvalidate WHERE analysis = @analysis ORDER BY id

	SET @equation = (SELECT calculation FROM analysis WHERE id = @analysis)

	-- Get key and value
	OPEN cur
	FETCH NEXT FROM cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (SELECT analysis_id FROM cvalidate WHERE id = @i) IS NULL
		BEGIN
			SET @id = (SELECT cfield_id FROM cvalidate WHERE id = @i)
			INSERT INTO @f
				VALUES ('[F'+CAST(@id As NVARCHAR(MAX))+']', (SELECT value FROM cvalidate WHERE id = @i))
		END

		IF (SELECT cfield_id FROM cvalidate WHERE id = @i) IS NULL
		BEGIN
			SET @id = (SELECT analysis_id FROM cvalidate WHERE id = @i)
			INSERT INTO @f
				VALUES ('[A'+CAST(@id As NVARCHAR(MAX))+']', (SELECT value FROM cvalidate WHERE id = @i))
		END

		FETCH NEXT FROM cur INTO @i
	END
	CLOSE cur
	DEALLOCATE cur

	-- Extract keywors of equation
	INSERT INTO @t
	EXEC calculation_extract_keyword @equation

	-- Substitute keywords by value
	EXEC calculation_substitute_keyword @t, @f, @equation, @s OUT

	-- Evaluate euqation
	SET @sql = 'select @result = ' + @s
	EXEC sp_executesql @sql, N'@result float output', @result OUT

	-- Return value being calculated
	SET @response_message = @result
END
GO
PRINT N'Prozedur "[dbo].[mailqueue_process]" wird erstellt...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[mailqueue_process]
	-- Add the parameters for the stored procedure here
	@strFolder NVARCHAR(200) -- the temporary folder
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @j INT
	DECLARE @k INT
	DECLARE @r NVARCHAR(MAX)
	DECLARE @t NVARCHAR(MAX)
	DECLARE @s NVARCHAR(MAX)
	DECLARE @cc NVARCHAR(MAX)
	DECLARE @subject NVARCHAR(MAX)
	DECLARE @body NVARCHAR(MAX)

	-- Create temporary folder if it does not exist
	EXEC folder_create @strFolder

	DECLARE mailqueue_cur CURSOR FOR SELECT id FROM mailqueue WHERE processed_at IS NULL ORDER BY request

	OPEN mailqueue_cur
	FETCH NEXT FROM mailqueue_cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN

		DECLARE attachment_rqt CURSOR FOR SELECT id FROM attachment WHERE request = (SELECT request FROM mailqueue WHERE id = @i) AND attach = 1 ORDER BY id
		-- Prepare request attachments in case of provided request
		IF (SELECT request FROM mailqueue WHERE id = @i) IS NOT NULL
		BEGIN
			OPEN attachment_rqt
			FETCH NEXT FROM attachment_rqt INTO @j
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC attachment_save @j, @strFolder, @s OUT
				IF @t <> '' SET @t = CONCAT(@t,';', @s) ELSE SET @t =  @s
				FETCH NEXT FROM attachment_rqt INTO @j
			END
			CLOSE attachment_rqt
			DEALLOCATE attachment_rqt
		END

		DECLARE attachment_inv CURSOR FOR SELECT id FROM attachment WHERE billing_customer = (SELECT billing_customer FROM mailqueue WHERE id = @i) AND attach = 1 ORDER BY id
		-- Prepare invoice attachments in case of provided request
		IF (SELECT billing_customer FROM mailqueue WHERE id = @i) IS NOT NULL
		BEGIN
			OPEN attachment_inv
			FETCH NEXT FROM attachment_inv INTO @j
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC attachment_save @j, @strFolder, @s OUT
				IF @t <> '' SET @t = CONCAT(@t,';', @s) ELSE SET @t =  @s
				FETCH NEXT FROM attachment_inv INTO @j
			END
			CLOSE attachment_inv
			DEALLOCATE attachment_inv
		END

		-- Prepare recipients list
		DECLARE recipients_cur CURSOR FOR SELECT id FROM contact WHERE customer = (SELECT customer FROM request WHERE id = (SELECT request FROM mailqueue WHERE id = @i)) ORDER BY id

		OPEN recipients_cur
		FETCH NEXT FROM recipients_cur INTO @k
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT email FROM contact WHERE id = @k)
			IF @r <> '' SET @r = CONCAT(@r,';', @s) ELSE SET @r = @s
			FETCH NEXT FROM recipients_cur INTO @k
		END
		CLOSE recipients_cur
		DEALLOCATE recipients_cur

		-- Get CC E-Mail
		SET @cc = (SELECT cc_email FROM request WHERE id = (SELECT request FROM mailqueue WHERE id = @i))

		-- Send mail
		IF (SELECT recipients FROM mailqueue WHERE id = @i) IS NOT NULL
			SET @r = (SELECT recipients FROM mailqueue WHERE id = @i)

		-- Concat recipients if cc applies
		IF @cc IS NOT NULL
			SET @r = CONCAT(@r, ';', @cc)

		SET @subject = (SELECT subject FROM mailqueue WHERE id = @i)
		SET @body = (SELECT body FROM mailqueue WHERE id = @i)

		EXEC mail_send @r, @subject, @body, @t
		UPDATE mailqueue SET processed_at = GETDATE() WHERE id = @i

		-- Clean attachment list	
		SET @t = ''
		SET @r = ''

		FETCH NEXT FROM mailqueue_cur INTO @i
	END
	CLOSE mailqueue_cur
	DEALLOCATE mailqueue_cur
END
GO
PRINT N'Erweiterte Eigenschaft "[dbo].[condition].[type].[MS_Description]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'N-Numeric, A-Attribute, T-Text', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'condition', @level2type = N'COLUMN', @level2name = N'type';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[analysis].[type].[MS_Description]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'N-Numeric, A-Attribute, T-Text', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'analysis', @level2type = N'COLUMN', @level2name = N'type';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[analysis].[uncertainty_activate].[MS_Description]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'R-Range,C-Calculation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'analysis', @level2type = N'COLUMN', @level2name = N'uncertainty_activate';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[measurement].[state].[MS_Description]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CP - Captured, AQ - Aquired, RE - Retest, RT - Retract, VD - Validated', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'measurement', @level2type = N'COLUMN', @level2name = N'state';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[profile_analysis].[tsl].[MS_Description]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Text specification limit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'profile_analysis', @level2type = N'COLUMN', @level2name = N'tsl';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[state].[title].[MS_Description]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CP - Captured, IM - Intermediate, RJ - Reject, RC - Received, VD - Validated, ML - Mailed, DP - Dispatched, ST - Stored, DX - Disposed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'state', @level2type = N'COLUMN', @level2name = N'title';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[state].[state].[MS_Description]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CP - Captured, RT - Retract, RC - Received, VD - Validated, MA - Mailed, DP - Dispatched, ST - Stored, DX - Disposed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'state', @level2type = N'COLUMN', @level2name = N'state';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_labreport_details].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[39] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "measurement"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "technique"
            Begin Extent = 
               Top = 6
               Left = 895
               Bottom = 119
               Right = 1065
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 6
               Left = 479
               Bottom = 136
               Right = 649
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 687
               Bottom = 136
               Right = 857
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_labreport_details';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_labreport_details].[MS_DiagramPane2]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2895
         Table = 2820
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_labreport_details';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_labreport_details].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_labreport_details';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_project_owner].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = -1001
      End
      Begin Tables = 
         Begin Table = "project"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 119
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 2205
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_project_owner';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_project_owner].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_project_owner';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_worksheet_details].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[25] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "measurement"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "technique"
            Begin Extent = 
               Top = 6
               Left = 479
               Bottom = 136
               Right = 649
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 6
               Left = 687
               Bottom = 136
               Right = 857
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 895
               Bottom = 136
               Right = 1065
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2745
         Ta', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_worksheet_details';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_worksheet_details].[MS_DiagramPane2]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'ble = 4020
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_worksheet_details';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_worksheet_details].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_worksheet_details';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_owner].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "request"
            Begin Extent = 
               Top = 12
               Left = 76
               Bottom = 259
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "audit"
            Begin Extent = 
               Top = 12
               Left = 445
               Bottom = 259
               Right = 720
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 27
         Width = 284
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
         Width = 750
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_owner';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_owner].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_owner';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_measurement].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[54] 4[23] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "state"
            Begin Extent = 
               Top = 365
               Left = 994
               Bottom = 495
               Right = 1164
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "request"
            Begin Extent = 
               Top = 264
               Left = 679
               Bottom = 394
               Right = 861
            End
            DisplayFlags = 280
            TopColumn = 18
         End
         Begin Table = "customer"
            Begin Extent = 
               Top = 147
               Left = 996
               Bottom = 277
               Right = 1166
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "measurement"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 346
               Right = 381
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 449
               Left = 570
               Bottom = 579
               Right = 765
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "instrument"
            Begin Extent = 
               Top = 747
               Left = 340
               Bottom = 877
               Right = 515
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 584
               Left = 437
               Bottom = 713
               Right = 607
            End
            Displ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_measurement].[MS_DiagramPane2]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'ayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1575
         Alias = 2220
         Table = 2805
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_measurement].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_billing_position].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[24] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "billing_position"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "profile"
            Begin Extent = 
               Top = 638
               Left = 433
               Bottom = 768
               Right = 619
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "material"
            Begin Extent = 
               Top = 489
               Left = 436
               Bottom = 619
               Right = 632
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 347
               Left = 437
               Bottom = 475
               Right = 632
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "service"
            Begin Extent = 
               Top = 200
               Left = 436
               Bottom = 330
               Right = 633
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 60
               Left = 436
               Bottom = 190
               Right = 633
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width =', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_billing_position';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_billing_position].[MS_DiagramPane2]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' 1815
         Width = 2040
         Width = 3105
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 19005
         Alias = 4290
         Table = 5085
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_billing_position';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_billing_position].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_billing_position';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_measurement].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[44] 4[25] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -188
         Left = 0
      End
      Begin Tables = 
         Begin Table = "measurement"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 723
               Right = 490
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 413
               Left = 712
               Bottom = 543
               Right = 907
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "instrument"
            Begin Extent = 
               Top = 572
               Left = 709
               Bottom = 702
               Right = 884
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "technique"
            Begin Extent = 
               Top = 447
               Left = 1158
               Bottom = 721
               Right = 1554
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 268
               Left = 712
               Bottom = 398
               Right = 882
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 528
               Bottom = 136
               Right = 698
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 20
         Width = 284
         Width = 1500
         Width = 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_measurement].[MS_DiagramPane2]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3375
         Alias = 3270
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_request_measurement].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_request_measurement';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_attachment_revision].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "attachment"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 359
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "users"
            Begin Extent = 
               Top = 6
               Left = 442
               Bottom = 136
               Right = 612
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1830
         Width = 1500
         Width = 5340
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_attachment_revision';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_attachment_revision].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_attachment_revision';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_task].[MS_DiagramPane1]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[22] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "task"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "project"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 136
               Right = 432
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1470
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 3480
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_task';


GO
PRINT N'Erweiterte Eigenschaft "[dbo].[view_task].[MS_DiagramPaneCount]" wird erstellt...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_task';


GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET MULTI_USER 
    WITH ROLLBACK IMMEDIATE;


GO
PRINT N'Update abgeschlossen.';


GO
