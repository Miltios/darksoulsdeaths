CREATE
    ALGORITHM = UNDEFINED
VIEW `darksou1_darksoulsdeaths`.`progresscounts` AS
    SELECT 0 AS `progress`, 100 AS `percentage`
    UNION SELECT
        1 AS `progress`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`progress` >= 0.1)
    UNION SELECT
        2 AS `progress`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`progress` >= 0.2)
    UNION SELECT
        3 AS `progress`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`progress` >= 0.3)
    UNION SELECT
        4 AS `progress`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`progress` >= 0.4)
    UNION SELECT
        5 AS `progress`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`progress` >= 0.5)
    UNION SELECT
        6 AS `progress`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`progress` >= 0.6)
    UNION SELECT
        7 AS `progress`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`progress` >= 0.7)
    UNION SELECT
        8 AS `progress`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`progress` >= 0.8)
    UNION SELECT
        9 AS `progress`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        `darksou1_darksoulsdeaths`.`characters` `c`
    WHERE
        (`c`.`progress` = 0.9)