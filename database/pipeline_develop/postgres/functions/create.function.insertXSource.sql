--DROP FUNCTION insertXSource;

/*+------------------------------------------------------------------+
 *| This procedure                                                   |
 *| (1) adds an extracted source to the extractedsources table.      |
 *| (2) tries to associate the source with sources previously        |
 *|     detected for this data set (same ds_id)                      |
 *| (3) also tries to associate the source with cataloged sources    |
 *| (4) If found, an association will be added to the                |
 *|     associatedsources table.                                     |
 *+------------------------------------------------------------------+
 *| Input params:                                                    |
 *|   iimage_id  : the image_id from which this source was extracted |
 *|   ira        : RA of extracted source (in degrees)               |
 *|   idecl      : dec of extracted source (in degrees)              |
 *|   ira_err    : 1 sigma error on RA (in degrees)                  |
 *|   idecl_err  : 1 sigma error on dec (in degrees)                 |
 *|   iI_peak    : Peak flux of extracted source (in Jansky)         |
 *|   iI_peak_err: Error on peak flux of extracted source (in Jansky)|
 *|   iI_int     : Integrated flux of extracted source (in Jansky)   |
 *|   iI_int_err : Error on int. flux of extracted source (in Jansky)|
 *|   idet_sigma : The detection level of the extracted source       |
 *|                (in sigma)                                        |
 *+------------------------------------------------------------------+
 *| Used variables:                                                  |
 *| itheta: this is the radius (in degrees) of the circular area     |
 *|         centered at (ra,decl) of the current (input) source. All |
 *|         sources found within this area will be inspected for     |
 *|         association.                                             |
 *|         The difficult part is how to determine what is the best  |
 *|         value for itheta. Will it depend on the source density,  |
 *|         which depends on int.time, freq, or is it sufficient to  |
 *|         simply set it to a default value of f.ex. 1 (degree)?    |
 *|         For now, we default it to 1 (degree).                    |
 *|                                                                  |
 *+------------------------------------------------------------------+
 *| TODO: Also insert margin records                                 |
 *+------------------------------------------------------------------+
 *|                       Bart Scheers                               |
 *|                        2009-02-18                                |
 *+------------------------------------------------------------------+
 *| 2009-02-18                                                       |
 *| Based on AssociateSource() from create.database.sql              |
 *+------------------------------------------------------------------+
 *| Open Questions:                                                  |
 *|                                                                  |
 *+------------------------------------------------------------------+
 */
CREATE FUNCTION insertXSource(iimage_id INT
                             ,ira double precision
                             ,idecl double precision
                             ,ira_err double precision
                             ,idecl_err double precision
                             ,iI_peak double precision
                             ,iI_peak_err double precision
                             ,iI_int double precision
                             ,iI_int_err double precision
                             ,idet_sigma double precision
                             ) RETURNS INT as $$
  DECLARE izone, ixtrsrcid, oxtrsrcid INT;
  DECLARE ix, iy, iz, ixy double precision;
  DECLARE izoneheight double precision;
BEGIN


  SELECT zoneheight
    INTO izoneheight
    FROM zoneheight
  ;

  izone := FLOOR(idecl/izoneheight);
  ixy := COS(RADIANS(idecl));
  ix := ixy * COS(RADIANS(ira));
  iy := ixy * SIN(RADIANS(ira));
  iz := SIN(RADIANS(idecl));

  SELECT NEXT VALUE FOR seq_extractedsources INTO ixtrsrcid;

  INSERT INTO extractedsources
    (xtrsrcid
    ,image_id
    ,zone
    ,ra
    ,decl
    ,ra_err
    ,decl_err
    ,x
    ,y
    ,z
    ,det_sigma
    ,I_peak
    ,I_peak_err
    ,I_int
    ,I_int_err
    ) 
  VALUES
    (ixtrsrcid
    ,iimage_id
    ,izone
    ,ira
    ,idecl
    ,ira_err * 3600
    ,idecl_err * 3600
    ,ix
    ,iy
    ,iz
    ,idet_sigma
    ,iI_peak
    ,iI_peak_err
    ,iI_int
    ,iI_int_err
    )
  ;

  oxtrsrcid := ixtrsrcid;
  RETURN oxtrsrcid;
 
END;
$$ language plpgsql;
