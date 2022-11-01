SELECT 
  SUBSTR(A.PROJECT_ID,0,5) as AssetNumber, 
  A.PROJECT_ID as ProjectID, 
  A.DESCR as ProjectName, 
  A.EFF_STATUS as EffStatus,
  B.ACTIVITY_ID as ActivityID, 
  B.BUSINESS_UNIT_GL as GLUnit, 
  B.ACCOUNT as Account, 
  B.DEPTID as Dept, 
  B.OPERATING_UNIT as OperUnit, 
  B.PRODUCT as Product, 
  B.CHARTFIELD1 as Chartfield1, 
  B.JOURNAL_ID as JournalID, 
  B.JOURNAL_DATE as JournalDate, 
  B.JOURNAL_LINE as JournalLineNumber, 
  B.FISCAL_YEAR as FiscalYear, 
  B.ACCOUNTING_PERIOD as Period, 
  B.ANALYSIS_TYPE as AnalysisType, 
  B.RESOURCE_TYPE as SourceType, 
  B.DESCR as SourceDescription, 
  B.EMPLID as EmpID, 
  D.NAME as EmployeeName,
  B.JOBCODE as JobCode,
  F.DESCR as JobTitle,
  B.TIME_RPTG_CD as TimeRptgCode, 
  B.BUSINESS_UNIT_AP as APBusUnit, 
  B.VENDOR_ID as SupplierID,
  C.NAME1 as SupplierName,
  B.VOUCHER_ID as Voucher, 
  B.VOUCHER_LINE_NUM as VoucherLine, 
  G.DESCR as LineDescription,
  G.DESCR254_MIXED as LineDescriptionLong,
  B.PO_ID as PONumber, 
  B.LINE_NBR as POLine, 
  B.INV_ITEM_ID as ItemNumber,
  E.DESCR60 as ItemDescription,
  TO_CHAR(H.COMMENTS) as ProcardComments,
  B.RESOURCE_QUANTITY as Quantity, 
  B.UNIT_OF_MEASURE as UOM,
  B.SEQ_NBR, 
  B.RESOURCE_AMOUNT as Amount,
  J.SPEEDCHART_KEY

FROM 
PS_PROJECT A,
PS_PROJ_RESOURCE B 
left join PS_VENDOR C on b.vendor_ID = C.vendor_ID
left join ps_personal_data D on b.emplID = d.emplid
left join PS_master_item_tbl E on b.inv_item_id = e.inv_item_id
left join ps_jobcode_tbl F on b.jobcode = f.jobcode
left join ps_voucher_line G on b.voucher_id = g.voucher_id AND b.voucher_line_num = g.voucher_line_num
left join ps_lcra_prld_cmnts H on g.descr = h.descr
left join ps_voucher_line J on b.business_unit = j.business_unit AND b.voucher_id = j.voucher_id AND b.voucher_line_num = j.voucher_line_num
  WHERE (A.PROJECT_TYPE = 'OMFLT'
  AND A.BUSINESS_UNIT = B.BUSINESS_UNIT
     AND A.PROJECT_ID = B.PROJECT_ID
     AND B.ANALYSIS_TYPE IN ('ACT','PAY','GLE','BUR')
     AND ( F.EFFDT =
        (SELECT MAX(C_ED.EFFDT) FROM PS_JOBCODE_TBL C_ED
        WHERE F.SETID = C_ED.SETID
          AND F.JOBCODE = C_ED.JOBCODE
          AND C_ED.EFFDT <= SYSDATE)
     OR F.EFFDT IS NULL))
Order By a.project_id, b.activity_id
