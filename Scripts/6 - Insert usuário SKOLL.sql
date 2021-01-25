CREATE OR REPLACE FUNCTION USERADMINSKOLL() RETURNS void AS 
$useradminskoll$
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE USERNAME = 'skolladmin') THEN
        INSERT INTO usuario (nome, username, email, senha, ativo) values ('SKOLL ADMIN', 'skolladmin', 'skoll.uepg@gmail.com', 'ae497acaa685e822b04965787f53d1730994134e', true);
    END IF;
END
$useradminskoll$
LANGUAGE plpgsql;

select USERADMINSKOLL()

--Sk0ll@Adm1n;;