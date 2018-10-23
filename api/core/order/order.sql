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
        "lineCount"    BIGINT,
        "id"           BoneareAdm.Order.id%TYPE,
        "description"  BoneareAdm.Order.description%TYPE,
        "client"       BoneareAdm.Client.name%TYPE,
        "totalCost"    DECIMAL(10, 2),
        "totalCostAll" DECIMAL(10, 2)
    ) AS $$

/*
Documentation
Source file.......: order.sql
Description.......: Find all orders
Author............: Ítalo Andrade
Date..............: 12/09/2018
Ex................:

SELECT * FROM BoneareAdm.OrderFindAll(null, null, null, 1, 10);

*/

DECLARE
    vTotalCostAll DECIMAL(10, 2);

BEGIN
    SELECT SUM(op.quantity * p.price * iif(op.entry, -1, 1)) INTO vTotalCostAll
    FROM BoneareAdm.Order_Product op
             INNER JOIN BoneareAdm.Product p ON p.id = op.product_id;

    RETURN QUERY
    SELECT COUNT(1) OVER (PARTITION BY 1) lineCount,
           o.id,
           o.description,
           c.name                         client,
           (SELECT SUM(op.quantity * p.price * iif(op.entry, -1, 1))
            FROM BoneareAdm.Order_Product op
                     INNER JOIN BoneareAdm.Product p ON p.id = op.product_id
            WHERE op.order_id = o.id)     totalCost,
           vTotalCostAll
    FROM BoneareAdm.Order o
             LEFT JOIN BoneareAdm.Client c ON c.id = o.client_id
    WHERE CASE
              WHEN pFilter IS NOT NULL
                    THEN unaccent(o.description) ILIKE '%' || unaccent(pFilter) || '%' OR
                         unaccent(c.name) ILIKE '%' || unaccent(pFilter) || '%' OR
                         o.id :: TEXT = pFilter
              ELSE TRUE END
    ORDER BY (iif(pSortColumn = 'id' AND pSortOrder = 'asc', o.id, NULL)) ASC,
             (iif(pSortColumn = 'id' AND pSortOrder = 'desc', o.id, NULL)) DESC,
             (iif(pSortColumn = 'description' AND pSortOrder = 'asc', o.description, NULL)) ASC,
             (iif(pSortColumn = 'description' AND pSortOrder = 'desc', o.description, NULL)) DESC,
             (iif(pSortColumn = 'client' AND pSortOrder = 'asc', c.name, NULL)) ASC,
             (iif(pSortColumn = 'client' AND pSortOrder = 'desc', c.name, NULL)) DESC,
             (COALESCE(o.last_update_date, o.creation_date)) DESC
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

SELECT * FROM BoneareAdm.OrderFindById(32);

*/

BEGIN
    RETURN QUERY
    SELECT o.id,
           o.description,
           o.client_id,
           jsonb_build_object(
               'id', c.id,
               'name', c.name
               )                                                                                         address,
           (SELECT COALESCE(jsonb_agg(cp), '[]') FROM BoneareAdm.Order_Phone cp WHERE cp.order_id = pId) phones,
           (SELECT COALESCE(jsonb_agg(ce), '[]') FROM BoneareAdm.Order_Email ce WHERE ce.order_id = pId) emails
    FROM BoneareAdm.Order o
             LEFT JOIN BoneareAdm.Client c ON c.id = o.client_id
    WHERE o.id = pId;
END;
$$
LANGUAGE plpgsql;


SELECT DeleteFunctions('BoneareAdm', 'OrderAdd');
CREATE OR REPLACE FUNCTION BoneareAdm.OrderAdd(
    pUserIdAction BoneareAdm.User.id%TYPE,
    pName         BoneareAdm.Order.name%TYPE,
    pDocument     BoneareAdm.Order.document%TYPE,
    pDescription  BoneareAdm.Order.description%TYPE,
    pAddress      JSONB,
    pPhones       JSONB,
    pEmails       JSONB
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
   'Order Test',   -- pName
   '45338491800',   -- pDocument
   null,            -- pDescription
   null,            -- pPhones
   null             -- pEmails
);

*/

DECLARE
    vErrorProcedure TEXT;
    vErrorMessage   TEXT;
    vId             BoneareAdm.Order.id%TYPE;

BEGIN
    IF EXISTS(SELECT 1 FROM BoneareAdm.Order c WHERE c.document = pDocument)
    THEN
        RETURN
        jsonb_build_object(
            'code', 1,
            'message', 'Documento existente'
        );
    END IF;

    INSERT INTO BoneareAdm.Order (name, document, description, created_by)
    VALUES (pName, pDocument, pDescription, pUserIdAction)
        RETURNING id
            INTO vId;

    IF pAddress IS NOT NULL
    THEN
        INSERT INTO BoneareAdm.Order_Address (order_id, zip_code, street, number, complement, district, city, state)
        VALUES (vId,
                pAddress ->> 'zipCode',
                pAddress ->> 'street',
                pAddress ->> 'number',
                pAddress ->> 'complement',
                pAddress ->> 'district',
                pAddress ->> 'city',
                pAddress ->> 'state');
    END IF;

    IF pPhones IS NOT NULL
    THEN
        INSERT INTO BoneareAdm.Order_Phone (order_id, number)
        SELECT vId, "number"
        FROM jsonb_to_recordset(pPhones)
                 AS x ("number" BIGINT);
    END IF;

    IF pEmails IS NOT NULL
    THEN
        INSERT INTO BoneareAdm.Order_Email (order_id, email)
        SELECT vId, "email"
        FROM jsonb_to_recordset(pEmails)
                 AS x ("email" TEXT);
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
    pName         BoneareAdm.Order.name%TYPE,
    pDocument     BoneareAdm.Order.document%TYPE,
    pDescription  BoneareAdm.Order.description%TYPE,
    pAddress      JSONB,
    pPhones       JSONB,
    pEmails       JSONB
)
    RETURNS JSONB AS $$

/*
Documentation
Source file.......: order.sql
Description.......: Update a order
Author............: Ítalo Andrade
Date..............: 10/10/2018
Ex................:

SELECT * FROM BoneareAdm.OrderUpdate(
   1,               -- pUserIdAction
   12,              -- pId
   'Order Test',   -- pName
   '45338491800',   -- pDocument
   null,            -- pDescription
   null,            -- pPhones
   null             -- pEmails
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
            'message', 'Ordere não encontrado'
        );
    END IF;

    IF EXISTS(SELECT 1 FROM BoneareAdm.Order c WHERE c.document = pDocument
                                                 AND c.id <> pId)
    THEN
        RETURN
        jsonb_build_object(
            'code', 2,
            'message', 'Documento existente'
        );
    END IF;

    UPDATE BoneareAdm.Order
    SET name             = pName,
        document         = pDocument,
        description      = pDescription,
        last_update_by   = pUserIdAction,
        last_update_date = CURRENT_TIMESTAMP
    WHERE id = pId;

    IF EXISTS(SELECT 1 FROM BoneareAdm.Order_Address WHERE order_id = pId)
    THEN
        UPDATE BoneareAdm.Order_Address
        SET zip_code   = pAddress ->> 'zipCode',
            street     = pAddress ->> 'street',
            number     = pAddress ->> 'number',
            complement = pAddress ->> 'complement',
            district   = pAddress ->> 'district',
            city       = pAddress ->> 'city',
            state      = pAddress ->> 'state'
        WHERE order_id = pId;
    ELSE
        INSERT INTO BoneareAdm.Order_Address (order_id, zip_code, street, number, complement, district, city, state)
        VALUES (pId,
                pAddress ->> 'zipCode',
                pAddress ->> 'street',
                pAddress ->> 'number',
                pAddress ->> 'complement',
                pAddress ->> 'district',
                pAddress ->> 'city',
                pAddress ->> 'state');
    END IF;

    IF pPhones IS NOT NULL
    THEN
        DELETE
        FROM BoneareAdm.Order_Phone
        WHERE order_id = pId
          AND id NOT IN (SELECT "id" FROM jsonb_to_recordset(pPhones)
                                              AS x ("id" INTEGER) WHERE "id" IS NOT NULL);

        INSERT INTO BoneareAdm.Order_Phone (order_id, number)
        SELECT pId, "number"
        FROM jsonb_to_recordset(pPhones)
                 AS x ("id" TEXT, "number" BIGINT)
        WHERE "id" IS NULL;

        UPDATE BoneareAdm.Order_Phone
        SET number = cp."number"
        FROM (SELECT "id", "number"
              FROM jsonb_to_recordset(pPhones)
                       AS x ("id" INTEGER, "number" BIGINT)
              WHERE "id" IS NOT NULL) cp
        WHERE order_id = pId
          AND BoneareAdm.Order_Phone.id = cp."id";
    END IF;

    IF pEmails IS NOT NULL
    THEN
        DELETE
        FROM BoneareAdm.Order_Email
        WHERE order_id = pId
          AND id NOT IN (SELECT "id" FROM jsonb_to_recordset(pEmails)
                                              AS x ("id" INTEGER) WHERE "id" IS NOT NULL);

        INSERT INTO BoneareAdm.Order_Email (order_id, email)
        SELECT pId, "email"
        FROM jsonb_to_recordset(pEmails)
                 AS x ("id" INTEGER, "email" TEXT)
        WHERE "id" IS NULL;

        UPDATE BoneareAdm.Order_Email
        SET email = ce."email"
        FROM (SELECT "id", "email"
              FROM jsonb_to_recordset(pEmails)
                       AS x ("id" INTEGER, "email" TEXT)
              WHERE "id" IS NOT NULL) ce
        WHERE order_id = pId
          AND BoneareAdm.Order_Email.id = ce."id";
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
Date..............: 10/10/2018
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
            'message', 'Ordere não encontrado'
        );
    END IF;

    SELECT to_jsonb(o) INTO vNewRelation FROM BoneareAdm.Order o WHERE o.order_id = pId;
    IF vNewRelation IS NOT NULL
    THEN
        vRelations = vRelations || jsonb_build_object(
            'relation', 'Pedido ' || COALESCE(vNewRelation ->> 'description', vNewRelation ->> 'id'),
            'url', '/order/' || (vNewRelation ->> 'id')
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

    DELETE FROM BoneareAdm.Order_Address WHERE order_id = pId;
    DELETE FROM BoneareAdm.Order_Phone WHERE order_id = pId;
    DELETE FROM BoneareAdm.Order_Email WHERE order_id = pId;
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