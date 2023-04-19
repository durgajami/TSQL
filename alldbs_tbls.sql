--exec sp_MSforeachdb 
--'SELECT db=''?'', [type], [name], [text] FROM [?]..sysobjects a inner join [?]..syscomments b on a.id = b.id where text like ''%Text to search for%'' order by [name], [number]', '?'
DECLARE @db   VARCHAR(255)
DECLARE @sch  VARCHAR(255)
DECLARE @tbl  VARCHAR(255)
DECLARE @sql1 VARCHAR(255)
DECLARE @col  VARCHAR(255)
DECLARE @typ  VARCHAR(255)
DECLARE @len  SMALLINT
DECLARE @pre  SMALLINT
DECLARE @scl  SMALLINT
DECLARE @isn  SMALLINT
DECLARE @cid  SMALLINT
DECLARE @serv  VARCHAR(255)

DECLARE @DatabasesKst TABLE
(
  database_name VARCHAR(255),
  schema_name   VARCHAR(255),
  table_name    VARCHAR(255),
  col_name      VARCHAR(255),
  typ_name      VARCHAR(255),
  len1          SMALLINT,
  pres          SMALLINT,
  scale1        SMALLINT,
  isn           SMALLINT,
  colid			SMALLINT 
  )
--select * from sys.tables
--select * from sys.columns
INSERT INTO @DatabasesKst
EXEC sp_MSforeachdb N' USE ? 
select ''?'', schema_name(TAB.schema_id),TAB.name,COL.name,TYP.name, COL.max_length,COL.precision,COL.scale,COL.is_nullable,COL.column_id
from.sys.tables TAB inner join sys.columns COL on (TAB.object_id = COL.object_id) 
inner join sys.types TYP on (COL.system_type_id = TYP.system_type_id)
where lower(TAB.name) like ''validationrun'' 
and schema_name(TAB.schema_id) <> ''staging'' 
and schema_name(TAB.schema_id) <> ''core''
and schema_name(TAB.schema_id) not like ''Locked%'' 
'
/*select * from @DatabasesKst where database_name not like '%DO_NOT_USE'*/
select @serv = @@SERVERNAME 
PRINT @serv
PRINT '--------------------------------------------------------------------------'
DECLARE db_cursor CURSOR FOR 
select * from @DatabasesKst where database_name not like '%DO_NOT_USE' 
order by colid
--order by col_name, database_name, schema_name, table_name
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO  @db,@sch,@tbl,@col,@typ,@len,@pre,@scl,@isn,@cid 
WHILE @@FETCH_STATUS = 0
BEGIN
SET @sql1 =    @db + '.' + @sch + '.' + @tbl
--PRINT 'USE ' + @db
--PRINT 'go'
--PRINT 'EXEC sp_help ' + '''' + @sql1 + ''''
PRINT  @col + char(9) + @typ + char(9) + cast(@len as varchar)  + char(9) + cast(@pre as varchar)  + char(9) + cast(@scl as varchar) + char(9) + cast(@isn as varchar) + char(9) +  
@db + char(9) + @sch+ char(9) + @tbl + char(9) + cast(@cid as varchar) 
--use BatchImportLiberty
--go
--EXEC sp_help 'BatchImportLiberty.raw.Member'
FETCH NEXT FROM db_cursor INTO  @db,@sch,@tbl,@col,@typ,@len,@pre,@scl,@isn,@cid 
END
CLOSE db_cursor
DEALLOCATE db_cursor
/*
DECLARE @db VARCHAR(255);
DECLARE @usql VARCHAR(255);
DECLARE db_cursor CURSOR FOR 
select name from sys.databases
where 1=1
and name not in ('master','tempdb','model','msdb','zwork','BatchImportABCBS') 
and name not like '%Core%' and name not like 'Hedis%'
and name   like 'Batch%'
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @db
WHILE @@FETCH_STATUS = 0
BEGIN
 SET @usql = 'use ' +    @db  
 PRINT @db
 PRINT @usql
 exec sp_MSforeachdb @usql
 select db_name()
 select schema_name(schema_id), name  from.sys.tables
 where lower(name) like '%member%' 
 FETCH NEXT FROM db_cursor INTO @db 
END
CLOSE db_cursor
DEALLOCATE db_cursor 
*/
 /*
use BatchImportCodes
go
SELECT @@SERVERNAME 
SELECT DB_NAME()
select schema_name(schema_id), name  from.sys.tables
where lower(name) like '%a%' 
*/
/*
DECLARE @command varchar(4000)
SELECT @command = '
USE [?] 
SELECT 
database_name = CAST(DB_NAME(database_id) AS VARCHAR(50))
, log_size_mb = CAST(SUM(CASE WHEN type_desc = "LOG" THEN size END) * 8. / 1024 AS DECIMAL(8,2))
, row_size_mb = CAST(SUM(CASE WHEN type_desc = "ROWS" THEN size END) * 8. / 1024 AS DECIMAL(8,2))
, total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))
, Kostenstelle = CAST((select value from sys.extended_properties WHERE     name =     "Kostenstelle") AS VARCHAR(10))
FROM sys.master_files WITH(NOWAIT)
WHERE database_id = DB_ID()
GROUP BY database_id
'
DECLARE @DatabasesKst TABLE
(
  database_name VARCHAR(50),
  log_size_mb DECIMAL(8,2),
  row_size_mb DECIMAL(8,2),
  total_size DECIMAL(8,2),
  Kostenstelle VARCHAR(100)
)
INSERT  INTO @DatabasesKst
EXEC sp_MSforeachdb @command
select @@SERVERNAME 
select * from @DatabasesKst
*/