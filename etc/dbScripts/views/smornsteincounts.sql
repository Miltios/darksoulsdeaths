CREATE
    ALGORITHM = UNDEFINED
VIEW `darksou1_darksoulsdeaths`.`smornsteincounts` AS
    SELECT
        `s`.`smornsteinname` AS `smornsteinname`,
        COUNT(0) AS `count`
    FROM
        (`darksou1_darksoulsdeaths`.`characters` `c`
        JOIN `darksou1_darksoulsdeaths`.`smornstein` `s` ON ((`c`.`smornstein` = `s`.`smornsteinid`)))
    WHERE
        (`c`.`smornstein` <> 0)
    GROUP BY `c`.`smornstein`
    ORDER BY COUNT(0) DESC
    LIMIT 5