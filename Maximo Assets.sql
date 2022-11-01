select 


A.AssetNum,
sp.ALNVALUE Department ,
a.Description AssetDesc,
a.Location ,
a.Parent,
a.installdate,
a.status,
s14.ALNVALUE Licensenum,
a.purchaseprice,
l.description LocationDesc,
l.glaccount,
s.ALNVALUE Class ,
s2.ALNVALUE PolicyClass ,
s3.ALNVALUE OperatorName ,
s4.ALNVALUE SupervisorName ,
s13.ALNVALUE Dept,
m.LASTREADING ,
m.LASTREADINGDATE ,
m.LASTREADINGINSPCTR  ,
m2.LASTREADING as RunTime,
m2.LASTREADINGDATE as RuntimeDate,
m2.LASTREADINGINSPCTR as RunTimeReadingInspct,
s5.ALNVALUE UsageType ,
S6.ALNVALUE FuelType, 
S7.ALNVALUE YearModel,
S8.ALNVALUE Manufacturer,
S9.ALNVALUE Model,
S10.ALNVALUE CabType,
S11.ALNVALUE ManufactureDate,
S12.NUMVALUE GrossVehicleWeightRating

from Asset a 
left join Locations l on 
l.Location = a.Location 
left join ASSETSPEC s on s.AssetNum = a.AssetNum and s.ASSETATTRID ='CLASS' 
left join ASSETSPEC s2 on s2.AssetNum = a.AssetNum and s2.ASSETATTRID ='POLCLASS' 
left join ASSETSPEC s3 on s3.AssetNum = a.AssetNum and s3.ASSETATTRID ='DRIVER' 
left join ASSETSPEC s4 on s4.AssetNum = a.AssetNum and s4.ASSETATTRID ='MANAGER' 
left join ASSETSPEC s13 on s13.AssetNum = a.AssetNum and s13.ASSETATTRID ='CENTER' 
left join ASSETMETER m on m.AssetNum = a.AssetNum and m.METERNAME ='METER' 
left join ASSETMETER m2 on m2.AssetNum = a.AssetNum and m2.METERNAME ='RUNTIME'
left join ASSETSPEC s5 on s5.AssetNum = a.AssetNum and s5.ASSETATTRID ='USETYPE'
left join ASSETSPEC s6 on s6.AssetNum = a.AssetNum and s6.ASSETATTRID = 'FUEL' 
left join ASSETSPEC sp on sp.AssetNum = a.AssetNum and sp.ASSETATTRID = 'CENTER' 
left join ASSETSPEC s7 on s7.AssetNum = a.AssetNum and s7.ASSETATTRID ='YEARMOD' 
left join ASSETSPEC s8 on s8.AssetNum = a.AssetNum and s8.ASSETATTRID ='MANUFACT'
left join ASSETSPEC s9 on s9.AssetNum = a.AssetNum and s9.ASSETATTRID ='MODEL'
left join ASSETSPEC s10 on s10.AssetNum = a.AssetNum and s10.ASSETATTRID ='CABTYPE'
left join ASSETSPEC s11 on s11.AssetNum = a.AssetNum and s11.ASSETATTRID ='MANFDATE'
left join ASSETSPEC s12 on s12.AssetNum = a.AssetNum and s12.ASSETATTRID ='GVWR'
left join ASSETSPEC s14 on s14.AssetNum = a.AssetNum and s14.ASSETATTRID ='LICENSE'
where a.ASSETTYPE = 'FLEET' and a.status = 'OPERATING' 
order by sp.ALNVALUE ,s4.ALNVALUE ,s2.ALNVALUE
