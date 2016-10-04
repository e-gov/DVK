create or replace
procedure Get_DocumentsSentTo(
    organization_id in number,
    folder_id in number,
    user_id in number,
    result_limit in number,
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  *
    from    dokument d,
    (
        -- Dokumendid, mis adresseeriti päringu teostanud isikule
        select  t1.dokument_id
        from    transport t1, vastuvotja v1, isik i1
        where   t1.transport_id = v1.transport_id
                and v1.asutus_id = Get_DocumentsSentTo.organization_id
                and i1.kood = v1.isikukood
                and i1.i_id = Get_DocumentsSentTo.user_id
                and v1.staatus_id = 101

        -- Dokumendid, mis adresseeriti päringu teostaja ametikohale
        union
        select  t2.dokument_id
        from    transport t2, vastuvotja v2
        where   t2.transport_id = v2.transport_id
                and v2.asutus_id = Get_DocumentsSentTo.organization_id
                and v2.allyksus_id is null
                and v2.isikukood is null
                and v2.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i2, ametikoht_taitmine akt2, ametikoht ak2
                    where   i2.i_id = Get_DocumentsSentTo.user_id
                            and ak2.ametikoht_id = v2.ametikoht_id
                            and akt2.i_id = i2.i_id
                            and ak2.ametikoht_id = akt2.ametikoht_id
                            and akt2.peatatud = 0
                            and ak2.asutus_id = v2.asutus_id
                            and nvl(akt2.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt2.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak2.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak2.kuni, add_months(sysdate, 1)) > sysdate
                )

        -- Dokumendid, mis adresseeriti päringu teostaja allüksusele
        union
        select  t3.dokument_id
        from    transport t3, vastuvotja v3
        where   t3.transport_id = v3.transport_id
                and v3.asutus_id = Get_DocumentsSentTo.organization_id
                and v3.ametikoht_id is null
                and v3.isikukood is null
                and v3.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i3, ametikoht_taitmine akt3, ametikoht ak3
                    where   i3.i_id = Get_DocumentsSentTo.user_id
                            and ak3.allyksus_id = v3.allyksus_id
                            and akt3.i_id = i3.i_id
                            and ak3.ametikoht_id = akt3.ametikoht_id
                            and akt3.peatatud = 0
                            and ak3.asutus_id = v3.asutus_id
                            and nvl(akt3.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt3.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak3.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak3.kuni, add_months(sysdate, 1)) > sysdate
                )

        -- Dokumendid, mis adresseeriti päringu teostaja ametikohale
        -- päringu teostaja allüksuses (vastupidine juhtum oleks, et
        -- dokument saadeti mõnele teisele ametikohale samas allüksuses).
        union
        select  t4.dokument_id
        from    transport t4, vastuvotja v4
        where   t4.transport_id = v4.transport_id
                and v4.asutus_id = Get_DocumentsSentTo.organization_id
                and v4.isikukood is null
                and v4.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i4, ametikoht_taitmine akt4, ametikoht ak4
                    where   i4.i_id = Get_DocumentsSentTo.user_id
                            and ak4.allyksus_id = v4.allyksus_id
                            and ak4.ametikoht_id = v4.ametikoht_id
                            and akt4.i_id = i4.i_id
                            and ak4.ametikoht_id = akt4.ametikoht_id
                            and akt4.peatatud = 0
                            and ak4.asutus_id = v4.asutus_id
                            and nvl(akt4.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt4.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak4.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak4.kuni, add_months(sysdate, 1)) > sysdate
                )

        -- Juhul kui tegemist on asutuse administraatoriga
        union
        select  t5.dokument_id
        from    transport t5, vastuvotja v5
        where   t5.transport_id = v5.transport_id
                and v5.asutus_id = Get_DocumentsSentTo.organization_id
                and v5.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i5, ametikoht_taitmine akt5, ametikoht ak5, oigus_antud oa5
                    where   i5.i_id = Get_DocumentsSentTo.user_id
                            and akt5.i_id = i5.i_id
                            and ak5.ametikoht_id = akt5.ametikoht_id
                            and oa5.ametikoht_id = akt5.ametikoht_id
                            and akt5.peatatud = 0
                            and oa5.peatatud = 0
                            and oa5.asutus_id = v5.asutus_id
                            and ak5.asutus_id = v5.asutus_id
                            and nvl(akt5.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt5.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(oa5.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(oa5.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak5.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak5.kuni, add_months(sysdate, 1)) > sysdate
                            and lower(trim(oa5.roll)) = 'dhl: asutuse administraator'
                )
    ) rights_filter
    where   d.dokument_id = rights_filter.dokument_id
            and
            (
                Get_DocumentsSentTo.folder_id is null
                or d.kaust_id = Get_DocumentsSentTo.folder_id
            )
            and rownum <= Get_DocumentsSentTo.result_limit;
end;
/
