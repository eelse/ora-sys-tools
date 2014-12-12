CREATE OR REPLACE PACKAGE SYS_TOOLS 
AS 

  /*********************************************************
   * Return the name of the schema the user is logged into
   *********************************************************/
   FUNCTION GET_CURRENT_SCHEMA RETURN VARCHAR2;

  /*********************************************************
   * Function to check if a database object with given name
   * of given type exists
   *********************************************************/
  FUNCTION EXISTS_OBJECT( P_OWNER_NAME  IN VARCHAR2
                        , P_OBJECT_NAME IN VARCHAR2
                        , P_OBJECT_TYPE IN VARCHAR2
                        ) RETURN           BOOLEAN;
 
  /*********************************************************
   * Function to check if a table column with given name (and 
   * optionally of given type) given type exists
   *********************************************************/
   FUNCTION EXISTS_COLUMN( P_OWNER_NAME IN VARCHAR2
                         , P_TABLE_NAME IN VARCHAR2
                         , P_COLUMN_NAME IN VARCHAR2
                         , P_COLUMN_TYPE IN VARCHAR2 DEFAULT NULL
                         , P_CHAR_LENGTH IN VARCHAR2 DEFAULT NULL
                         , P_NULLABLE    IN VARCHAR2 DEFAULT NULL
                         ) RETURN           BOOLEAN;

  /*********************************************************
   * Function to check if a table column with given name (and 
   * optionally of given type) given type exists
   *********************************************************/
   FUNCTION EXISTS_COLUMN( P_TABLE_NAME IN VARCHAR2
                         , P_COLUMN_NAME IN VARCHAR2
                         , P_COLUMN_TYPE IN VARCHAR2 DEFAULT NULL
                         , P_CHAR_LENGTH IN VARCHAR2 DEFAULT NULL
                         , P_NULLABLE    IN VARCHAR2 DEFAULT NULL
                         ) RETURN           BOOLEAN;
                          
  /*********************************************************
   * Function to check if a sequence with given name exists
   *********************************************************/
  FUNCTION EXISTS_SEQUENCE( P_OWNER_NAME  IN VARCHAR2
                          , P_SEQUENCE_NAME IN VARCHAR2
                          ) RETURN             BOOLEAN;
  
  /*********************************************************
   * Function to check if a table with given name exists
   *********************************************************/
  FUNCTION EXISTS_TABLE( P_OWNER_NAME  IN VARCHAR2
                       , P_TABLE_NAME IN VARCHAR2
                       ) RETURN          BOOLEAN;

  /*********************************************************
   * Function to check if a trigger with given name exists
   *********************************************************/
  FUNCTION EXISTS_TRIGGER( P_OWNER_NAME  IN VARCHAR2
                         , P_TRIGGER_NAME IN VARCHAR2
                         ) RETURN            BOOLEAN;

  /*********************************************************
   * Function to check if an index with given name exists
   *********************************************************/
  FUNCTION EXISTS_INDEX( P_OWNER_NAME  IN VARCHAR2
                       , P_INDEX_NAME IN VARCHAR2
                       ) RETURN          BOOLEAN;

  /*********************************************************
   * Function to check if a type with given name exists
   *********************************************************/
  FUNCTION EXISTS_TYPE( P_OWNER_NAME  IN VARCHAR2
                      , P_TYPE_NAME IN VARCHAR2
                      ) RETURN            BOOLEAN;

  /*********************************************************
   * Function to check if a constraint with given name exists
   *********************************************************/
  FUNCTION EXISTS_CONSTRAINT( P_OWNER_NAME      IN VARCHAR2
                            , P_CONSTRAINT_NAME IN VARCHAR2
                            ) RETURN               BOOLEAN;

  /*********************************************************
   * Function to retrieve the maximum ID used thus far in a 
   * table
   *********************************************************/
  FUNCTION GET_TABLE_MAX_ID( P_OWNER_NAME  IN VARCHAR2
                           , P_TABLE_NAME IN VARCHAR2
                           ) RETURN          NUMBER;

  /*********************************************************
   * Function to check if a database object with given name
   * of given type exists
   *********************************************************/
  FUNCTION EXISTS_OBJECT( P_OBJECT_NAME IN VARCHAR2
                        , P_OBJECT_TYPE IN VARCHAR2
                        ) RETURN           BOOLEAN;
                          
  /*********************************************************
   * Function to check if a sequence with given name exists
   *********************************************************/
  FUNCTION EXISTS_SEQUENCE( P_SEQUENCE_NAME IN VARCHAR2
                          ) RETURN             BOOLEAN;
  
  /*********************************************************
   * Function to check if a table with given name exists
   *********************************************************/
  FUNCTION EXISTS_TABLE( P_TABLE_NAME IN VARCHAR2
                       ) RETURN          BOOLEAN;

  /*********************************************************
   * Function to check if a trigger with given name exists
   *********************************************************/
  FUNCTION EXISTS_TRIGGER( P_TRIGGER_NAME IN VARCHAR2
                         ) RETURN            BOOLEAN;

  /*********************************************************
   * Function to check if an index with given name exists
   *********************************************************/
  FUNCTION EXISTS_INDEX( P_INDEX_NAME IN VARCHAR2
                       ) RETURN          BOOLEAN;

  /*********************************************************
   * Function to check if a type with given name exists
   *********************************************************/
  FUNCTION EXISTS_TYPE( P_TYPE_NAME IN VARCHAR2
                      ) RETURN            BOOLEAN;

  /*********************************************************
   * Function to retrieve the maximum ID used thus far in a 
   * table
   *********************************************************/
  FUNCTION GET_TABLE_MAX_ID( P_TABLE_NAME IN VARCHAR2
                           ) RETURN          NUMBER;

  /*********************************************************
   * Function to check if a constraint with given name exists
   *********************************************************/
  FUNCTION EXISTS_CONSTRAINT( P_CONSTRAINT_NAME IN VARCHAR2
                            ) RETURN               BOOLEAN;

  /*********************************************************
   * Procedure that finds all invalid recompilable objects 
   * in the current schema and tries to recompile them.
   *********************************************************/
   PROCEDURE COMPILE_INVALID_OBJECTS;

END SYS_TOOLS;
/
