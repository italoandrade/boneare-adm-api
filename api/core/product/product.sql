/**/


SELECT DeleteFunctions('BoneareAdm', 'ProductFindAll');
CREATE OR REPLACE FUNCTION BoneareAdm.ProductFindAll(
    pFilter     VARCHAR(200),
    pSortColumn VARCHAR(100),
    pSortOrder  VARCHAR(100),
    pPageNumber INTEGER,
    pPageSize   INTEGER
)
    RETURNS TABLE(
        "lineCount" BIGINT,
        "id"        BoneareAdm.Product.id%TYPE,
        "name"      BoneareAdm.Product.name%TYPE
    ) AS $$

/*
Documentation
Source file.......: product.sql
Description.......: Find all products
Author............: Ítalo Andrade
Date..............: 12/09/2018
Ex................:

SELECT * FROM BoneareAdm.ProductFindAll(null, null, null, 1, 10);

*/

BEGIN
    RETURN QUERY
    SELECT COUNT(1) OVER (PARTITION BY 1) lineCount, p.id, p.name
    FROM BoneareAdm.Product p
    WHERE CASE
              WHEN pFilter IS NOT NULL
                    THEN unaccent(p.name) ILIKE '%' || unaccent(pFilter) || '%' OR
                         p.id :: TEXT = pFilter
              ELSE TRUE END
    ORDER BY (iif(pSortColumn = 'id' AND pSortOrder = 'asc', p.id, NULL)) ASC,
             (iif(pSortColumn = 'id' AND pSortOrder = 'desc', p.id, NULL)) DESC,
             (iif(pSortColumn = 'name' AND pSortOrder = 'asc', p.name, NULL)) ASC,
             (iif(pSortColumn = 'name' AND pSortOrder = 'desc', p.name, NULL)) DESC,
             (COALESCE(p.last_update_date, p.creation_date)) DESC
    LIMIT iif(pPageSize > 0 AND pPageNumber >= 0, pPageSize, NULL)
    OFFSET iif(pPageSize > 0 AND pPageNumber >= 0, pPageNumber * pPageSize, NULL);
END;
$$
LANGUAGE plpgsql;


SELECT DeleteFunctions('BoneareAdm', 'ProductFindAutocomplete');
CREATE OR REPLACE FUNCTION BoneareAdm.ProductFindAutocomplete(
    pFilter VARCHAR(200),
    pUnless INTEGER []
)
    RETURNS TABLE(
        "id"   BoneareAdm.Product.id%TYPE,
        "name" BoneareAdm.Product.name%TYPE
    ) AS $$

/*
Documentation
Source file.......: product.sql
Description.......: Find products for autocomplete
Author............: Ítalo Andrade
Date..............: 22/10/2018
Ex................:

SELECT * FROM BoneareAdm.ProductFindAutocomplete(null, '{3}');

*/

BEGIN
    RETURN QUERY
    SELECT p.id, p.name
    FROM BoneareAdm.Product p
    WHERE CASE
              WHEN pFilter IS NOT NULL
                    THEN unaccent(p.name) ILIKE '%' || unaccent(pFilter) || '%' OR
                         p.id :: TEXT = pFilter
              ELSE TRUE END
      AND (pUnless IS NULL OR p.id != ALL (pUnless))
    ORDER BY p.name
    LIMIT 7;
END;
$$
LANGUAGE plpgsql;


SELECT DeleteFunctions('BoneareAdm', 'ProductFindById');
CREATE OR REPLACE FUNCTION BoneareAdm.ProductFindById(
    pId BoneareAdm.Product.id%TYPE
)
    RETURNS TABLE(
        "id"     BoneareAdm.Product.id%TYPE,
        "name"   BoneareAdm.Product.name%TYPE,
        "weight" BoneareAdm.Product.weight%TYPE,
        "price"  BoneareAdm.Product.price%TYPE
    ) AS $$

/*
Documentation
Source file.......: product.sql
Description.......: Find a product by ID
Author............: Ítalo Andrade
Date..............: 22/10/2018
Ex................:

SELECT * FROM BoneareAdm.ProductFindById(32);

*/

BEGIN
    RETURN QUERY
    SELECT p.id, p.name, p.weight, p.price FROM BoneareAdm.Product p WHERE p.id = pId;
END;
$$
LANGUAGE plpgsql;


SELECT DeleteFunctions('BoneareAdm', 'ProductAdd');
CREATE OR REPLACE FUNCTION BoneareAdm.ProductAdd(
    pUserIdAction BoneareAdm.User.id%TYPE,
    pName         BoneareAdm.Product.name%TYPE,
    pWeight       BoneareAdm.Product.weight%TYPE,
    pPrice        BoneareAdm.Product.price%TYPE
)
    RETURNS JSONB AS $$

/*
Documentation
Source file.......: product.sql
Description.......: Add a new product
Author............: Ítalo Andrade
Date..............: 10/10/2018
Ex................:

SELECT * FROM BoneareAdm.ProductAdd(
   1,               -- pUserIdAction
   'Product Test',  -- pName
   1                -- pWeight,
   1                -- pPrice
);

*/

DECLARE
    vErrorProcedure TEXT;
    vErrorMessage   TEXT;
    vId             BoneareAdm.Product.id%TYPE;

BEGIN
    INSERT INTO BoneareAdm.Product (name, weight, price, created_by)
    VALUES (pName, pWeight, pPrice, pUserIdAction)
        RETURNING id
            INTO vId;

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


SELECT DeleteFunctions('BoneareAdm', 'ProductUpdate');
CREATE OR REPLACE FUNCTION BoneareAdm.ProductUpdate(
    pUserIdAction BoneareAdm.User.id%TYPE,
    pId           BoneareAdm.Product.id%TYPE,
    pName         BoneareAdm.Product.name%TYPE,
    pWeight       BoneareAdm.Product.weight%TYPE,
    pPrice        BoneareAdm.Product.price%TYPE
)
    RETURNS JSONB AS $$

/*
Documentation
Source file.......: product.sql
Description.......: Update a product
Author............: Ítalo Andrade
Date..............: 10/10/2018
Ex................:

SELECT * FROM BoneareAdm.ProductUpdate(
   1,               -- pUserIdAction
   12,              -- pId
   'Product Test',  -- pName
   1                -- pWeight,
   1                -- pPrice
);

*/

DECLARE
    vErrorProcedure TEXT;
    vErrorMessage   TEXT;

BEGIN
    IF NOT EXISTS(SELECT 1 FROM BoneareAdm.Product p WHERE p.id = pId)
    THEN
        RETURN
        jsonb_build_object(
            'code', 1,
            'message', 'Produto não encontrado'
        );
    END IF;

    UPDATE BoneareAdm.Product
    SET name             = pName,
        weight           = pWeight,
        price            = pPrice,
        last_update_by   = pUserIdAction,
        last_update_date = CURRENT_TIMESTAMP
    WHERE id = pId;

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


SELECT DeleteFunctions('BoneareAdm', 'ProductRemove');
CREATE OR REPLACE FUNCTION BoneareAdm.ProductRemove(
    pId BoneareAdm.Product.id%TYPE
)
    RETURNS JSONB AS $$

/*
Documentation
Source file.......: product.sql
Description.......: Remove a product
Author............: Ítalo Andrade
Date..............: 10/10/2018
Ex................:

SELECT * FROM BoneareAdm.ProductRemove(
   13   -- pId
);

*/

DECLARE
    vErrorProcedure TEXT;
    vErrorMessage   TEXT;
    vRelations      JSONB = '[]';
    vNewRelation    JSONB;

BEGIN
    IF NOT EXISTS(SELECT 1 FROM BoneareAdm.Product c WHERE c.id = pId)
    THEN
        RETURN
        jsonb_build_object(
            'code', 1,
            'message', 'Produto não encontrado'
        );
    END IF;

    SELECT to_jsonb(o) INTO vNewRelation
    FROM (SELECT o2.id, o2.description
          FROM BoneareAdm.Order_Product op
                   INNER JOIN BoneareAdm.Order o2 ON o2.id = op.order_id) o
    WHERE o.id = pId;
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

    DELETE FROM BoneareAdm.Product WHERE id = pId;

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