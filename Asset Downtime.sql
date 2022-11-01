with paths(classstructureid, path) as
 ( select classstructureid, CLASSIFICATIONID as path from classstructure where parent is null 
 union all select c.classstructureid, p.path || '/' || c.CLASSIFICATIONID as path 
 from classstructure c join paths p on p.classstructureid = c.parent ) -- this part is to pull the classification hierarchy for the workorder
 select W.WONUM, -- Workorder number
 W.STATUS, -- Workorder Status 
 w.reportdate as Workorder_Date, --the date that the workorder was generated
 W.DESCRIPTION AS Description, -- workorder description
 W.CREWID, -- crew id
 W.ASSETNUM, -- asset number
 w.location as Location, --workorder location
 lead.personid as lead, -- workorder lead id 
 lead.displayname as Lead_Name,-- workorder lead full name
c.alnvalue Deptid, -- Aset departmnet id
temp.appr_date, -- The date that workorder put in the appr status
temp.inprg_date, -- The date that workorder put in the inprg status
temp.Started_Date,-- The date that workorder put in the Started status
temp.woreq_date,-- The date that workorder put in the woreq status
temp.wcomp_date,-- The date that workorder put in the wcomp status
temp.comp_date, -- The date that workorder put in the comp status
temp.WSCH_date, -- The date that workorder put in the WSCH status
temp.WMATL_date,-- The date that workorder put in the WMATL status
--parentw.path1 Parent_class, --classification for parent workorder
polclass.alnvalue as Policy_class,  -- Policy class of the asset. this only works for fleet not facilities
VCLASS.alnvalue as Vclass,  -- Class of the asset. this only works for fleet not facilities
w.FAILURECODE FAILURE_CODE, 
w.glaccount GLSTRING,
w.reportedby REPORTEDBY, -- Id of the person who generated the workorder
reportedby.displayname as Reportedby_Name,  -- Full name of the person who generated the workorder
-- below is to calculate the duration it took to complete a workorder it uses different criateria according to the status change
(coalesce(temp.inprg_date ,temp.started_date )) - 
            (coalesce(temp.wcomp_date ,coalesce(temp.comp_date ,sysdate))) as duration, --- change this for fleet
 extract(year from v.installdate) installdate, -- date that the asset was installed
 w.ACTFINISH COMP_DATE, -- the actual finish date of the workorder is available
EXTRACT( YEAR FROM W.REPORTDATE) WO_DATE, -- the year that the workorder is created
   'YEAR ' || to_char(EXTRACT( YEAR FROM W.REPORTDATE) - extract(year from v.installdate)) AS YEAR,
   p.path as Classification
 from workorder w
 left join person lead on w.lead = lead.personid
 left join maximo.person reportedby on w.lead = reportedby.personid
 left join asset v on w.assetnum = v.assetnum 
left join paths p on p.classstructureid = w.classstructureid 
-- the hoins below is to pull the departmnet id and policy calss of assets 
LEFT JOIN  MAXIMO.ASSETSPEC C ON v.ASSETNUM = C.ASSETNUM AND C.ASSETATTRID= 'CENTER'
LEFT JOIN  MAXIMO.ASSETSPEC Polclass ON v.ASSETNUM = Polclass.ASSETNUM AND Polclass.ASSETATTRID= 'POLCLASS'
LEFT JOIN MAXIMO.ASSETSPEC VCLASS ON V.ASSETNUM = VCLASS.ASSETNUM AND VCLASS.ASSETATTRID = 'CLASS'
--below is to pull the latest status date since there are multiple of the same status
-- this is one of the ugly part of the query
LEFT JOIN( SELECT W1.wonum,
            max(APPR.CHANGEDATE)  as appr_date,
            max(INPRG.CHANGEDATE)  as inprg_date,
            max(started.CHANGEDATE)  Started_Date,
            max(woreq.CHANGEDATE)  woreq_date,
            max(wcomp.CHANGEDATE)  wcomp_date,
            max(comp.CHANGEDATE)  as comp_date,
            max(WSCH.changedate) as WSCH_date,
            max(WMATL.changedate) as WMATL_date,
            max(CLOSED.changedate) as CLOSED_Date
            from workorder w1 
            left join wostatus appr on w1.wonum = appr.wonum and appr.status = 'APPR'
            left join wostatus INPRG on w1.wonum = INPRG.wonum and INPRG.status = 'INPRG'
            left join wostatus started on w1.wonum = started.wonum and started.status = 'STARTED'
            left join wostatus WOREQ on w1.wonum = WOREQ.wonum and WOREQ.status = 'WOREQ'
            left join wostatus WCOMP on w1.wonum = WCOMP.wonum and WCOMP.status = 'WCOMP'
            left join wostatus COMP on w1.wonum = COMP.wonum and COMP.status = 'COMP'
            left join wostatus WSCH on w1.wonum = WSCH.wonum and WSCH.status = 'WSCHED'
            left join wostatus WMATL on w1.wonum = WMATL.wonum and WMATL.status = 'WMATL'
            left join wostatus CLOSED on w1.wonum = CLOSED.wonum and CLOSED.status = 'CLOSE'
            group by w1.wonum) temp on w.wonum = temp.wonum

where w.crewid like 'CF%' and---V.ASSETTYPE = 'FLEET' -- remove this for facilities for facilities we use the 'CF%'
 EXTRACT( YEAR FROM W.REPORTDATE) in (2014,2015,2016,2017,2018)
