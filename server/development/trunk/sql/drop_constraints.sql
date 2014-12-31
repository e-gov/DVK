ALTER TABLE allkiri DROP CONSTRAINT allkiri_dokument_id_fkey;
ALTER TABLE allyksus DROP CONSTRAINT allyksus_asutus_id_fkey;
ALTER TABLE allyksus DROP CONSTRAINT allyksus_vanem_id_fkey;
ALTER TABLE vahendaja DROP CONSTRAINT vahendaja_transport_id_fkey;
ALTER TABLE vahendaja DROP CONSTRAINT vahendaja_asutus_id_fkey;
ALTER TABLE vahendaja DROP CONSTRAINT vahendaja_ametikoht_id_fkey;
ALTER TABLE oigus_antud DROP CONSTRAINT oigus_antud_asutus_id_fkey;
ALTER TABLE oigus_antud DROP CONSTRAINT oigus_antud_ametikoht_id_fkey;
ALTER TABLE ametikoht DROP CONSTRAINT ametikoht_allyksus_id_fkey;
ALTER TABLE ametikoht DROP CONSTRAINT ametikoht_asutus_id_fkey;
ALTER TABLE klassifikaator DROP CONSTRAINT klassifikaator_tyyp_id_fkey;
ALTER TABLE dokumendi_fail DROP CONSTRAINT dokumendi_fail_document_id_fkey;
ALTER TABLE vastuvotja_mall DROP CONSTRAINT vastuvotja_mall_saatmisviis_id_fkey;
ALTER TABLE vastuvotja_mall DROP CONSTRAINT vastuvotja_mall_asutus_id_fkey;
ALTER TABLE vastuvotja_mall DROP CONSTRAINT vastuvotja_mall_ametikoht_id_fkey;
ALTER TABLE vastuvotja_mall DROP CONSTRAINT vastuvotja_mall_allyksus_id_fkey;
ALTER TABLE saatja DROP CONSTRAINT saatja_transport_id_fkey;
ALTER TABLE saatja DROP CONSTRAINT saatja_asutus_id_fkey;
ALTER TABLE saatja DROP CONSTRAINT saatja_ametikoht_id_fkey;
ALTER TABLE vastuvotja DROP CONSTRAINT vastuvotja_transport_id_fkey;
ALTER TABLE vastuvotja DROP CONSTRAINT vastuvotja_saatmisviis_id_fkey;
ALTER TABLE vastuvotja DROP CONSTRAINT vastuvotja_staatus_id_fkey;
ALTER TABLE vastuvotja DROP CONSTRAINT vastuvotja_asutus_id_fkey;
ALTER TABLE vastuvotja DROP CONSTRAINT vastuvotja_ametikoht_id_fkey;
ALTER TABLE vastuvotja DROP CONSTRAINT vastuvotja_vastuvotja_staatus_id_fkey;
ALTER TABLE staatuse_ajalugu DROP CONSTRAINT staatuse_ajalugu_vastuvotja_id_fkey;
ALTER TABLE staatuse_ajalugu DROP CONSTRAINT staatuse_ajalugu_staatus_id_fkey;
ALTER TABLE dynaamilised_metaandmed DROP CONSTRAINT dynaamilised_metaandmed_dokument_fkey;
ALTER TABLE ametikoht_taitmine DROP CONSTRAINT ametikoht_taitmine_i_id_fkey;
ALTER TABLE ametikoht_taitmine DROP CONSTRAINT ametikoht_taitmine_ametikoht_id_fkey;
ALTER TABLE asutus DROP CONSTRAINT asutus_ks_asutus_id_fkey;
ALTER TABLE dokumendi_ajalugu DROP CONSTRAINT dokumendi_ajalugu_dokument_id_fkey;
ALTER TABLE dokument DROP CONSTRAINT dokument_asutus_id_fkey;
ALTER TABLE dokument DROP CONSTRAINT dokument_kaust_id_fkey;
ALTER TABLE dokument DROP CONSTRAINT dokument_eelmise_versiooni_id_fkey;
ALTER TABLE kaust DROP CONSTRAINT kaust_ylemkaust_id_fkey;
ALTER TABLE kaust DROP CONSTRAINT kaust_asutus_id_fkey;
ALTER TABLE oigus_objektile DROP CONSTRAINT oigus_objektile_asutus_id_fkey;
ALTER TABLE oigus_objektile DROP CONSTRAINT oigus_objektile_ametikoht_id_fkey;
ALTER TABLE oigus_objektile DROP CONSTRAINT oigus_objektile_dokument_id_fkey;
ALTER TABLE oigus_objektile DROP CONSTRAINT oigus_objektile_kaust_id_fkey;
ALTER TABLE transport DROP CONSTRAINT transport_dokument_id_fkey;
ALTER TABLE transport DROP CONSTRAINT transport_staatus_id_fkey;
ALTER TABLE dokumendi_metaandmed DROP CONSTRAINT dokumendi_metaandmed_id_fkey;

ALTER TABLE allkiri DROP CONSTRAINT allkiri_id_pkey;
ALTER TABLE allyksus DROP CONSTRAINT allyksus_pkey_id_pkey;
ALTER TABLE vahendaja DROP CONSTRAINT vahendaja_id_pkey;
ALTER TABLE oigus_antud DROP CONSTRAINT oigus_antud_id_pkey;
ALTER TABLE ametikoht DROP CONSTRAINT ametikoht_id_pkey;
ALTER TABLE dokumendi_fragment DROP CONSTRAINT dokumendi_fragment_fragment_id_pkey;
ALTER TABLE vastuvotja_staatus DROP CONSTRAINT vastuvotja_staatus_id_pkey;
ALTER TABLE klassifikaator DROP CONSTRAINT klassifikaator_id_pkey;
ALTER TABLE dokumendi_fail DROP CONSTRAINT dokumendi_fail_id_pkey;
ALTER TABLE vastuvotja_mall DROP CONSTRAINT vastuvotja_mall_id_pkey;
ALTER TABLE saatja DROP CONSTRAINT saatja_id_pkey;
ALTER TABLE vastuvotja DROP CONSTRAINT vastuvotja_id_pkey;
ALTER TABLE staatuse_ajalugu DROP CONSTRAINT staatuse_ajalugu_id_pkey;
ALTER TABLE dynaamilised_metaandmed DROP CONSTRAINT dynaamilised_metaandmed_pkey;
ALTER TABLE isik DROP CONSTRAINT isiki_id_pkey;
ALTER TABLE ametikoht_taitmine DROP CONSTRAINT ametikoht_taitmine_id_pkey;
ALTER TABLE asutus DROP CONSTRAINT asutus_registrikood_un;
ALTER TABLE asutus DROP CONSTRAINT asutus_id_pkey;
ALTER TABLE dokumendi_ajalugu DROP CONSTRAINT dokumendi_ajalugu_id_pkey;
ALTER TABLE dokument DROP CONSTRAINT dokumendi_id_pkey;
ALTER TABLE ehak DROP CONSTRAINT ehak_id_pkey;
ALTER TABLE kaust DROP CONSTRAINT kaust_id_pkey;
ALTER TABLE oigus_objektile DROP CONSTRAINT oigus_objektile_id_pkey;
ALTER TABLE transport DROP CONSTRAINT transport_id_pkey;
ALTER TABLE konversioon DROP CONSTRAINT konversioon_id_pkey;
ALTER TABLE klassifikaatori_tyyp DROP CONSTRAINT klassifikaatori_id_pkey;
ALTER TABLE logi DROP CONSTRAINT logi_id_pkey;
ALTER TABLE server DROP CONSTRAINT server_id_pkey;
ALTER TABLE dokumendi_metaandmed DROP CONSTRAINT dokument_meta_id_pkey;