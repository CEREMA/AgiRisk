WITH tempa AS
	(
		SELECT *
		FROM pg_catalog.pg_namespace
		WHERE nspname LIKE 'c\_%'
		OR nspname LIKE 'p\_%'
		OR nspname LIKE 'r\_%'
		ORDER BY nspname
	)
SELECT DISTINCT on (pg_type.typname) pg_attribute.attname, pg_type.typname
FROM pg_class
JOIN pg_attribute ON  pg_attribute.attrelid=pg_class.oid AND attnum > 0 
JOIN pg_type ON pg_type.oid=pg_attribute.atttypid
JOIN tempa ON tempa.oid=pg_class.relnamespace
WHERE pg_type.typname !='geometry'