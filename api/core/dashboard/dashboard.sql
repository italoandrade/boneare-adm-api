/**/


SELECT DeleteFunctions('BoneareAdm', 'DashboardGetInfo');
CREATE OR REPLACE FUNCTION BoneareAdm.DashboardGetInfo()
    RETURNS TABLE(
        "clients"   BIGINT,
        "balance"   NUMERIC(10, 2),
        "stock"     NUMERIC(10, 2),
        "toReceive" NUMERIC(10, 2)
    ) AS $$

/*
Documentation
Source file.......: dashboard.sql
Description.......: Get dashboard info
Author............: Ítalo Andrade
Date..............: 19/10/2018
Ex................:

SELECT * FROM BoneareAdm.DashboardGetInfo();

*/

DECLARE vBalance DECIMAL(10, 2);

BEGIN
    vBalance = (SELECT COALESCE(SUM(amount * iif("type" = 1, 1, -1)), 0) FROM BoneareAdm.Order_Transaction);

    RETURN QUERY
    SELECT (SELECT COUNT(1) FROM BoneareAdm.Client)                           clients,
           vBalance                                                           balance,
           (SELECT COALESCE(SUM((op."quantity" * iif(op."entry", 1, -1)) * p.weight), 0)
            FROM BoneareAdm.Order_Product op
                     INNER JOIN BoneareAdm.Product p ON p.id = op.product_id) stock,
           (SELECT COALESCE(SUM((op."quantity" * iif(op."entry", 0, 1)) * p.price), 0) - vBalance
            FROM BoneareAdm.Order_Product op
                     INNER JOIN BoneareAdm.Product p ON p.id = op.product_id) toReceive;
END;
$$
LANGUAGE plpgsql;


/**/