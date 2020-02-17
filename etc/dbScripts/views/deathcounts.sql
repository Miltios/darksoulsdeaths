CREATE
    ALGORITHM = UNDEFINED
VIEW `darksou1_darksoulsdeaths`.`deathcounts` AS
    SELECT
        (CASE
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` = 0) THEN 0
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 1 AND 50) THEN 25
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 51 AND 100) THEN 75
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 101 AND 150) THEN 125
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 151 AND 200) THEN 175
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 201 AND 250) THEN 225
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 251 AND 300) THEN 275
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 301 AND 350) THEN 325
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 351 AND 400) THEN 375
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 401 AND 450) THEN 425
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 451 AND 500) THEN 475
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 501 AND 550) THEN 525
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 551 AND 600) THEN 575
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 601 AND 650) THEN 625
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 651 AND 700) THEN 675
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 701 AND 750) THEN 725
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 751 AND 800) THEN 775
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 801 AND 850) THEN 825
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 851 AND 900) THEN 875
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 901 AND 950) THEN 925
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 951 AND 999) THEN 975
            WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` >= 1000) THEN 1000
        END) AS `rangeIndex`,
        COUNT(0) AS `count`
    FROM
        `darksou1_darksoulsdeaths`.`characters`
    GROUP BY (CASE
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` = 0) THEN 0
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 1 AND 50) THEN 25
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 51 AND 100) THEN 75
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 101 AND 150) THEN 125
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 151 AND 200) THEN 175
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 201 AND 250) THEN 225
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 251 AND 300) THEN 275
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 301 AND 350) THEN 325
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 351 AND 400) THEN 375
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 401 AND 450) THEN 425
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 451 AND 500) THEN 475
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 501 AND 550) THEN 525
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 551 AND 600) THEN 575
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 601 AND 650) THEN 625
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 651 AND 700) THEN 675
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 701 AND 750) THEN 725
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 751 AND 800) THEN 775
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 801 AND 850) THEN 825
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 851 AND 900) THEN 875
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 901 AND 950) THEN 925
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` BETWEEN 951 AND 999) THEN 975
        WHEN (`darksou1_darksoulsdeaths`.`characters`.`deaths` >= 1000) THEN 1000
    END)