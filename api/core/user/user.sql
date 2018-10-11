/**/


SELECT public.DeleteFunctions('BoneareAdm', 'UserSignIn');
CREATE OR REPLACE FUNCTION BoneareAdm.UserSignIn(
    pId       INTEGER,
    pEmail    BoneareAdm.User.email%TYPE,
    pPassword BoneareAdm.User.password%TYPE
)
    RETURNS TABLE(
        "id"              BoneareAdm.User.id%TYPE,
        "color"           BoneareAdm.User.id%TYPE,
        "name"            BoneareAdm.User.name%TYPE,
        "email"           BoneareAdm.User.email%TYPE,
        "picture"         TEXT,
        "correctPassword" BOOLEAN
    ) AS $$

/*
Documentation
Source file.......: User.sql
Description.......: Sign in by credentials or a token
Author............: Ítalo Andrade
Date..............: 12/09/2018
Ex................:

SELECT * FROM BoneareAdm.UserSignIn(null, 'test@test.com', 'test'); -- Credentials
SELECT * FROM BoneareAdm.UserSignIn(1, null, null); -- Token

*/

DECLARE
    vS3Bucket BoneareAdm.Settings.s3Bucket%TYPE;

BEGIN
    vS3Bucket = (SELECT s.s3Bucket FROM BoneareAdm.Settings s);

    RETURN QUERY
    SELECT u.id,
           u.id                                            color,
           u.name,
           u.email,
           CASE
               WHEN u.picture IS NOT NULL
                     THEN vS3Bucket || 'user/' || u.id|| '36x36/' || u.picture
               END                                         picture,
           (u.password = public.crypt(pPassword, u.passwordHash)) correctPassword
    FROM BoneareAdm.User u
    WHERE CASE
              WHEN pId IS NULL
                    THEN u.email = pEmail
              ELSE u.id = pId END;
END;
$$
LANGUAGE plpgsql;


/**/