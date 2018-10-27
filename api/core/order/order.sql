/**/


SELECT DeleteFunctions('BoneareAdm', 'OrderFindAll');
CREATE OR REPLACE FUNCTION BoneareAdm.OrderFindAll(
    pFilter     VARCHAR(200),
    pSortColumn VARCHAR(100),
    pSortOrder  VARCHAR(100),
    pPageNumber INTEGER,
    pPageSize   INTEGER
)
    RETURNS TABLE(
        "lineCount"      BIGINT,
        "id"             BoneareAdm.Order.id%TYPE,
        "description"    BoneareAdm.Order.description%TYPE,
        "date"           BoneareAdm.Order.date%TYPE,
        "client"         BoneareAdm.Client.name%TYPE,
        "totalCost"      DECIMAL(10, 2),
        "totalPaid"      DECIMAL(10, 2),
        "totalWeight"    DECIMAL(10, 2),
        "totalCostAll"   DECIMAL(10, 2),
        "totalPaidAll"   DECIMAL(10, 2),
        "totalWeightAll" DECIMAL(10, 2)
    ) AS $$

/*
Documentation
Source file.......: order.sql
Description.......: Find all orders
Author............: Ítalo Andrade
Date..............: 12/09/2018
Ex................:

SELECT * FROM BoneareAdm.OrderFindAll(null, 'totalPaid', 'asc', 0, 10);

*/

DECLARE
    vTotalCostAll   DECIMAL(10, 2);
    vTotalPaidAll   DECIMAL(10, 2);
    vTotalWeightAll DECIMAL(10, 2);

BEGIN
    SELECT SUM(op.quantity * p.price * iif(op.entry, 0, 1)) INTO vTotalCostAll
    FROM BoneareAdm.Order_Product op
             INNER JOIN BoneareAdm.Product p ON p.id = op.product_id;

    SELECT SUM(ot.amount * iif(ot.type = 1, 1, -1)) INTO vTotalPaidAll FROM BoneareAdm.Order_Transaction ot;

    SELECT SUM(op.quantity * p.weight * iif(op.entry, 1, -1)) INTO vTotalWeightAll
    FROM BoneareAdm.Order_Product op
             INNER JOIN BoneareAdm.Product p ON p.id = op.product_id;

    RETURN QUERY
    SELECT sq.lineCount,
           sq.id,
           sq.description,
           sq.date,
           sq.client,
           sq.totalCost,
           sq.totalPaid,
           sq.totalWeight,
           sq.vTotalCostAll,
           sq.vTotalPaidAll,
           sq.vTotalWeightAll
    FROM (SELECT COUNT(1) OVER (PARTITION BY 1) lineCount,
                 o.id,
                 o.description,
                 o.date,
                 c.name                         client,
                 (SELECT SUM(op.quantity * p.price * iif(op.entry, null, 1))
                  FROM BoneareAdm.Order_Product op
                           INNER JOIN BoneareAdm.Product p ON p.id = op.product_id
                  WHERE op.order_id = o.id)     totalCost,
                 (SELECT SUM(ot.amount * iif(ot.type = 1, 1, -1))
                  FROM BoneareAdm.Order_Transaction ot
                  WHERE ot.order_id = o.id)     totalPaid,
                 (SELECT SUM(op.quantity * p.weight * iif(op.entry, 1, -1))
                  FROM BoneareAdm.Order_Product op
                           INNER JOIN BoneareAdm.Product p ON p.id = op.product_id
                  WHERE op.order_id = o.id)     totalWeight,
                 vTotalCostAll,
                 vTotalPaidAll,
                 vTotalWeightAll,
                 o.creation_date,
                 o.last_update_date
          FROM BoneareAdm.Order o
                   LEFT JOIN BoneareAdm.Client c ON c.id = o.client_id) sq
    WHERE (pFilter IS NULL OR
           unaccent(sq.description) ILIKE '%' || unaccent(pFilter) || '%' OR
           unaccent(sq.client) ILIKE '%' || unaccent(pFilter) || '%' OR
           sq.id :: TEXT = pFilter)
    ORDER BY (iif(pSortColumn = 'id' AND pSortOrder = 'asc', sq.id, NULL)) ASC,
             (iif(pSortColumn = 'id' AND pSortOrder = 'desc', sq.id, NULL)) DESC,
             (iif(pSortColumn = 'description' AND pSortOrder = 'asc', sq.description, NULL)) ASC,
             (iif(pSortColumn = 'description' AND pSortOrder = 'desc', sq.description, NULL)) DESC,
             (iif(pSortColumn = 'date' AND pSortOrder = 'asc', sq.date, NULL)) ASC,
             (iif(pSortColumn = 'date' AND pSortOrder = 'desc', sq.date, NULL)) DESC,
             (iif(pSortColumn = 'client' AND pSortOrder = 'asc', sq.client, NULL)) ASC,
             (iif(pSortColumn = 'client' AND pSortOrder = 'desc', sq.client, NULL)) DESC,
             (iif(pSortColumn = 'totalCost' AND pSortOrder = 'asc', sq.totalCost, NULL)) ASC,
             (iif(pSortColumn = 'totalCost' AND pSortOrder = 'desc', sq.totalCost, NULL)) DESC,
             (iif(pSortColumn = 'totalPaid' AND pSortOrder = 'asc', sq.totalPaid, NULL)) ASC,
             (iif(pSortColumn = 'totalPaid' AND pSortOrder = 'desc', sq.totalPaid, NULL)) DESC,
             (COALESCE(sq.last_update_date, sq.creation_date)) DESC
    LIMIT iif(pPageSize > 0 AND pPageNumber >= 0, pPageSize, NULL)
    OFFSET iif(pPageSize > 0 AND pPageNumber >= 0, pPageNumber * pPageSize, NULL);
END;
$$
LANGUAGE plpgsql;


SELECT DeleteFunctions('BoneareAdm', 'OrderFindById');
CREATE OR REPLACE FUNCTION BoneareAdm.OrderFindById(
    pId BoneareAdm.Order.id%TYPE
)
    RETURNS TABLE(
        "id"           BoneareAdm.Order.id%TYPE,
        "description"  BoneareAdm.Order.description%TYPE,
        "date"         BoneareAdm.Order.date%TYPE,
        "clientId"     BoneareAdm.Client.id%TYPE,
        "client"       JSONB,
        "products"     JSONB,
        "transactions" JSONB
    ) AS $$

/*
Documentation
Source file.......: order.sql
Description.......: Find a order by ID
Author............: Ítalo Andrade
Date..............: 22/10/2018
Ex................:

SELECT * FROM BoneareAdm.OrderFindById(1);

*/

DECLARE
    vTotalCost DECIMAL(10, 2);
    vTotalPaid DECIMAL(10, 2);

BEGIN
    SELECT SUM(op.quantity * p.price * iif(op.entry, 0, 1)) INTO vTotalCost
    FROM BoneareAdm.Order_Product op
             INNER JOIN BoneareAdm.Product p ON p.id = op.product_id
    WHERE op.order_id = pId;
    SELECT SUM(ot.amount * iif(ot.type = 1, 1, -1)) INTO vTotalPaid
    FROM BoneareAdm.Order_Transaction ot
    WHERE ot.order_id = pId;

    RETURN QUERY
    SELECT o.id,
           o.description,
           o.date,
           o.client_id,
           iif(c.id IS NOT NULL, jsonb_build_object(
                                     'id', c.id,
                                     'name', c.name
               ), null)                        client,
           (SELECT COALESCE(jsonb_agg(op), '[]')
            FROM (SELECT op.id,
                         op.order_id   "orderId",
                         op.product_id "productId",
                         p.name        "name",
                         op.quantity,
                         op.entry,
                         p.price,
                         p.weight,
                         vTotalCost    "totalCost"
                  FROM BoneareAdm.Order_Product op
                           INNER JOIN BoneareAdm.Product p ON p.id = op.product_id
                  WHERE op.order_id = pId) op) products,
           (SELECT COALESCE(jsonb_agg(ot), '[]')
            FROM (SELECT ot.id,
                         ot.order_id                                      "orderId",
                         jsonb_build_object('id', tt.id, 'name', tt.name) "type",
                         tt.id                                            "typeId",
                         ot.amount,
                         ot.date,
                         vTotalPaid                                       "totalPaid"
                  FROM BoneareAdm.Order_Transaction ot
                           INNER JOIN BoneareAdm.Transaction_Type tt ON tt.id = ot.type
                  WHERE ot.order_id = pId) ot) transactions
    FROM BoneareAdm.Order o
             LEFT JOIN BoneareAdm.Client c ON c.id = o.client_id
    WHERE o.id = pId;
END;
$$
LANGUAGE plpgsql;


SELECT DeleteFunctions('BoneareAdm', 'OrderAdd');
CREATE OR REPLACE FUNCTION BoneareAdm.OrderAdd(
    pUserIdAction BoneareAdm.User.id%TYPE,
    pDescription  BoneareAdm.Order.description%TYPE,
    pDate         BoneareAdm.Order.date%TYPE,
    pClientId     BoneareAdm.Order.client_id%TYPE,
    pProducts     JSONB,
    pTransactions JSONB
)
    RETURNS JSONB AS $$

/*
Documentation
Source file.......: order.sql
Description.......: Add a new order
Author............: Ítalo Andrade
Date..............: 10/10/2018
Ex................:

SELECT * FROM BoneareAdm.OrderAdd(
   1,               -- pUserIdAction
   null,            -- pDescription
   null,            -- pDate
   1,               -- pClientId
   null,            -- pProducts
   null             -- pTransactions
);

*/

DECLARE
    vErrorProcedure TEXT;
    vErrorMessage   TEXT;
    vId             BoneareAdm.Order.id%TYPE;

BEGIN
    INSERT INTO BoneareAdm.Order (description, date, client_id, created_by)
    VALUES (pDescription, pDate, pClientId, pUserIdAction)
        RETURNING id
            INTO vId;

    IF pProducts IS NOT NULL
    THEN
        INSERT INTO BoneareAdm.Order_Product (order_id, product_id, quantity, entry, created_by)
        SELECT vId, "productId", "quantity", "entry", pUserIdAction
        FROM jsonb_to_recordset(pProducts)
                 AS x ("productId" INTEGER, "quantity" INTEGER, "entry" BOOLEAN);
    END IF;

    IF pTransactions IS NOT NULL
    THEN
        INSERT INTO BoneareAdm.Order_Transaction (order_id, type, date, amount, created_by)
        SELECT vId, "typeId", "date", "amount", pUserIdAction
        FROM jsonb_to_recordset(pTransactions)
                 AS x ("typeId" SMALLINT, "date" TIMESTAMP WITH TIME ZONE, "amount" NUMERIC(10, 2));
    END IF;

    RETURN
    jsonb_build_object(
        'code', 0,
        'return', jsonb_build_object(
            'id', vId
        )
    );
    EXCEPTION WHEN OTHERS
    THEN
        GET STACKED DIAGNOSTICS vErrorProcedure = MESSAGE_TEXT;
        GET STACKED DIAGNOSTICS vErrorMessage = PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Internal Error: (%) %', vErrorProcedure, vErrorMessage;
END;
$$
LANGUAGE plpgsql;


SELECT DeleteFunctions('BoneareAdm', 'OrderUpdate');
CREATE OR REPLACE FUNCTION BoneareAdm.OrderUpdate(
    pUserIdAction BoneareAdm.User.id%TYPE,
    pId           BoneareAdm.Order.id%TYPE,
    pDescription  BoneareAdm.Order.description%TYPE,
    pDate         BoneareAdm.Order.date%TYPE,
    pClientId     BoneareAdm.Order.client_id%TYPE,
    pProducts     JSONB,
    pTransactions JSONB
)
    RETURNS JSONB AS $$

/*
Documentation
Source file.......: order.sql
Description.......: Update a order
Author............: Ítalo Andrade
Date..............: 27/10/2018
Ex................:

SELECT * FROM BoneareAdm.OrderUpdate(
   1,               -- pUserIdAction
   12,              -- pId
   null,            -- pDescription
   null,            -- pDate
   1,               -- pClientId
   null,            -- pProducts
   null             -- pTransactions
);

*/

DECLARE
    vErrorProcedure TEXT;
    vErrorMessage   TEXT;

BEGIN
    IF NOT EXISTS(SELECT 1 FROM BoneareAdm.Order c WHERE c.id = pId)
    THEN
        RETURN
        jsonb_build_object(
            'code', 1,
            'message', 'Pedido não encontrado'
        );
    END IF;

    UPDATE BoneareAdm.Order
    SET description      = pDescription,
        date             = pDate,
        client_id        = pClientId,
        last_update_by   = pUserIdAction,
        last_update_date = CURRENT_TIMESTAMP
    WHERE id = pId;

    IF pProducts IS NOT NULL
    THEN
        DELETE
        FROM BoneareAdm.Order_Product
        WHERE order_id = pId
          AND id NOT IN (SELECT "id" FROM jsonb_to_recordset(pProducts)
                                              AS x ("id" INTEGER) WHERE "id" IS NOT NULL);

        INSERT INTO BoneareAdm.Order_Product (order_id, product_id, quantity, entry, created_by)
        SELECT pId, "productId", "quantity", "entry", pUserIdAction
        FROM jsonb_to_recordset(pProducts)
                 AS x ("id" TEXT, "productId" INTEGER, "quantity" INTEGER, "entry" BOOLEAN)
        WHERE "id" IS NULL;

        UPDATE BoneareAdm.Order_Product
        SET product_id       = op."productId",
            quantity         = op."quantity",
            entry            = op."entry",
            last_update_by   = pUserIdAction,
            last_update_date = CURRENT_TIMESTAMP
        FROM (SELECT "id", "productId", "quantity", "entry"
              FROM jsonb_to_recordset(pProducts)
                       AS x ("id" INTEGER, "productId" INTEGER, "quantity" INTEGER, "entry" BOOLEAN)
              WHERE "id" IS NOT NULL) op
        WHERE order_id = pId
          AND BoneareAdm.Order_Product.id = op."id";
    END IF;

    IF pTransactions IS NOT NULL
    THEN
        DELETE
        FROM BoneareAdm.Order_Transaction
        WHERE order_id = pId
          AND id NOT IN (SELECT "id" FROM jsonb_to_recordset(pTransactions)
                                              AS x ("id" INTEGER) WHERE "id" IS NOT NULL);

        INSERT INTO BoneareAdm.Order_Transaction (order_id, type, date, amount, created_by)
        SELECT pId, "typeId", "date", "amount", pUserIdAction
        FROM jsonb_to_recordset(pTransactions)
                 AS x ("id" TEXT, "typeId" SMALLINT, "date" TIMESTAMP WITH TIME ZONE, "amount" NUMERIC(10, 2))
        WHERE "id" IS NULL;

        UPDATE BoneareAdm.Order_Transaction
        SET type             = op."typeId",
            date             = op."date",
            amount           = op."amount",
            last_update_by   = pUserIdAction,
            last_update_date = CURRENT_TIMESTAMP
        FROM (SELECT "id", "typeId", "date", "amount"
              FROM jsonb_to_recordset(pTransactions)
                       AS x ("id" INTEGER, "typeId" SMALLINT, "date" TIMESTAMP WITH TIME ZONE, "amount" NUMERIC(10, 2))
              WHERE "id" IS NOT NULL) op
        WHERE order_id = pId
          AND BoneareAdm.Order_Transaction.id = op."id";
    END IF;

    RETURN
    jsonb_build_object(
        'code', 0
    );
    EXCEPTION WHEN OTHERS
    THEN
        GET STACKED DIAGNOSTICS vErrorProcedure = MESSAGE_TEXT;
        GET STACKED DIAGNOSTICS vErrorMessage = PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Internal Error: (%) %', vErrorProcedure, vErrorMessage;
END;
$$
LANGUAGE plpgsql;


SELECT DeleteFunctions('BoneareAdm', 'OrderRemove');
CREATE OR REPLACE FUNCTION BoneareAdm.OrderRemove(
    pId BoneareAdm.Order.id%TYPE
)
    RETURNS JSONB AS $$

/*
Documentation
Source file.......: order.sql
Description.......: Remove a order
Author............: Ítalo Andrade
Date..............: 27/10/2018
Ex................:

SELECT * FROM BoneareAdm.OrderRemove(
   13   -- pId
);

*/

DECLARE
    vErrorProcedure TEXT;
    vErrorMessage   TEXT;
    vRelations      JSONB = '[]';
    vNewRelation    JSONB;

BEGIN
    IF NOT EXISTS(SELECT 1 FROM BoneareAdm.Order c WHERE c.id = pId)
    THEN
        RETURN
        jsonb_build_object(
            'code', 1,
            'message', 'Pedido não encontrado'
        );
    END IF;

    SELECT to_jsonb(op) INTO vNewRelation FROM BoneareAdm.Order_Product op WHERE op.order_id = pId;
    IF vNewRelation IS NOT NULL
    THEN
        vRelations = vRelations || jsonb_build_object(
            'relation', 'Produto de pedido ' || (vNewRelation ->> 'id'),
            'url', '/order/' || (vNewRelation ->> 'order_id')
        );
    END IF;

    SELECT to_jsonb(ot) INTO vNewRelation FROM BoneareAdm.Order_Transaction ot WHERE ot.order_id = pId;
    IF vNewRelation IS NOT NULL
    THEN
        vRelations = vRelations || jsonb_build_object(
            'relation', 'Transação de pedido ' || (vNewRelation ->> 'id'),
            'url', '/order/' || (vNewRelation ->> 'order_id')
        );
    END IF;

    IF jsonb_array_length(vRelations) > 0
    THEN
        RETURN
        jsonb_build_object(
            'code', 2,
            'message', 'Contém vínculos',
            'relations', vRelations
        );
    END IF;

    DELETE FROM BoneareAdm.Order WHERE id = pId;

    RETURN
    jsonb_build_object(
        'code', 0
    );
    EXCEPTION WHEN OTHERS
    THEN
        GET STACKED DIAGNOSTICS vErrorProcedure = MESSAGE_TEXT;
        GET STACKED DIAGNOSTICS vErrorMessage = PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Internal Error: (%) %', vErrorProcedure, vErrorMessage;
END;
$$
LANGUAGE plpgsql;


/**/