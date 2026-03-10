INSERT INTO user_dataset_item_temp 
(
    user_di_code, 
    itemaccessioncode, 
    userdataset_id,
    itemdatabase, 
    itemtable, 
    itemrecord
)
VALUES (%s, %s, %s, %s, %s, %s);