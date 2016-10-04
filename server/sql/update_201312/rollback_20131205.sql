ALTER TABLE
    dokument
DROP (
    kapsli_versioon
)
/

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
  xtee_asutus IN VARCHAR2
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
    guid
  ) VALUES (
    ADD_DOKUMENT.dokument_id,
    ADD_DOKUMENT.asutus_id,
    ADD_DOKUMENT.kaust_id,
    ADD_DOKUMENT.sisu,
    ADD_DOKUMENT.sailitustahtaeg,
    ADD_DOKUMENT.suurus,
    ADD_DOKUMENT.versioon,
    ADD_DOKUMENT.guid
  );

END;

/

-- Kompileerib kõik schema objektid, vajalik, sest tabelit muudeti
EXEC DBMS_UTILITY.compile_schema(schema => 'DVK');