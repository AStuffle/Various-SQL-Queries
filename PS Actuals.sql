SELECT B.LEDGER as "Ledger", 
A.JOURNAL_ID as "Journal ID", 
A.JRNL_HDR_STATUS as "Status", 
A.DESCR as "Jrnl Header Descr", 
A.FISCAL_YEAR as "Year", 
A.ACCOUNTING_PERIOD as "Period", 
A.JOURNAL_DATE as "Jrnl Date", 
B.JOURNAL_LINE as "Line Number", 
B.LINE_DESCR as "Jrnal Line Descr", 

case when  A.BUSINESS_UNIT in ('AUSEN','1LCRA') and  B.OPERATING_UNIT like '11002%' then 'Y' else 'N' end as "FPP Flag", 
A.BUSINESS_UNIT as "GL Bus Unit", case substr( B.ACCOUNT,1,2)
when '10' then '100000 - CWIP/RWIP'
when '49' then '490000 - Other Revenues'
when '61' then '610000 - Labor'
when '62' then '620000 - Materials'
when '63' then '630000 - Transportation'
when '64' then '640000 - Outside Services'
when '67' then '670000 - Lease/Rental Expense'
when '68' then '680000 - Soft/Hardware License or Maint'
when '69' then '690000 - Employee Expense'
when '70' then '700000 - Benefits, Insurance &Damages'
when '71' then '710000 - Utilities'
when '72' then '720000 - Recruiting Expenses'
when '73' then '730000 - Other Expenses'
when '79' then '790000 - Misc Expenses'
else 'Unknown' end as "Summary Account", 
B.ACCOUNT as "Account", 
G.DESCR as "Account Name", 
B.DEPTID as "Dept", 
B.OPERATING_UNIT as "Oper Unit", 
P.DESCR as "Oper Unit Name", 
B.PRODUCT as "Product", 
O.DESCR as "Product Name", 
B.CHARTFIELD1 as "Chartfield 1", 
S.DESCR as "ChartfieldDesc", 
B.PROJECT_ID as "Project", 
N.DESCR as "Project Name", 
N.PROJECT_TYPE as "Proj Type",
 B.ACTIVITY_ID as "Activity", 
B.RESOURCE_TYPE as "Source Type", 
TO_CHAR(CAST((A.DTTM_STAMP_SEC) AS TIMESTAMP),'YYYY-MM-DD-HH24.MI.SS.FF') as "DateTime", 
A.OPRID as "User",
 A.REVERSAL_CD as "Reversal", 
C.BUSINESS_UNIT as "AP Bus Unit", 
C.VOUCHER_ID as "Voucher ID", 
C.VOUCHER_LINE_NUM as "Vchr Line Number",
 C.DESCR as "Vchr Line Descr", 
D.DESCR254_MIXED as "Vchr Line More Descr", 
D.SPEEDCHART_KEY as "SpeedChart", 
D.PO_ID as "PO No.", 
D.LINE_NBR as "PO Line", 
E.INVOICE_ID as "Invoice Number", 
TO_CHAR(E.INVOICE_DT,'YYYY-MM-DD') as "Invoice Date", 
E.VENDOR_ID as "Supplier ID", F.NAME1 as "Supplier Name", 
TO_CHAR( L.COMMENTS) as "Procard Comment", 
case when  A.JOURNAL_ID like 'AP%'  then  C.MONETARY_AMOUNT else  B.MONETARY_AMOUNT end as "Amount"
  
FROM PS_JRNL_HEADER A, PS_JRNL_LN B, PS_VCHR_ACCTG_LINE C, PS_VOUCHER_LINE D, PS_VOUCHER E, PS_VENDOR F, PS_GL_ACCOUNT_TBL G, PS_LCRA_PRLD_CMNTS L, PS_PROJECT N, PS_PRODUCT_TBL O, PS_OPER_UNIT_TBL P, PS_CHARTFIELD1_TBL S
  WHERE ( A.BUSINESS_UNIT = B.BUSINESS_UNIT
     AND A.JOURNAL_ID = B.JOURNAL_ID
     AND A.JOURNAL_DATE = B.JOURNAL_DATE
     AND B.LEDGER = 'ACTUALS'
     AND A.FISCAL_YEAR >= '2019'
     AND B.DEPTID IN ('FFB','PMX','FF1')
     AND B.MONETARY_AMOUNT <> 0
	AND A.ACCOUNTING_PERIOD NOT LIKE '999%'
     AND A.BUSINESS_UNIT NOT IN ('ELIM1','ELIM2','ELIM3','ELIM4','ELIM5')
     AND B.OPERATING_UNIT NOT IN ('1400185','1400250','1400243','1600277','1900000','1100249','1900001','1900002','1900003')
     AND B.PRODUCT NOT BETWEEN '999990' AND '999997'
     AND B.ACCOUNT NOT IN ('731001','738889','799999','739999','731004','610101','610102','610103','610104','620002','630002','730023','730028','730038','490006','493001','493004','400005','690003')
     AND B.ACCOUNT NOT LIKE '165%'
     AND B.ACCOUNT NOT LIKE '18%'
     AND B.ACCOUNT NOT LIKE '65%'
     AND B.ACCOUNT NOT LIKE '66%'
     AND B.ACCOUNT NOT LIKE '75%'
     AND B.ACCOUNT NOT LIKE '76%'
     AND B.ACCOUNT NOT LIKE '101%'
     AND B.ACCOUNT NOT LIKE '107%'
     AND B.ACCOUNT NOT LIKE '108%'
     AND B.BUSINESS_UNIT =  C.BUSINESS_UNIT_GL (+)
     AND B.JOURNAL_ID =  C.JOURNAL_ID (+)
     AND B.JOURNAL_LINE =  C.JOURNAL_LINE (+)
     AND C.BUSINESS_UNIT =  D.BUSINESS_UNIT (+)
     AND C.VOUCHER_ID =  D.VOUCHER_ID (+)
     AND C.VOUCHER_LINE_NUM =  D.VOUCHER_LINE_NUM (+)
     AND D.BUSINESS_UNIT =  E.BUSINESS_UNIT (+)
     AND D.VOUCHER_ID =  E.VOUCHER_ID (+)
     AND E.VENDOR_ID =  F.VENDOR_ID (+)
     AND A.JRNL_HDR_STATUS IN ('P','U')
     AND G.ACCOUNT = B.ACCOUNT
     AND G.EFFDT =
        (SELECT MAX(G_ED.EFFDT) FROM PS_GL_ACCOUNT_TBL G_ED
        WHERE G.SETID = G_ED.SETID
          AND G.ACCOUNT = G_ED.ACCOUNT
          AND G_ED.EFFDT <= SYSDATE)
     AND G.ACCOUNT_TYPE IN ('A','E','R')
     AND A.DESCR NOT LIKE '100% LCRA Share of FPP%'
     AND A.JOURNAL_ID NOT LIKE 'FPP%'
     AND A.JOURNAL_ID NOT LIKE 'AE%'
     AND D.DESCR =  L.DESCR (+)
     AND B.PROJECT_ID =  N.PROJECT_ID (+)
     AND ( N.PROJECT_TYPE LIKE 'OM%'
     OR N.PROJECT_TYPE IS NULL)
     AND case when  A.BUSINESS_UNIT in ('AUSEN','1LCRA') and  B.OPERATING_UNIT like '11002%' then 'Y' else 'N' end = 'N'
     AND B.PRODUCT =  O.PRODUCT (+)
     AND B.OPERATING_UNIT =  P.OPERATING_UNIT (+)
     AND B.CHARTFIELD1 =  S.CHARTFIELD1 (+)
     AND ( S.EFFDT =
        (SELECT MAX(S_ED.EFFDT) FROM PS_CHARTFIELD1_TBL S_ED
        WHERE S.SETID = S_ED.SETID
          AND S.CHARTFIELD1 = S_ED.CHARTFIELD1
          AND S_ED.EFFDT <= SYSDATE)
     OR S.CHARTFIELD1 IS NULL))

UNION

SELECT
I.LEDGER,
H.JOURNAL_ID,
H.JRNL_HDR_STATUS,
H.DESCR, H.FISCAL_YEAR,
H.ACCOUNTING_PERIOD,
H.JOURNAL_DATE,
I.JOURNAL_LINE,
I.LINE_DESCR, case when 
I.BUSINESS_UNIT in ('AUSEN','1LCRA') and  I.OPERATING_UNIT like '11002%' then 'Y' else 'N' end,
H.BUSINESS_UNIT, case substr( I.ACCOUNT,1,2)
  when '10' then '100000 - CWIP/RWIP'
  when '49' then '490000 - Other Revenues'
  when '61' then '610000 - Labor'
  when '62' then '620000 - Materials'
  when '63' then '630000 - Transportation'
  when '64' then '640000 - Outside Services'
  when '67' then '670000 - Lease/Rental Expense'
  when '68' then '680000 - Soft/Hardware License or Maint'
  when '69' then '690000 - Employee Expense'
  when '70' then '700000 - Benefits, Insurance &Damages'
  when '71' then '710000 - Utilities'
  when '72' then '720000 - Recruiting Expenses'
  when '73' then '730000 - Other Expenses'
  when '79' then '790000 - Misc Expenses'
else 'Unknown' end, I.ACCOUNT, J.DESCR, I.DEPTID, I.OPERATING_UNIT, Q.DESCR, I.PRODUCT, R.DESCR, I.CHARTFIELD1, T.DESCR, I.PROJECT_ID, K.DESCR, K.PROJECT_TYPE, I.ACTIVITY_ID, I.RESOURCE_TYPE, TO_CHAR(CAST((H.DTTM_STAMP_SEC) AS TIMESTAMP),'YYYY-MM-DD-HH24.MI.SS.FF'), H.OPRID, H.REVERSAL_CD, ' ', ' ', 0, ' ', ' ', ' ', ' ', 0, ' ', ' ', ' ', ' ', TO_CHAR( M.COMMENTS), I.MONETARY_AMOUNT
  FROM PS_JRNL_HEADER H, PS_JRNL_LN I, PS_GL_ACCOUNT_TBL J, PS_PROJECT K, PS_LCRA_PRLD_CMNTS M, PS_OPER_UNIT_TBL Q, PS_PRODUCT_TBL R, PS_CHARTFIELD1_TBL T
  WHERE ( H.BUSINESS_UNIT = I.BUSINESS_UNIT
     AND H.JOURNAL_ID = I.JOURNAL_ID
     AND H.JOURNAL_DATE = I.JOURNAL_DATE
     AND J.ACCOUNT = I.ACCOUNT
     AND J.EFFDT =
        (SELECT MAX(J_ED.EFFDT) FROM PS_GL_ACCOUNT_TBL J_ED
        WHERE J.SETID = J_ED.SETID
          AND J.ACCOUNT = J_ED.ACCOUNT
          AND J_ED.EFFDT <= SYSDATE)
    AND I.LEDGER = 'ACTUALS'
    AND I.MONETARY_AMOUNT <> 0
    AND H.ACCOUNTING_PERIOD NOT LIKE '999%'
    AND H.JRNL_HDR_STATUS IN ('P','U')
    AND H.FISCAL_YEAR >= '2019'
    AND I.DEPTID IN ('FFB','PMX','FF1')
    AND H.DESCR NOT LIKE '100% LCRA Share of FPP%'
    AND H.JOURNAL_ID NOT LIKE 'FPP%'
    AND H.JOURNAL_ID NOT LIKE 'AE%'
    AND H.JOURNAL_ID <> '0000156145'
    AND ( I.RESOURCE_TYPE = 'LABOR'
    OR I.ACCOUNT LIKE '6100%')
    AND K.PROJECT_ID = I.PROJECT_ID
    AND K.PROJECT_TYPE LIKE 'CP%'
    AND I.ANALYSIS_TYPE <> 'BUR'
    AND I.LINE_DESCR =  M.DESCR (+)
    AND case when  I.BUSINESS_UNIT in ('AUSEN','1LCRA') and  I.OPERATING_UNIT like '11002%' then 'Y' else 'N' end = 'N'
    AND I.OPERATING_UNIT =  Q.OPERATING_UNIT (+)
    AND I.PRODUCT =  R.PRODUCT (+)
    AND I.CHARTFIELD1 =  T.CHARTFIELD1  (+)
    AND ( T.EFFDT =
        (SELECT MAX(T_ED.EFFDT) FROM PS_CHARTFIELD1_TBL T_ED
        WHERE T.SETID = T_ED.SETID
          AND T.CHARTFIELD1 = T_ED.CHARTFIELD1
          AND T_ED.EFFDT <= SYSDATE)
     OR T.EFFDT IS NULL))
  ORDER BY 2, 8, 31, 32
