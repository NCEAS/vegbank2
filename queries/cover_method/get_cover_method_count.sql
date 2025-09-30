SELECT COUNT(*)
  FROM covermethod
  LEFT JOIN coverindex cv USING (covermethod_id)
