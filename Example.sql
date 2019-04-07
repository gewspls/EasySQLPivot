/*
* Created by: Louis Feather
* Created on: 2019-04-07
* Description: Example usage of the SQLEasyPivot stored procedure.
* License: Apache License 2.0
*/

EXEC dbo.EasySQLPivot 
	@TableToPivot = 'dbo.PivotMe'
	,@ColumnHeadingsColumn = 'ColumnName'
	,@ColumnValuesColumn = 'ColumnValue'
	,@Aggregate = 'MAX'