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
CREATE TABLE obscatsources (
  obscatsrcid INT PRIMARY KEY,
  cat_id INT NOT NULL,
  orig_catsrcid INT NOT NULL,
  catsrcname VARCHAR(120) NULL,
  tau INT NULL,
  band INT NOT NULL,
  freq_eff double precision NOT NULL,
  zone INT NOT NULL,
  ra double precision NOT NULL,
  decl double precision NOT NULL,
  ra_err double precision NOT NULL,
  decl_err double precision NOT NULL,
  x double precision NOT NULL,
  y double precision NOT NULL,
  z double precision NOT NULL,
  margin boolean not null default false,
  det_sigma double precision NOT NULL DEFAULT 0,
  ell_a double precision NULL,
  ell_b double precision NULL,
  PA double precision NULL,
  PA_err double precision NULL,
  major double precision NULL,
  major_err double precision NULL,
  minor double precision NULL,
  minor_err double precision NULL,
  I_peak_avg double precision NULL,
  I_peak_avg_err double precision NULL,
  I_peak_min double precision NULL,
  I_peak_min_err double precision NULL,
  I_peak_max double precision NULL,
  I_peak_max_err double precision NULL,
  I_int_avg double precision NULL,
  I_int_avg_err double precision NULL,
  I_int_min double precision NULL,
  I_int_min_err double precision NULL,
  I_int_max double precision NULL,
  I_int_max_err double precision NULL,
  frame VARCHAR(20) NULL,
  UNIQUE (cat_id
         ,orig_catsrcid)
)
;
