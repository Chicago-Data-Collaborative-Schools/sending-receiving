create table school as
select id, name, gradecat, min(network) as network, governance from (
select ATTSCH_ID as id,
       ATTSCH_NAME as name,
       ATTSCH_GRADECAT as gradecat,
       ATTSCH_NETWORK as network,
       ATTSCH_GOVERNANCE as governance
FROM zoned_receiving
UNION
select ZONESCH_ID as id,
       ZONESCH_NAME as name,
       ZONESCH_GRADECAT as gradecat,
       NULL as network,
       ZONESCH_GOVERNANCE as governance
FROM zoned_receiving) as all_schools
where id is not null
group by id
