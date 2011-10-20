--DROP FUNCTION neighborsInCats;

CREATE FUNCTION neighborsInCats(ira double precision
                               ,idecl double precision
                               ) RETURNS TABLE (catsrcid INT
                                               ,catname VARCHAR(50)
                                               ,catsrcname VARCHAR(120)
                                               ,band INT
                                               ,freq_eff double precision
                                               ,ra double precision
                                               ,decl double precision
                                               ,ra_err double precision
                                               ,decl_err double precision
                                               ,i_peak double precision
                                               ,i_peak_err double precision
                                               ,i_int double precision
                                               ,i_int_err double precision
                                               ,distance_arcsec double precision
                                               ) as $$
BEGIN
  
  DECLARE izoneheight, itheta, ix, iy, iz double precision;
  
  SET ix = COS(rad(idecl)) * COS(rad(ira));
  SET iy = COS(rad(idecl)) * SIN(rad(ira));
  SET iz = SIN(rad(idecl));

  /* TODO: 
   * retrieve zoneheight from table ->
   * meaning add a columns to the table
  SELECT zoneheight
    INTO izoneheight
    FROM zoneheight
  ;*/
  SET izoneheight = 1;
  SET itheta = 1;

  RETURN TABLE 
  (
    SELECT catsrcid
          ,catname
          ,catsrcname
          ,band
          ,freq_eff
          ,ra
          ,decl
          ,ra_err
          ,decl_err
          ,i_peak_avg
          ,i_peak_avg_err
          ,i_int_avg
          ,i_int_avg_err
          ,3600 * deg(2 * ASIN(SQRT((ix - c1.x) * (ix - c1.x)
                                    + (iy - c1.y) * (iy - c1.y)
                                    + (iz - c1.z) * (iz - c1.z)
                                   ) / 2) 
                     ) AS distance_arcsec
      FROM catalogedsources c1
          ,catalogs c0
     WHERE c1.cat_id = c0.catid
       AND c1.x * ix + c1.y * iy + c1.z * iz > COS(rad(itheta))
       AND c1.zone BETWEEN CAST(FLOOR((idecl - itheta) / izoneheight) AS INTEGER)
                       AND CAST(FLOOR((idecl + itheta) / izoneheight) AS INTEGER)
       AND c1.ra BETWEEN ira - alpha(itheta, idecl)
                     AND ira + alpha(itheta, idecl)
       AND c1.decl BETWEEN idecl - itheta
                       AND idecl + itheta
  )
  ;

END
;
$$ language plpgsql;
