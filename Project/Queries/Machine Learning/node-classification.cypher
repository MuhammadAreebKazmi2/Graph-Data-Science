MATCH (v:Victim)
SET v.Vict_Descent_encoded = 
  CASE v.`Vict Descent`
    WHEN 'W' THEN 0
    WHEN 'H' THEN 1
    WHEN 'A' THEN 2
    WHEN 'B' THEN 3
    WHEN 'O' THEN 4
    WHEN 'X' THEN 5
    WHEN 'C' THEN 6
    WHEN 'F' THEN 7
    WHEN 'K' THEN 8
    WHEN 'I' THEN 9
    WHEN 'V' THEN 10
    WHEN 'Z' THEN 11
    WHEN 'J' THEN 12
    WHEN 'P' THEN 13
    ELSE 14  // Handle any other values if present
  END;

