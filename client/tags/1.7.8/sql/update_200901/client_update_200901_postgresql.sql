set search_path = dvk, pg_catalog;

alter table only dhl_settings
    add column subdivision_code integer null,
    add column occupation_code integer null;
