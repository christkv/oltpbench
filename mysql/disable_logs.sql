SET GLOBAL general_log = 'OFF';
SET GLOBAL slow_query_log = 'OFF';
SET GLOBAL log_queries_not_using_indexes = 'OFF';

SHOW GLOBAL VARIABLES WHERE Variable_name  IN ('general_log', 'general_log_file', 'slow_query_log', 'slow_query_log_file', 'log_output');