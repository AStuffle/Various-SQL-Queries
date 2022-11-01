SELECT	[MinorCapBudget].[dbo].[tbl_MinorCapital].[ID],
		[MinorCapBudget].[dbo].[tbl_MinorCapital].[AssetDesc],
		[MinorCapBudget].[dbo].[tbl_MinorCapital].[makeready],
		CAST (value AS int) AS MakeReadyValue,
		[MinorCapBudget].[dbo].[tbl_MakeReady].[Description],
		CAST ([MinorCapBudget].[dbo].[tbl_MakeReady].Amount AS int) as MakeReadyCost
FROM [MinorCapBudget].[dbo].[tbl_MinorCapital]
CROSS APPLY [MinorCapBudget].[dbo].[Split](MakeReady,',')
LEFT JOIN	[MinorCapBudget].[dbo].[tbl_MakeReady]
	ON		[MinorCapBudget].[dbo].[tbl_MakeReady].[ID] = value
WHERE FY IN ('FY24','FY25')
AND MakeReady IS NOT NULL
AND MakeReady !=''
AND Description IS NOT NULL
AND Amount IS NOT NULL
