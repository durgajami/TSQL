truncate table djamiclm
BULK INSERT djamiclm
FROM 'Z:\Fix\File1.txt'
WITH (
    FIELDTERMINATOR = '|',  -- Specify the field terminator (comma for CSV)
    ROWTERMINATOR = '\n',    -- Specify the row terminator (newline)
    FIRSTROW = 1,             -- Specify the row number to start importing (optional)
	--LASTROW=10 ,
	FORMATFILE = 'Z:\Fix\data.fmt'
);

select top 10 *  from djamiclm
select count(*) from djamiclm
-- Enable xp_cmdshell
--EXEC sp_configure 'show advanced options', 1;
--RECONFIGURE;
--EXEC sp_configure 'xp_cmdshell', 1;
--RECONFIGURE;
EXEC xp_cmdshell 'powershell.exe -Command "Get-Content  Z:\Fix\File1.txt | Measure-Object -Line"';

SELECT *
FROM OPENROWSET(
    BULK 'Z:\Fix\abc.txt',
    FORMATFILE = 'Z:\Fix\data.fmt'

) AS Data;


data.fmt contents
9.0
2
1 SQLCHAR 0 100 "|" 1 SingleColumn "Latin1_General_CI_AS"
2 SQLCHAR       0       100     "\r\n"   2     Col2         SQL_Latin1_General_CP1_CI_AS

-- Extracting first column, Need to define second col for the rest of the data in the row until end

