CREATE
    ALGORITHM = UNDEFINED
VIEW `darksou1_darksoulsdeaths`.`deathandadppaverages` AS
    SELECT
        ROUND(AVG(`darksou1_darksoulsdeaths`.`characters`.`deaths`),
                0) AS `round(avg(deaths))`,
        ROUND(AVG(`darksou1_darksoulsdeaths`.`characters`.`adpp`),
                0) AS `round(avg(adpp))`
    FROM
        `darksou1_darksoulsdeaths`.`characters`