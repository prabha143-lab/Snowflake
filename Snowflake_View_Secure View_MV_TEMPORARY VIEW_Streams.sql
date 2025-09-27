CREATE OR REPLACE TABLE transactions (
    transaction_id STRING,
    account_number STRING,
    amount NUMBER(10,2),
    currency STRING,
    transaction_date DATE
);


CREATE OR REPLACE VIEW vw_transactions AS
SELECT * FROM transactions;


CREATE OR REPLACE SECURE VIEW secure_vw_transactions AS
SELECT * FROM transactions;


CREATE OR REPLACE MATERIALIZED VIEW mv_transactions AS
SELECT transaction_id, amount, currency
FROM transactions
WHERE amount > 1000;


CREATE OR REPLACE STREAM vw_transactions_stream
ON VIEW vw_transactions;


CREATE OR REPLACE STREAM secure_vw_transactions_stream
ON VIEW secure_vw_transactions;

CREATE OR REPLACE STREAM mv_transactions_stream
ON VIEW mv_transactions;
--Object found is of type 'MATERIALIZED_VIEW', not specified type 'VIEW'.




CREATE OR REPLACE TEMPORARY VIEW temp_vw_transactions AS
SELECT transaction_id, amount, currency
FROM transactions
WHERE amount > 1000;


CREATE OR REPLACE STREAM mv_temp_vw_transactions
ON VIEW temp_vw_transactions;--Stream MV_TEMP_VW_TRANSACTIONS successfully created.

