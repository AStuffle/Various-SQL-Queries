SELECT SUBSTR( A.PROJECT_ID,0,5) AS ASSETNUMBER,
A.PROJECT_ID, 
A.DESCR, 
A.EFF_STATUS, 
B.PRJ_LEVEL1_CF_VAL, 
B.PRJ_LEVEL2_CF_VAL, 
B.PRJ_LEVEL3_CF_VAL as FleetOUValue, 
B.PRJ_LEVEL4_CF_VAL, 
B.PRJ_LEVEL5_CF_VAL, 
TO_CHAR(SYSDATE,'YYYY-MM-DD')
  FROM PS_PROJECT A, PS_PSA_ORGPRJ_DEFN B
  WHERE ( A.PROJECT_TYPE = 'OMFLT'
     AND A.BUSINESS_UNIT = B.BUSINESS_UNIT
     AND A.PROJECT_ID = B.PROJECT_ID
     AND B.EFFDT =
        (SELECT MAX(B_ED.EFFDT) FROM PS_PSA_ORGPRJ_DEFN B_ED
        WHERE B.BUSINESS_UNIT = B_ED.BUSINESS_UNIT
          AND B.PROJECT_ID = B_ED.PROJECT_ID
          AND B_ED.EFFDT <= SYSDATE))
  ORDER BY 2
