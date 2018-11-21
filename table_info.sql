SELECT pg.relname table_name, t_comm.description table_comm
  FROM PG_STAT_USER_TABLES pg
left join(
SELECT PS.RELNAME    AS TABLE_NAME
      ,PD.*
  FROM PG_STAT_USER_TABLES PS
      ,PG_DESCRIPTION      PD
 WHERE PS.RELID   = PD.OBJOID
   AND PD.OBJSUBID  = 0
) t_comm
on t_comm.table_name = pg.relname
where schemaname = 'public'
order by RELNAME;