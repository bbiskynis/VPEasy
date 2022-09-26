SELECT CanServe.UID AS OptimalMember, OrderedList.UID, LastServed FROM
(SELECT Eligible.UID
FROM
(SELECT Scheduler_Attendance.UID
FROM Scheduler_Attendance
WHERE (((Scheduler_Attendance.ClubID)='4570') AND ((Scheduler_Attendance.MeetingID)=379) AND ((Scheduler_Attendance.AttendanceIndicator)=True))) Eligible
LEFT JOIN
(SELECT Scheduler_Roles_Log.UID
FROM Scheduler_Roles_Log
WHERE (((Scheduler_Roles_Log.UID) <> 0) AND ((Scheduler_Roles_Log.MeetingID)=379) AND ((Scheduler_Roles_Log.ClubID)='4570'))
Union
SELECT Scheduler_Roles_Log.UID FROM Scheduler_Roles_Log WHERE (((Scheduler_Roles_Log.UID) <> 0) AND ((Scheduler_Roles_Log.MeetingID)>=375) AND ((Scheduler_Roles_Log.ClubID)='4570') AND ((Scheduler_Roles_Log.Role) LIKE 'Prayer/Thought') AND ((Scheduler_Roles_Log.MeetingID)<380))) NotEligible
ON Eligible.UID=NotEligible.UID
WHERE NotEligible.UID Is Null) CanServe
LEFT JOIN
(Select t.UID, max(t.last) AS LastServed from (SELECT distinct(a.UID), Max(a.MeetingID) as LAST FROM Meeting_Roles_Log a WHERE (((a.ClubID)='4570')) GROUP BY a.UID, a.Role HAVING (((a.Role) LIKE 'Prayer/Thought'))
ORDER BY Max(a.MeetingID) ) as t group by t.UID
order by max(t.last) asc) OrderedList
ON CanServe.UID = OrderedList.UID
ORDER BY LastServed, CanServe.UID