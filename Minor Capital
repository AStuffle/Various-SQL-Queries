select 
a.ID as 'MinorCapRequestID',
a.TransactionType as 'TransactionType',
a.OldAssetNum as 'OldAssetNumber',
a.AssetDesc as 'NewAssetDescription',
a.Quantity as 'NewAssetQuantity',
a.EstPrice as 'EstimatedCost',
a.MakeReadyCost as 'MakeReadyCost',
a.MakeReadyComments as 'MakeReadyComments',
a.DepartmentID as 'Department',
a.Justification as 'Justification',
a.FTFComments as 'FleetTaskForceComments',
a.FY as 'FiscalYear',
a.KeyDept as 'KeyDepartment',
a.Workgroup as 'Workgroup',
a.FleetOpsComments as 'Fleet Comments',
a.MakeReady as 'MakeReadyOptions',
a.AssetType as 'AssetType',
b.description as 'DeptDescription',
a.operatorname as 'MC_Operator',
a.supervisorname as 'MC_Supervisor',
a.FTFReview as 'FTFReview',
c.FTFReview as 'FTFReviewDescription'


from [MinorCapBudget].[dbo].[tbl_MinorCapital] a
left join [MinorCapBudget].[dbo].[tbl_Department] b on a.DepartmentID = b.DepartmentID
left join [MinorCapBudget].[dbo].[tbl_FTFReview] c on a.FTFReview = c.ID
where FY IN ('FY24','FY25')
and AssetType = 'Fleet'
