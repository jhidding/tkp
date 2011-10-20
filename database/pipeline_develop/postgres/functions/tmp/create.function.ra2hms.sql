--DROP FUNCTION IF EXISTS ra2hms;

/**
 * This function converts ra from degrees into HHMMSS format.
 * The input format must be double precision:
 */
CREATE FUNCTION ra2hms(iraDEG double precision) RETURNS VARCHAR(12) as $$

BEGIN

  DECLARE raHHnum, raMMnum, raSSnum double precision;
  DECLARE raHHstr, raMMstr VARCHAR(2); 
  DECLARE raSSstr VARCHAR(6);
  
  SET raHHnum = TRUNCATE(iraDEG / 15, 2);
  SET raMMnum = TRUNCATE((iraDEG / 15 - raHHnum) * 60, 2);
  SET raSSnum = ROUND((((iraDEG / 15 - raHHnum) * 60) - raMMnum) * 60, 3);
  
  IF raHHnum < 10 THEN
    SET raHHstr = CONCAT('0', raHHnum);
  ELSE 
    SET raHHstr = CAST(raHHnum AS VARCHAR(2));  
  END IF;

  IF raMMnum < 10 THEN
    SET raMMstr = CONCAT('0', raMMnum);
  ELSE 
    SET raMMstr = CAST(raMMnum AS VARCHAR(2));  
  END IF;

  IF raSSnum < 10 THEN
    SET raSSstr = CAST(CONCAT('0', TRUNCATE(raSSnum, 5)) AS VARCHAR(6));
  ELSE 
    SET raSSstr = CAST(TRUNCATE(raSSnum,6) AS VARCHAR(6));  
  END IF;

  RETURN CONCAT(raHHstr, CONCAT(':', CONCAT(raMMstr, CONCAT(':', raSSstr))));

END;
$$ language plpgsql;
