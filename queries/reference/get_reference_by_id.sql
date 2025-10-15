SELECT 'rf.' || rf.reference_id AS rf_code,
       rf.shortname AS short_name,
       rf.fulltext AS full_citation,
       rf.referencetype AS reference_type,
       rf.title AS title,
       rf.pubdate AS publication_date,
       rf.totalpages AS total_pages,
       rf.publisher AS publisher,
       rf.publicationplace AS publication_place,
       rf.degree AS degree,
       rf.isbn AS isbn,
       rf.url AS url,
       rf.doi AS doi,
       rj.journal AS journal
  FROM reference rf
  LEFT JOIN referencejournal rj USING (referencejournal_id)
  WHERE rf.reference_id = %s
