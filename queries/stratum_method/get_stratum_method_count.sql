SELECT COUNT(*)
  FROM stratummethod
  LEFT JOIN stratumtype USING (stratummethod_id)
