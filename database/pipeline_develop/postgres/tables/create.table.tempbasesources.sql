/* This table contains the unique sources that were detected
 * during an observation.
 * TODO: The resolution element (from images table) is not implemented yet
 * Extractedsources not in this table are appended when there is no positional match
 * or when a source was detected in a higher resolution image.
 */
--DROP TABLE tempbasesources;
CREATE TABLE tempbasesources 
  (xtrsrc_id INT NOT NULL
  /*,ds_id INT NOT NULL
  ,image_id INT NOT NULL
  ,zone INT NOT NULL
  ,ra double precision NOT NULL
  ,decl double precision NOT NULL
  ,ra_err double precision NOT NULL
  ,decl_err double precision NOT NULL
  ,x double precision NOT NULL
  ,y double precision NOT NULL
  ,z double precision NOT NULL
  ,margin boolean not null default false
  ,beam_semimaj double precision NULL
  ,beam_semimin double precision NULL
  ,beam_pa double precision NULL*/
  ,datapoints INT NULL
  ,I_peak_sum double precision NULL
  ,I_peak_sq_sum double precision NULL
  ,weight_peak_sum double precision NULL
  ,weight_I_peak_sum double precision NULL
  ,weight_I_peak_sq_sum double precision NULL
  )
;

