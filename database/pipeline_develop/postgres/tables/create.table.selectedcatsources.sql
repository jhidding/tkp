/**
 * This table contains the known sources that were detected previously, 
 * either by LOFAR itself or other instruments. 
 * It is a selection from the table containing all the catalog 
 * sources (in the catlogue area). 
 * Every observation has its field(s) of view and for this all the 
 * known sources are collected. This table will be loaded from the 
 * catalog table in the catalog database before every observation.
 * This table will be used to load the sources table 
 * and will not be touched any more during an observation.
 * Fluxes are in Jy, ra, decl, ra_err and decl_err in degrees.
 * PA, major, minor in degrees
 *
 * TODO: Probably it is better not te set catsrcid to auto_incr,
 * because we will copy them from the catalog database.
 */
CREATE TABLE selectedcatsources (
  catsrc_id INT NOT NULL,
  cat_id INT NOT NULL,
  zone INT NOT NULL,
  ra double precision NOT NULL,
  decl double precision NOT NULL,
  ra_err double precision NOT NULL,
  decl_err double precision NOT NULL,
  x double precision NOT NULL,
  y double precision NOT NULL,
  z double precision NOT NULL,
  margin boolean not null default false,
  I_peak double precision NULL,
  I_peak_err double precision NULL,
  I_int double precision NULL,
  I_int_err double precision NULL
);
