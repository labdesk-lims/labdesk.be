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
