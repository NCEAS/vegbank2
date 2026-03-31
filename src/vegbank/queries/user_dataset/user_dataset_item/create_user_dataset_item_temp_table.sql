CREATE TEMPORARY TABLE user_dataset_item_temp (
    user_di_code TEXT NOT NULL,
    userdataset_id INTEGER NOT NULL,
    itemaccessioncode TEXT NOT NULL, 
    itemdatabase TEXT NOT NULL, 
    itemtable TEXT NOT NULL,
    itemrecord INTEGER NOT NULL
) ON COMMIT DROP;