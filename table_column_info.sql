SELECT
	info. TABLE_NAME,
	info. COLUMN_NAME,
	info.udt_name as type,
	case when info.character_maximum_length is null then info.numeric_precision else info.character_maximum_length end as length,
	info.column_default,
	info.is_nullable,
	comm.column_comment as comment,
	case when pri_key.column_name is null then '' else 'PK' end as PK
FROM
	information_schema. COLUMNS info
LEFT JOIN (
	SELECT
		PS.schemaname as SCHEMA_NAME,
		PS.RELNAME AS TABLE_NAME,
		PA.ATTNAME AS COLUMN_NAME,
		PD.DESCRIPTION AS COLUMN_COMMENT
	FROM
		PG_STAT_ALL_TABLES PS,
		PG_DESCRIPTION PD,
		PG_ATTRIBUTE PA
	WHERE
		PS.RELID = PD.OBJOID
	AND PD.OBJSUBID <> 0
	AND PD.OBJOID = PA.ATTRELID
	AND PD.OBJSUBID = PA.ATTNUM
	ORDER BY
		PS.RELNAME,
		PD.OBJSUBID
) comm ON comm.SCHEMA_NAME = info.table_schema
AND comm. TABLE_NAME = info. TABLE_NAME
AND comm. COLUMN_NAME = info. COLUMN_NAME
LEFT JOIN (
	SELECT
		CC.*
	FROM
		INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC,
		INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE CC
	WHERE
		TC.CONSTRAINT_TYPE = 'PRIMARY KEY'
   AND TC.TABLE_CATALOG   = CC.TABLE_CATALOG
   AND TC.TABLE_SCHEMA    = CC.TABLE_SCHEMA
   AND TC.TABLE_NAME      = CC.TABLE_NAME
   AND TC.CONSTRAINT_NAME = CC.CONSTRAINT_NAME
) pri_key ON pri_key.table_schema = info.table_schema
AND pri_key. table_name = info.TABLE_NAME
AND pri_key. column_name = info. COLUMN_NAME
WHERE
	info.table_schema = 'public'
ORDER BY
	info. TABLE_NAME,
	info.ordinal_position;
