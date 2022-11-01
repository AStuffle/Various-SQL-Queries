select 
a.personID as MaximoEmpID,
a.status as MaximoEmpStatus,
a.displayname as MaximoEmpName,
a.department as MaximoEmpDept,
a.title as MaximoEmpTitle,
a.supervisor as MaximoSupvID,
a.location as MaximoEmpLocation,
b.crewid as MaximoCrewID,
c.displayname as MaximoSupvName

from person a 
left join labor b on a.personID = b.personID
left join person c on a.supervisor = c.personID
where a.department in ('FKB')


//Exemp/Non-exempt
select
personID as EmpID,
status as EmpStatus,
department as Dept,
Case when employeetype='H' then 'Yes' Else 'No' END as OvertimeEligible
from person
where department in ('FKB')


//Person Group
select
  resppartygroup as PersonGroup_EmployeeID,
  persongroup as Crew

from persongroupteam
where persongroup like 'FLT%'
