CREATE
    ALGORITHM = UNDEFINED
VIEW `darksou1_darksoulsdeaths`.`optionalcounts` AS
    SELECT
        `o`.`optionalareasname` AS `optionalareasname`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        (`darksou1_darksoulsdeaths`.`characters` `c`
        JOIN `darksou1_darksoulsdeaths`.`optionalareas` `o` ON (((`c`.`shitholes` = 1)
            AND (`o`.`optionalareasid` = 0))))
    UNION SELECT
        `o`.`optionalareasname` AS `optionalareasname`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        (`darksou1_darksoulsdeaths`.`characters` `c`
        JOIN `darksou1_darksoulsdeaths`.`optionalareas` `o` ON (((`c`.`dragonbros` = 1)
            AND (`o`.`optionalareasid` = 1))))
    UNION SELECT
        `o`.`optionalareasname` AS `optionalareasname`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        (`darksou1_darksoulsdeaths`.`characters` `c`
        JOIN `darksou1_darksoulsdeaths`.`optionalareas` `o` ON (((`c`.`asylum` = 1)
            AND (`o`.`optionalareasid` = 2))))
    UNION SELECT
        `o`.`optionalareasname` AS `optionalareasname`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        (`darksou1_darksoulsdeaths`.`characters` `c`
        JOIN `darksou1_darksoulsdeaths`.`optionalareas` `o` ON (((`c`.`paintedworld` = 1)
            AND (`o`.`optionalareasid` = 3))))
    UNION SELECT
        `o`.`optionalareasname` AS `optionalareasname`,
        ROUND(((COUNT(0) / (SELECT
                        COUNT(0)
                    FROM
                        `darksou1_darksoulsdeaths`.`characters`)) * 100),
                0) AS `percentage`
    FROM
        (`darksou1_darksoulsdeaths`.`characters` `c`
        JOIN `darksou1_darksoulsdeaths`.`optionalareas` `o` ON (((`c`.`manus` = 1)
            AND (`o`.`optionalareasid` = 4))))