DROP FUNCTION valuePosErrCircles;

/*+-------------------------------------------------------------------+
 *| This function quantifies a source intersection by a weight number.|
 *| If two sources do not intersect the weight is -1, if there is     |
 *| the weight is the solid angle of the intersection area divided by |
 *| the area of the smallest positional error.                        |
 *| This function uses the ra and decl, and their errors in arcsec.   |
 *| To take ra inflation into account, we use the function alpha, so  |
 *| the ra + alpha(ra_err) are correctly set.                         |
 *|                                                                   |
 *| As an example the case where source 1 is SOUTHEAST of source 2:   |
 *|                                                                   |
 *|              +---------+                                          |
 *|              |  tr     |                                          |
 *|      +-------+---o* 2  |< decl_max                                |
 *|      |       |   |     |                ^                         |
 *|      |       o---+-----+< decl_min      |                         |
 *|      |    1* bl  |                     decl                       |
 *|      |           |                      |                         |
 *|      |           |                                                |
 *|      +-----------+                                                |
 *|              ^   ^                                                |
 *|          ra_max  ra_min                                           |
 *|                                                                   |
 *|                     <-- ra --                                     |
 *|                                                                   |
 *+-------------------------------------------------------------------+
 *|                                                                   |
 *+-------------------------------------------------------------------+
 */
CREATE FUNCTION valuePosErrCircles(i1ra double precision
                                  ,i1decl double precision
                                  ,i1ra_err double precision
                                  ,i1decl_err double precision
                                  ,i2ra double precision
                                  ,i2decl double precision
                                  ,i2ra_err double precision
                                  ,i2decl_err double precision
                                  ) RETURNS double precision as $$
DECLARE avg_radius double precision;
declare distance double precision;
declare val double precision;
BEGIN
  
  /* Units in arcsec */

  avg_radius := SQRT(i1ra_err * i1ra_err + i2ra_err * i2ra_err
                       + i1decl_err * i1decl_err + i2decl_err * i2decl_err
                       );

  distance := 3600 * DEGREES(2 * ASIN(SQRT(POWER((COS(RADIANS(i1decl)) * COS(RADIANS(i1ra))
                                                    - COS(RADIANS(i2decl)) * COS(RADIANS(i2ra))
                                                    ), 2)
                                             + POWER((COS(RADIANS(i1decl)) * SIN(RADIANS(i1ra))
                                                    - COS(RADIANS(i2decl)) * SIN(RADIANS(i2ra))
                                                    ), 2)
                                             + POWER((SIN(RADIANS(i1decl))
                                                    - SIN(RADIANS(i2decl))
                                                    ), 2)
                                             ) / 2));

  val := distance / avg_radius;
  RETURN val;

END;
$$ language plpgsql;
