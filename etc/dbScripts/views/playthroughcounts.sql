CREATE
    ALGORITHM = UNDEFINED
VIEW `darksou1_darksoulsdeaths`.`playthroughcounts` AS
    SELECT
        0 AS `playthrough beaten`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`playthrough` >= 1)
    UNION SELECT
        1 AS `playthrough beaten`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`playthrough` >= 2)
    UNION SELECT
        2 AS `playthrough beaten`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`playthrough` >= 3)
    UNION SELECT
        3 AS `playthrough beaten`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`playthrough` >= 4)
    UNION SELECT
        4 AS `playthrough beaten`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`playthrough` >= 5)
    UNION SELECT
        5 AS `playthrough beaten`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`playthrough` >= 6)
    UNION SELECT
        6 AS `playthrough beaten`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`playthrough` >= 7)
    UNION SELECT
        7 AS `playthrough beaten`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`playthrough` = 8)