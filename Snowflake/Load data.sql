// Creating external stage (create your own bucket)
CREATE OR REPLACE STAGE SCD_DEMO.SCD2.customer_ext_stage
    url='s3://dw-snowflake-realtime/stream_data'
    credentials=(aws_key_id='YOUR_KEY' aws_secret_key='zYOUR_SECRETE_KEY');
   

CREATE OR REPLACE FILE FORMAT SCD_DEMO.SCD2.CSV
TYPE = CSV,
FIELD_DELIMITER = ","
SKIP_HEADER = 1;

SHOW STAGES;
LIST @customer_ext_stage;


CREATE OR REPLACE PIPE customer_s3_pipe
  auto_ingest = true
  AS
  COPY INTO customer_raw
  FROM @customer_ext_stage/customer_20250724081330.csv
  FILE_FORMAT = CSV
  FORCE = TRUE;
  

show pipes;
select SYSTEM$PIPE_STATUS('customer_s3_pipe');

SELECT * FROM customer_raw;

TRUNCATE  customer_raw;