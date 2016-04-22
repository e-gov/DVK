------------------------------------------------------------------------
-- Versioon 1.7.1 - 2013/12
------------------------------------------------------------------------

create or replace
PROCEDURE ADD_DOKUMENT(
  dokument_id IN NUMBER,
  asutus_id IN NUMBER,
  kaust_id IN NUMBER,
  sisu IN CLOB,
  sailitustahtaeg IN DATE,
  suurus IN NUMBER,
  versioon IN NUMBER,
  guid IN VARCHAR2,
  xtee_isikukood IN VARCHAR2,
  xtee_asutus IN VARCHAR2,
  kapsli_versioon IN VARCHAR2
) AS

BEGIN

  -- Set session scope variables
  DVKLOG.xtee_isikukood := ADD_DOKUMENT.xtee_isikukood;
  DVKLOG.xtee_asutus := ADD_DOKUMENT.xtee_asutus;

  INSERT INTO dokument (
    dokument_id,
    asutus_id,
    kaust_id,
    sisu,
    sailitustahtaeg,
    suurus,
    versioon,
    guid,
    kapsli_versioon
  ) VALUES (
    ADD_DOKUMENT.dokument_id,
    ADD_DOKUMENT.asutus_id,
    ADD_DOKUMENT.kaust_id,
    ADD_DOKUMENT.sisu,
    ADD_DOKUMENT.sailitustahtaeg,
    ADD_DOKUMENT.suurus,
    ADD_DOKUMENT.versioon,
    ADD_DOKUMENT.guid,
    ADD_DOKUMENT.kapsli_versioon
  );

END;

/

ALTER TABLE
    dokument
ADD (
    kapsli_versioon varchar2(5)
);

/

COMMENT ON COLUMN dokument.kapsli_versioon IS 'Kapsli versioon.'
/

-- Kompileerib kõik schema objektid, vajalik, sest tabelit muudeti
EXEC DBMS_UTILITY.compile_schema(schema => 'DVK');