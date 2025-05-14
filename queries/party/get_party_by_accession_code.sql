SELECT 
    * 
FROM
    party
    left join telephone on party.party_id = telephone.party_id
    left join address on party.party_id = address.party_id
    left join projectContributor on party.party_id = projectContributor.party_ID
WHERE
    party.accessionCode = %s;