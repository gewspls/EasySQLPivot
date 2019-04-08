# EasySQLPivot
Until recently I've always had trouble with Pivoting in T-SQL.
I decided to write this Stored Procedure to make it a little bit easier.  
*Disclaimer: I wouldn't recommend this Stored Procedure for use in a Production Environment. This repository  
was just for fun and demonstrate the use of dynamic T-SQL.*

### Usage
Usage is simple, download the Stored Procedure and create it using your preferred SQL Editor.

Then simply execute the Stored Procedure as shown in the **Example.sql** file.
#### Parameters

****@TableToPivot****  
The source table to perform the pivot operation on.  

****@SourceQuery****  
Optional Parameter - Allows the ability to use a source query (e.g with joins) to perform  
the pivot on rather than just providing a source table.

****@ColumnHeadingsColumn****  
The column in the source which contains the values to be used as column headings.

****@ColumnValuesColumn****  
The column in the source table which contains the values to be used as values for the pivoted columns.

****@Aggregate****  
The aggregate function to use within the PIVOT Operation.
