C:\Users\prabh>pip install "certifi<2025.4.26" -t C:/temp/certifi
Collecting certifi<2025.4.26
  Using cached certifi-2025.1.31-py3-none-any.whl.metadata (2.5 kB)
Using cached certifi-2025.1.31-py3-none-any.whl (166 kB)
Installing collected packages: certifi
Successfully installed certifi-2025.1.31
WARNING: Target directory C:\temp\certifi\certifi already exists. Specify --upgrade to force replacement.
WARNING: Target directory C:\temp\certifi\certifi-2025.1.31.dist-info already exists. Specify --upgrade to force replacement.

C:\Users\prabh>set REQUESTS_CA_BUNDLE=C:\temp\certifi\certifi\cacert.pem

C:\Users\prabh>snowsql -a JABGDWO-GY97629 -u prabhakarreddy1433
Password:
* SnowSQL * v1.3.3
Type SQL statements or !help
prabhakarreddy1433#COMPUTE_WH@(no database).(no schema)>USE DATABASE MYSNOW;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.129s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Pythontestfiles/employees_test.csv @my_stage AUTO_COMPRESS=FA
                                            LSE;
+--------------------+--------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source             | target             | source_size | target_size | source_compression | target_compression | status   | message |
|--------------------+--------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employees_test.csv | employees_test.csv |         119 |         128 | NONE               | NONE               | UPLOADED |         |
+--------------------+--------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 8.446s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Pythontestfiles/departments_test.csv @my_stage AUTO_COMPRESS=FALSE;
+----------------------+----------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source               | target               | source_size | target_size | source_compression | target_compression | status   | message |
|----------------------+----------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| departments_test.csv | departments_test.csv |          54 |          64 | NONE               | NONE               | UPLOADED |         |
+----------------------+----------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 2.635s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>