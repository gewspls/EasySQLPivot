/*
* Created by: Louis Feather
* Created on: 2019-04-07
* Description: Stored procedure designed to make it easy to pivot tables in SQL.
* License: Apache License 2.0
*/

CREATE PROCEDURE dbo.EasySQLPivot (
	 @TableToPivot VARCHAR(128)
	,@SourceQuery NVARCHAR(MAX) = NULL
	,@ColumnHeadingsColumn VARCHAR(128)
	,@ColumnValuesColumn VARCHAR(128)
	,@Aggregate VARCHAR(20)
)
AS

DECLARE @Cols VARCHAR(MAX);
DECLARE @Query NVARCHAR(MAX);

DECLARE @GetColumnsQuery NVARCHAR(MAX);
SET @GetColumnsQuery = N'
	SELECT @OutputCols = STUFF((SELECT DISTINCT
		'','' + QUOTENAME(' + @ColumnHeadingsColumn + ')
	FROM ' + @TableToPivot + '
	FOR XML PATH('''')
	,TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''');
';

EXEC sp_executesql @GetColumnsQuery, N'@OutputCols VARCHAR(MAX) OUTPUT', @OutputCols = @Cols OUTPUT;

SET @Query = N'
	SELECT
		' + @Cols + '
	FROM (
		' + 
			CASE
				WHEN @SourceQuery IS NULL THEN 'SELECT * FROM ' + @TableToPivot
				ELSE @SourceQuery
			END
		 + '
	) t
	PIVOT (
		' +
			CASE
				WHEN UPPER(@Aggregate) = 'MAX' THEN 'MAX(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'MIN' THEN 'MIN(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'AVG' THEN 'AVG(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'CHECKSUM_AGG' THEN 'CHECKSUM_AGG(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'COUNT' THEN 'COUNT(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'COUNT_BIG' THEN 'COUNT_BIG(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'STDEV' THEN 'STDEV(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'STDEVP' THEN 'STDEVP(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'SUM' THEN 'SUM(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'VAR' THEN 'VAR(' + @ColumnValuesColumn + ')'
				WHEN UPPER(@Aggregate) = 'VARP' THEN 'VARP(' + @ColumnValuesColumn + ')'
				ELSE NULL
			END
		+ '
		FOR ' + @ColumnHeadingsColumn + ' IN (' + @Cols + ')
	) p
';

BEGIN TRY
	EXEC sp_executesql @Query;
END TRY
BEGIN CATCH
	PRINT 'Pivoting ' + @TableToPivot + ' Failed. Have you selected the correct aggregate function?';
END CATCH