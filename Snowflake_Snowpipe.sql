CREATE PIPE my_snowpipe
AUTO_INGEST = TRUE
AS
COPY INTO my_table
FROM @my_external_stage
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format')
ON_ERROR = 'CONTINUE'
PURGE = TRUE
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
MAX_FILE_SIZE = 104857600  -- 100 MB
PATTERN = '.*\\.csv'  -- Only CSV files
VALIDATION_MODE = 'RETURN_ERRORS'
FORCE = TRUE
DATE_FORMAT = 'MM-DD-YYYY'
TIME_FORMAT = 'HH24:MI:SS'
TIMESTAMP_FORMAT = 'MM-DD-YYYY HH24:MI:SS'
ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE
ENFORCE_LENGTH = TRUE
FORCE_RECURSIVE = TRUE
TRUNCATECOLUMNS = TRUE
EMPTY_FIELD_AS_NULL = TRUE
FORCE_SINGLE_PATH = TRUE;



CREATE PIPE my_snowpipe  -- Creates a new pipe named 'my_snowpipe' for continuous data ingestion.
AUTO_INGEST = TRUE  -- Enables automatic data ingestion when new files arrive in the specified stage.
AS
COPY INTO my_table  -- Specifies the target table 'my_table' into which the data will be loaded.
FROM @my_external_stage  -- Specifies the source stage '@my_external_stage' from which the data files will be ingested.
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format')  -- Uses the predefined file format 'my_csv_format' for data loading.
ON_ERROR = 'CONTINUE'  -- Continues loading the remaining data even if some rows cause errors.
PURGE = TRUE  -- Deletes successfully loaded files from the stage after they are loaded into the table.
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE  -- Allows case-insensitive column matching between the source files and the target table.
MAX_FILE_SIZE = 104857600  -- Limits the size of files to 100 MB to ensure only files of a certain size are loaded.
PATTERN = '.*\\.csv'  -- Only loads files with a '.csv' extension, filtering based on the specified pattern.
VALIDATION_MODE = 'RETURN_ERRORS'  -- Returns errors encountered during data loading, useful for testing and debugging.
FORCE = TRUE  -- Loads all files, including those that have already been loaded, without checking if they were previously loaded.
DATE_FORMAT = 'MM-DD-YYYY'  -- Customizes the format for date fields in the data files.
TIME_FORMAT = 'HH24:MI:SS'  -- Customizes the format for time fields in the data files.
TIMESTAMP_FORMAT = 'MM-DD-YYYY HH24:MI:SS'  -- Customizes the format for timestamp fields in the data files.
ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE  -- Generates an error if the number of columns in the data file does not match the number of columns in the table.
ENFORCE_LENGTH = TRUE  -- Ensures that the data does not exceed the defined column length in the table schema.
FORCE_RECURSIVE = TRUE  -- Enables recursive loading for files in nested directories within the stage.
TRUNCATECOLUMNS = TRUE  -- Truncates the data if it is longer than the target column width, instead of generating an error.
EMPTY_FIELD_AS_NULL = TRUE  -- Loads empty fields as NULLs in the target table.
FORCE_SINGLE_PATH = TRUE;  -- Forces the COPY command to use a single execution path, useful for debugging.
