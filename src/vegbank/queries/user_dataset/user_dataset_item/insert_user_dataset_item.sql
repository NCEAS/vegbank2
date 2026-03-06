MERGE INTO userdatasetitem dst
USING user_dataset_item_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    itemaccessioncode,
    itemdatabase,
    itemtable,
    itemrecord,
    userdataset_id
  ) VALUES (
    itemaccessioncode,
    itemdatabase,
    itemtable,
    itemrecord,
    userdataset_id
  )
RETURNING merge_action(),
          src.user_di_code,
          dst.userdatasetitem_id,
          'di.' || dst.userdatasetitem_id AS vb_di_code;