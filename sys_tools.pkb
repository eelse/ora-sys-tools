CREATE OR REPLACE PACKAGE BODY SYS_TOOLS
AS

  FUNCTION GET_CURRENT_SCHEMA RETURN VARCHAR2
  IS
     V_SCHEMA_NAME VARCHAR2(30 CHAR);
  BEGIN
     SELECT SYS_CONTEXT( 'userenv', 'current_schema' )
     INTO   V_SCHEMA_NAME
     FROM   DUAL
     ;
     RETURN V_SCHEMA_NAME;
  END;
  
  FUNCTION EXISTS_OBJECT( P_OWNER_NAME  IN VARCHAR2
                        , P_OBJECT_NAME IN VARCHAR2
                        , P_OBJECT_TYPE IN VARCHAR2
                        ) RETURN           BOOLEAN
  IS
      CURSOR C_OBJ( B_OWNER_NAME  VARCHAR2
                  , B_OBJECT_NAME VARCHAR2
                  , B_OBJECT_TYPE VARCHAR2
                  )
      IS
      SELECT 'x'
      FROM   ALL_OBJECTS AOT
      WHERE  AOT.OWNER        = B_OWNER_NAME
      AND    AOT.OBJECT_NAME  = B_OBJECT_NAME
      AND    AOT.OBJECT_TYPE  = B_OBJECT_TYPE
      ;
      R_OBJ C_OBJ%ROWTYPE;

      V_EXISTS BOOLEAN;
  BEGIN
      OPEN C_OBJ( P_OWNER_NAME
                , UPPER(P_OBJECT_NAME)
                , UPPER(P_OBJECT_TYPE)
                );
      FETCH C_OBJ INTO R_OBJ;
      V_EXISTS := C_OBJ%FOUND;
      CLOSE C_OBJ;
      RETURN V_EXISTS;

  EXCEPTION
     WHEN OTHERS
     THEN
        IF C_OBJ%ISOPEN
        THEN
           CLOSE C_OBJ;
        END IF;
        RAISE;
  END EXISTS_OBJECT;

  FUNCTION EXISTS_OBJECT( P_OBJECT_NAME IN VARCHAR2
                        , P_OBJECT_TYPE IN VARCHAR2
                        ) RETURN           BOOLEAN
  is
  BEGIN
     RETURN EXISTS_OBJECT( P_OWNER_NAME  => GET_CURRENT_SCHEMA
                         , P_OBJECT_NAME => P_OBJECT_NAME
                         , P_OBJECT_TYPE => P_OBJECT_TYPE
                         );
  END EXISTS_OBJECT;

  FUNCTION EXISTS_COLUMN( P_OWNER_NAME IN VARCHAR2
                        , P_TABLE_NAME IN VARCHAR2
                        , P_COLUMN_NAME IN VARCHAR2
                        , P_COLUMN_TYPE IN VARCHAR2 DEFAULT NULL
                        , P_CHAR_LENGTH IN VARCHAR2 DEFAULT NULL
                        , P_NULLABLE    IN VARCHAR2 DEFAULT NULL
                        ) RETURN           BOOLEAN
  IS
     CURSOR C_COL( B_OWNER_NAME  VARCHAR2
                 , B_TABLE_NAME  VARCHAR2
                 , B_COLUMN_NAME VARCHAR2
                 , B_COLUMN_TYPE VARCHAR2
                 , B_CHAR_LENGTH VARCHAR2
                 , B_NULLABLE    VARCHAR2
                 )
     IS
     SELECT 'x'
     FROM   ALL_TAB_COLUMNS A
     WHERE  A.OWNER       = B_OWNER_NAME
     AND    A.TABLE_NAME  = B_TABLE_NAME
     AND    A.COLUMN_NAME = B_COLUMN_NAME
     AND    A.DATA_TYPE   = NVL(B_COLUMN_TYPE, A.DATA_TYPE)
     AND    A.CHAR_LENGTH = NVL(B_CHAR_LENGTH, A.CHAR_LENGTH)
     AND    A.NULLABLE    = NVL(B_NULLABLE, A.NULLABLE)
     ;
     R_COL C_COL%ROWTYPE;

     V_EXISTS BOOLEAN;
  BEGIN
      OPEN C_COL( UPPER(P_OWNER_NAME)
                , UPPER(P_TABLE_NAME)
                , UPPER(P_COLUMN_NAME)
                , UPPER(P_COLUMN_TYPE)
                , UPPER(P_CHAR_LENGTH)
                , UPPER(P_NULLABLE)
                );
      FETCH C_COL INTO R_COL;
      V_EXISTS := C_COL%FOUND;
      CLOSE C_COL;
      RETURN V_EXISTS;

  EXCEPTION
     WHEN OTHERS
     THEN
        IF C_COL%ISOPEN
        THEN
           CLOSE C_COL;
        END IF;
        RAISE;
  END EXISTS_COLUMN;

  FUNCTION EXISTS_COLUMN( P_TABLE_NAME IN VARCHAR2
                        , P_COLUMN_NAME IN VARCHAR2
                        , P_COLUMN_TYPE IN VARCHAR2 DEFAULT NULL
                        , P_CHAR_LENGTH IN VARCHAR2 DEFAULT NULL
                        , P_NULLABLE    IN VARCHAR2 DEFAULT NULL
                        ) RETURN           BOOLEAN
  IS
  BEGIN
    RETURN EXISTS_COLUMN( P_OWNER_NAME  => GET_CURRENT_SCHEMA
                        , P_TABLE_NAME  => P_TABLE_NAME
                        , P_COLUMN_NAME => P_COLUMN_NAME
                        , P_COLUMN_TYPE => P_COLUMN_TYPE
                        , P_CHAR_LENGTH => P_CHAR_LENGTH
                        , P_NULLABLE    => P_NULLABLE
                        );
  END EXISTS_COLUMN;

  /*********************************************************
   * Function to check if a sequence with given name exists
   *********************************************************/
  FUNCTION EXISTS_SEQUENCE( P_OWNER_NAME  IN VARCHAR2
                          , P_SEQUENCE_NAME IN VARCHAR2
                          ) RETURN             BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OWNER_NAME  => P_OWNER_NAME
                         , P_OBJECT_NAME => P_SEQUENCE_NAME
                         , P_OBJECT_TYPE => 'SEQUENCE'
                         );
  END EXISTS_SEQUENCE;

  /*********************************************************
   * Function to check if a table with given name exists
   *********************************************************/
  FUNCTION EXISTS_TABLE( P_OWNER_NAME  IN VARCHAR2
                       , P_TABLE_NAME IN VARCHAR2
                       ) RETURN          BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OWNER_NAME  => P_OWNER_NAME
                         , P_OBJECT_NAME => P_TABLE_NAME
                         , P_OBJECT_TYPE => 'TABLE'
                         );
  END EXISTS_TABLE;

  /*********************************************************
   * Function to check if a trigger with given name exists
   *********************************************************/
  FUNCTION EXISTS_TRIGGER( P_OWNER_NAME  IN VARCHAR2
                         , P_TRIGGER_NAME IN VARCHAR2
                         ) RETURN            BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OWNER_NAME  => P_OWNER_NAME
                         , P_OBJECT_NAME => P_TRIGGER_NAME
                         , P_OBJECT_TYPE => 'TRIGGER'
                         );
  END EXISTS_TRIGGER;

  /*********************************************************
   * Function to check if an index with given name exists
   *********************************************************/
  FUNCTION EXISTS_INDEX( P_OWNER_NAME  IN VARCHAR2
                       , P_INDEX_NAME IN VARCHAR2
                       ) RETURN          BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OWNER_NAME  => P_OWNER_NAME
                         , P_OBJECT_NAME => P_INDEX_NAME
                         , P_OBJECT_TYPE => 'INDEX'
                         );
  END EXISTS_INDEX;

  /*********************************************************
   * Function to check if a type with given name exists
   *********************************************************/
  FUNCTION EXISTS_TYPE( P_OWNER_NAME  IN VARCHAR2
                      , P_TYPE_NAME    IN VARCHAR2
                      ) RETURN            BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OWNER_NAME  => P_OWNER_NAME
                         , P_OBJECT_NAME => P_TYPE_NAME
                         , P_OBJECT_TYPE => 'TYPE'
                         );
  END EXISTS_TYPE;

  /*********************************************************
   * Function to retrieve the maximum ID used thus far in a
   * table
   *********************************************************/
  FUNCTION GET_TABLE_MAX_ID( P_OWNER_NAME IN VARCHAR2
                           , P_TABLE_NAME IN VARCHAR2
                           ) RETURN          NUMBER
  IS
     V_MAX_ID NUMBER(10,0);
  BEGIN
     IF P_TABLE_NAME IS NOT NULL
     AND EXISTS_TABLE( P_OWNER_NAME
                     , P_TABLE_NAME
                     )
     THEN
        EXECUTE IMMEDIATE 'select max(ID) from ' || P_OWNER_NAME || '.' || P_TABLE_NAME
        INTO V_MAX_ID
        ;
     END IF;

     RETURN NVL(V_MAX_ID, 0);
   END GET_TABLE_MAX_ID;

  /*********************************************************
   * Function to check if a constraint with given name exists
   *********************************************************/
  FUNCTION EXISTS_CONSTRAINT( P_OWNER_NAME      IN VARCHAR2
                            , P_CONSTRAINT_NAME IN VARCHAR2
                            ) RETURN               BOOLEAN
  IS
     cursor c_act( b_owner_name      varchar2
                 , b_constraint_name varchar2
                 )
     is
     select 'x'
     from   ALL_CONSTRAINTS act
     where  act.OWNER = b_owner_name
     and    act.CONSTRAINT_NAME = b_constraint_name
     ;
     r_act c_act%rowtype;
     V_EXISTS BOOLEAN;
  BEGIN
      OPEN c_act( UPPER(P_OWNER_NAME)
                , UPPER(P_CONSTRAINT_NAME)
                );
      FETCH c_act INTO r_act;
      V_EXISTS := c_act%FOUND;
      CLOSE c_act;
      RETURN V_EXISTS;

  EXCEPTION
     WHEN OTHERS
     THEN
        IF c_act%ISOPEN
        THEN
           CLOSE c_act;
        END IF;
        RAISE;
  END EXISTS_CONSTRAINT;

   /*********************************************************
   * Function to check if a sequence with given name exists
   *********************************************************/
  FUNCTION EXISTS_SEQUENCE( P_SEQUENCE_NAME IN VARCHAR2
                          ) RETURN             BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OBJECT_NAME => P_SEQUENCE_NAME
                         , P_OBJECT_TYPE => 'SEQUENCE'
                         );
  END EXISTS_SEQUENCE;

  /*********************************************************
   * Function to check if a table with given name exists
   *********************************************************/
  FUNCTION EXISTS_TABLE( P_TABLE_NAME IN VARCHAR2
                       ) RETURN          BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OBJECT_NAME => P_TABLE_NAME
                         , P_OBJECT_TYPE => 'TABLE'
                         );
  END EXISTS_TABLE;

  /*********************************************************
   * Function to check if a trigger with given name exists
   *********************************************************/
  FUNCTION EXISTS_TRIGGER( P_TRIGGER_NAME IN VARCHAR2
                         ) RETURN            BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OBJECT_NAME => P_TRIGGER_NAME
                         , P_OBJECT_TYPE => 'TRIGGER'
                         );
  END EXISTS_TRIGGER;

  /*********************************************************
   * Function to check if an index with given name exists
   *********************************************************/
  FUNCTION EXISTS_INDEX( P_INDEX_NAME IN VARCHAR2
                       ) RETURN          BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OBJECT_NAME => P_INDEX_NAME
                         , P_OBJECT_TYPE => 'INDEX'
                         );
  END EXISTS_INDEX;

  /*********************************************************
   * Function to check if a type with given name exists
   *********************************************************/
  FUNCTION EXISTS_TYPE( P_TYPE_NAME    IN VARCHAR2
                      ) RETURN            BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_OBJECT( P_OBJECT_NAME => P_TYPE_NAME
                         , P_OBJECT_TYPE => 'TYPE'
                         );
  END EXISTS_TYPE;

  /*********************************************************
   * Function to check if a constraint with given name exists
   *********************************************************/
  FUNCTION EXISTS_CONSTRAINT( P_CONSTRAINT_NAME IN VARCHAR2
                            ) RETURN               BOOLEAN
  IS
  BEGIN
     RETURN EXISTS_CONSTRAINT( P_OWNER_NAME      => GET_CURRENT_SCHEMA
                             , P_CONSTRAINT_NAME => P_CONSTRAINT_NAME
                             );
  END EXISTS_CONSTRAINT;

  /*********************************************************
   * Function to retrieve the maximum ID used thus far in a
   * table
   *********************************************************/
  FUNCTION GET_TABLE_MAX_ID( P_TABLE_NAME IN VARCHAR2
                           ) RETURN          NUMBER
  IS
  BEGIN
     RETURN GET_TABLE_MAX_ID( P_OWNER_NAME => GET_CURRENT_SCHEMA
                            , P_TABLE_NAME => P_TABLE_NAME
                            );
   END GET_TABLE_MAX_ID;
   
   
  /*********************************************************
   * Procedure that finds all invalid packages in the current 
   * schema and tries to recompile them.
   *********************************************************/
   PROCEDURE COMPILE_INVALID_OBJECTS
   IS
   
      CURSOR C_OBJ(B_OWNER_NAME VARCHAR2)
      IS
      SELECT AOT.OWNER
      ,      AOT.OBJECT_NAME
      ,      AOT.OBJECT_TYPE
      ,      DECODE( AOT.OBJECT_TYPE, 'TYPE'         , 1
                                    , 'PACKAGE'      , 2
                                    , 'VIEW'         , 3
                                    , 'TYPE BODY'    , 4
                                    , 'PACKAGE BODY' , 5
                                    , 'TRIGGER'      , 6
                                    , 'SYNONYM'      , 7
                                                     , 99
                       ) AS RECOMPILE_ORDER
      FROM   ALL_OBJECTS AOT
      WHERE  AOT.OWNER = B_OWNER_NAME
      AND    AOT.OBJECT_NAME != 'ZMS_SYS_TOOLS'
      AND    AOT.OBJECT_TYPE IN ('PACKAGE', 'PACKAGE BODY', 'TRIGGER', 'TYPE', 'TYPE BODY', 'VIEW', 'SYNONYM')
      AND    AOT.STATUS != 'VALID'
      ORDER 
      BY     RECOMPILE_ORDER
      ;
      R_OBJ C_OBJ%ROWTYPE;

      V_OWNER VARCHAR2(30 CHAR);
      V_HAS_COMPILED BOOLEAN := FALSE;
   BEGIN
      V_OWNER := GET_CURRENT_SCHEMA;
      DBMS_OUTPUT.PUT_LINE('Recompile invalid objects for owner ['||V_OWNER||']');
      FOR R_OBJ IN C_OBJ(V_OWNER)
      LOOP
         BEGIN
            V_HAS_COMPILED := TRUE;
--            DBMS_OUTPUT.PUT('   Recompiling '||R_OBJ.OBJECT_TYPE || ' ' || R_OBJ.OWNER || '.' || R_OBJ.OBJECT_NAME||'...');
            IF R_OBJ.OBJECT_TYPE like '% BODY'
            THEN
               DBMS_OUTPUT.PUT('   ALTER '||SUBSTR(R_OBJ.OBJECT_TYPE, 1, INSTR(R_OBJ.OBJECT_TYPE,' BODY', -1, 1)-1)||' '||R_OBJ.OWNER||'.'||R_OBJ.OBJECT_NAME||' COMPILE BODY');
               EXECUTE IMMEDIATE 'ALTER '||SUBSTR(R_OBJ.OBJECT_TYPE, 1, INSTR(R_OBJ.OBJECT_TYPE,' BODY', -1, 1)-1)||' '||R_OBJ.OWNER||'.'||R_OBJ.OBJECT_NAME||' COMPILE BODY';
            ELSE
               DBMS_OUTPUT.PUT('   ALTER '||R_OBJ.OBJECT_TYPE||' '||R_OBJ.OWNER||'.'||R_OBJ.OBJECT_NAME||' COMPILE');
               EXECUTE IMMEDIATE 'ALTER '||R_OBJ.OBJECT_TYPE||' '||R_OBJ.OWNER||'.'||R_OBJ.OBJECT_NAME||' COMPILE';
            END IF;
            DBMS_OUTPUT.PUT_LINE(' => success');
         EXCEPTION
            WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(' => FAILED, reason: '||SQLERRM);
               raise;
         END;
      END LOOP;
      IF NOT V_HAS_COMPILED
      THEN
        DBMS_OUTPUT.PUT_LINE('No objects recompiled, all is valid');
      END IF;
   END COMPILE_INVALID_OBJECTS;
   
END SYS_TOOLS;
/
