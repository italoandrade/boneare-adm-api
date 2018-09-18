/**/


SELECT DeleteFunctions('BoneareAdm', 'ClientListAll');
CREATE OR REPLACE FUNCTION BoneareAdm.ClientListAll(
    pFilter     VARCHAR(200),
    pSortColumn VARCHAR(100),
    pSortOrder  VARCHAR(100),
    pPageNumber INTEGER,
    pPageSize   INTEGER
)
    RETURNS TABLE(
        "lineCount" BIGINT,
        "id"        BoneareAdm.Client.id%TYPE,
        "name"      BoneareAdm.Client.name%TYPE
    ) AS $$

/*
Documentation
Source file.......: User.sql
Description.......: Sign in by credentials or a token
Author............: Ítalo Andrade
Date..............: 12/09/2018
Ex................:

SELECT * FROM BoneareAdm.ClientListAll(null, null, null, 1, 10);

*/

BEGIN
    RETURN QUERY
    SELECT COUNT(1) OVER (PARTITION BY 1) lineCount, c.id, c.name
    FROM BoneareAdm.Client c
    WHERE CASE
              WHEN pFilter IS NOT NULL
                    THEN unaccent(c.name) ILIKE '%' || unaccent(pFilter) || '%' OR
                         c.id :: TEXT = pFilter
              ELSE TRUE END
    ORDER BY (iif(pSortColumn = 'id' AND pSortOrder = 'asc', c.id, NULL)) ASC,
             (iif(pSortColumn = 'id' AND pSortOrder = 'desc', c.id, NULL)) DESC,
             (iif(pSortColumn = 'name' AND pSortOrder = 'asc', c.name, NULL)) ASC,
             (iif(pSortColumn = 'name' AND pSortOrder = 'desc', c.name, NULL)) DESC,
             (COALESCE(c.last_update_date, c.creation_date)) DESC
    LIMIT iif(pPageSize > 0 AND pPageNumber >= 0, pPageSize, NULL)
    OFFSET iif(pPageSize > 0 AND pPageNumber >= 0, pPageNumber * pPageSize, NULL);
END;
$$
LANGUAGE plpgsql;


/**/