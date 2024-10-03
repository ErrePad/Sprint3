-- ***********************************************    SPRINT 3    ***************************************************
-- Alumno: Rodrigo Padilla
-- Revisado por : Dionisio Vasquez
-- +++++++++++++++++++++++++++++++++++++++++++++++    NIVEL 1   +++++++++++++++++++++++++++++++++++++++++++++++++++++
-- EJERCICIO 1

-- Crear tabla CREDIT CARD
CREATE TABLE IF NOT EXISTS CREDIT_CARD (
        id VARCHAR(8) PRIMARY KEY,
        iban VARCHAR(100),
        pan VARCHAR(100), 
        pin INT, -- debe ser VARCHA por si comienza por 0
        cvv INT, -- debe ser VARCHAR por el cero 0
        expiring_date VARCHAR(8)
    );

-- agrego el FK apuntando a credit_card
ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

-- agregar EL DIAGRAMA

-- EJERCICIO 2
-- Actualizar registro erroneo CcU-2938
UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id = 'CcU-2938';

-- seleccionar posteriormente que quedo el cambio de manera correcta
SELECT * FROM CREDIT_CARD
WHERE ID = 'CcU-2938';

-- EJERCICIO 3 
-- Ingresar un registro a la TABLA TRANSACTION

-- DATOS A ACTUALIZAR
-- Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
-- credit_card_id	CcU-9999
-- company_id	b-9999
-- user_id	9999
-- lato	829.999
-- longitud	-117.999
-- amunt	111.11
-- declined	0

-- se crean registros de tablas relacionadas previo al INSERT solicitado para NO generar inconsistencia y respetando la R.Integridad
INSERT INTO COMPANY 
SELECT 'b-9999', 'La empresa nueva', B.PHONE, B.EMAIL, 'Belgium' FROM COMPANY B
WHERE B.ID = 'b-2618';

-- se crea la tarjeta de credito
INSERT INTO CREDIT_CARD
SELECT 'CcU-9999', 'TR999972558313545667129999', 9999, B.CVV, B.EXPIRING_DATE, B.FECHA_ACTUAL FROM CREDIT_CARD B
WHERE B.ID = 'CcU-4856';

-- Se realiza el INSERT con los datos solicitados en el Ejercicio 3
INSERT INTO TRANSACTION (ID, CREDIT_CARD_ID, COMPANY_ID, USER_ID, LAT, LONGITUDE, TIMESTAMP, AMOUNT, DECLINED)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, '2024-09-19', 111.11, 0);

-- comprueba el insert
SELECT * FROM TRANSACTION WHERE ID = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

-- EJERCICIO 4
-- Elimninar la columna PAN de la TABLA CREDIT_CARD
ALTER TABLE CREDIT_CARD DROP COLUMN PAN;

-- se comprueba la eliminación de columna
SELECT * FROM CREDIT_CARD;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++ NIVEL 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- EJERCICIO 1
-- Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.
DELETE FROM TRANSACTION WHERE ID = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

-- comprobación de la eliminación
SELECT * FROM TRANSACTION WHERE ID = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

-- EJERCICIO 2
-- VistaMarketing que contingui la següent informació: Nom de la companyia. Telèfon de contacte. País de residència.
-- Mitjana de compra realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.
-- 

-- VOLVER A CREAR EL VIEW, CONSIDERAR EL DECLINE = 0 ?, 
CREATE VIEW VistaMarketing
	AS
		SELECT C.COMPANY_NAME NOMBRE_EMPRESA, C.PHONE TELEFONO, C.COUNTRY PAIS, AVG(T.AMOUNT) MEDIA_COMPRA
		FROM COMPANY C 
		JOIN TRANSACTION T
			ON C.ID = T.COMPANY_ID
		GROUP BY 1, 2, 3
		ORDER BY MEDIA_COMPRA DESC;

-- se despliega la vista
SELECT * FROM VISTAMARKETING;

-- EJERCICIO 3
-- Filtrar la vista por PAIS = 'Germany'
SELECT * FROM VISTAMARKETING
WHERE PAIS = 'Germany';


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++ NIVEL 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- EJERCICIO 1
-- representar modelo de datos actualizado

-- eliminar columna website. de la tabla  COMPANY
ALTER TABLE COMPANY DROP COLUMN WEBSITE;

-- agregar la columna FECHA_ACTUAL
ALTER TABLE CREDIT_CARD ADD COLUMN fecha_actual DATE;

-- Se crea nuevamente la tabla USER --> DATA_USER, se prefirio crear con el nombre nuevo de USER --> DATA_USER

CREATE TABLE IF NOT EXISTS data_user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        personal_email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255),
        FOREIGN KEY(id) REFERENCES transaction(user_id)        
    );


-- elimino un FK por estar mal creada
ALTER TABLE data_user DROP FOREIGN KEY data_user_ibfk_1;

-- elimino el INDEX
DROP INDEX IDX_USER_ID ON TRANSACTION;

-- creo un FK fuera del CREATE TABLE para corregir la relación entre TRANSACTION Y DATA_USER, debe ser de hijo referenciando al padre por ser 1 a N
ALTER TABLE TRANSACTION
ADD CONSTRAINT transac_fkuser_const FOREIGN KEY (USER_ID) REFERENCES DATA_USER(ID);

-- EJERCICIO 2 
-- Crear una vista
DROP VIEW INFORME_TECNICO;

CREATE VIEW INFORME_TECNICO AS
SELECT 
    T.ID ID_TRANSACCION, U.NAME NOMBRE_USER, U.SURNAME APELLIDO_USER, CC.IBAN IBAN_TARJETA, C.COMPANY_NAME EMPRESA
FROM
    TRANSACTION T
        LEFT JOIN COMPANY C ON C.ID = T.COMPANY_ID
        LEFT JOIN DATA_USER U ON U.ID = T.USER_ID
        LEFT JOIN CREDIT_CARD CC ON CC.ID = T.CREDIT_CARD_ID
ORDER BY T.ID DESC;

-- compruebo la vista Informe Técnico    
SELECT * FROM INFORME_TECNICO;

