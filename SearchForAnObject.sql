EXEC sp_MSforeachdb N' USE ? 
select   @@servername, type_desc, concat(''?'',''.'',schema_name(schema_id),''.'',name) object   from sys.objects  a where  name like ''%uspInsertSSIS%'' ' 
