
SELECT T1.TABLE_NAME AS "Table Name"
     , (SELECT PD.description
          FROM PG_STAT_ALL_TABLES PS INNER JOIN
               PG_DESCRIPTION PD ON PS.RELID = PD.OBJOID
         WHERE PS.SCHEMANAME = T1.TABLE_SCHEMA
           AND PS.relname = T1.TABLE_NAME
           AND PD.objsubid = 0
       ) AS "TABLE Comment"
     , T1.ordinal_position AS "ID"
     , T1.column_name AS "Column Name"
     , CASE WHEN (SELECT COUNT(1) AS FIND
                    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS PT INNER JOIN
                         INFORMATION_SCHEMA.constraint_column_usage PC ON PT.table_catalog = PC.table_catalog
                     AND PT.table_schema = PC.table_schema
                     AND PT.table_name = PC.table_name
                     AND PT.constraint_name = PC.constraint_name
                   WHERE PT.constraint_type = 'PRIMARY KEY'
                     AND PT.table_schema = T1.TABLE_SCHEMA
                     AND PT.table_name = T1.TABLE_NAME
                     AND PC.column_name = T1.column_name
                 ) = 0 THEN ''
                       ELSE 'Y'
       END AS "PK"
     , T1.is_nullable AS "Not Null"
     , T1.udt_name AS "Data Type"
     , LTRIM(CASE WHEN data_type = 'numeric' THEN numeric_precision::VARCHAR || CASE WHEN numeric_scale = 0 THEN ''
                                             ELSE ',' || numeric_scale::VARCHAR
                                                                                END
                                             ELSE character_maximum_length::VARCHAR
             END) AS "Size"
     , CASE WHEN STRPOS(T1.column_default, '::') > 0 THEN substring(T1.column_default,1,STRPOS(T1.column_default, '::') -1) ELSE T1.column_default END AS "Default"
     , (SELECT PD.description
          FROM PG_STAT_ALL_TABLES PS INNER JOIN
               PG_DESCRIPTION PD ON PS.RELID = PD.OBJOID LEFT OUTER JOIN
               PG_ATTRIBUTE PA ON PD.OBJOID = PA.ATTRELID
           AND PD.OBJSUBID = PA.ATTNUM
         WHERE PS.SCHEMANAME = T1.TABLE_SCHEMA
           AND PS.relname = T1.TABLE_NAME
           AND PA.attname = T1.column_name
           AND PD.objsubid <> 0
       ) AS "Column Comment"
  FROM INFORMATION_SCHEMA.COLUMNS T1
 WHERE 1=1
   AND UPPER(T1.TABLE_SCHEMA) = UPPER('public')
 ORDER BY TABLE_NAME, ordinal_position
;
