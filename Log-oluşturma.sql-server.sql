EXEC sp_attach_single_file_db @dbname = 'hediyelik',
@physname = 'C:\Program Files\Microsoft SQL Server\MSSQL16.TEST\MSSQL\DATA\hediyelik.mdf'


CREATE DATABASE hediyelik 
ON (FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.TEST\MSSQL\DATA\hediyelik.mdf')
FOR ATTACH_FORCE_REBUILD_LOG



