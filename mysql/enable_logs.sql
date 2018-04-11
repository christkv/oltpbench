/* Turn general operation log on */
SET GLOBAL general_log = 'ON';

/* Turn slow operations log on */
SET GLOBAL slow_query_log = 'ON';

/* Log all non indexed queries */
SET GLOBAL log_queries_not_using_indexes = ON;


SHOW GLOBAL VARIABLES WHERE Variable_name  IN ('general_log', 'general_log_file', 'slow_query_log', 'slow_query_log_file', 'log_output');

-- SHOW GLOBAL VARIABLES LIKE 'general_log%';
-- SHOW GLOBAL VARIABLES LIKE 'general_log_file';
-- SHOW GLOBAL VARIABLES LIKE 'slow_query_log%';
-- SHOW GLOBAL VARIABLES LIKE 'slow_query_log_file';
-- SHOW GLOBAL VARIABLES LIKE 'log_output';

/*SHOW GLOBAL VARIABLES LIKE '%log%';*/