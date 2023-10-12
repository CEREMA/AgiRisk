SELECT pg_attribute.attname, pg_type.typname
FROM pg_class
JOIN pg_attribute ON pg_class.relname='zt' AND pg_attribute.attrelid=pg_class.oid AND attnum > 0
JOIN pg_type ON pg_type.oid=pg_attribute.atttypid
WHERE pg_type.typname !='geometry'
