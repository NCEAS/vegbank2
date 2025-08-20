insert into party (surname, email)
values ('admin', 'admin@vegbank.org');
insert into usr (
        party_id,
        password,
        permission_type,
        ticket_count,
        email_address
    )
values (
        (
            select max(party_id)
            from party
            where email = 'admin@vegbank.org'
        ),
        '5ffffffffffffff8d7ab5d48fffffffffffffff8effffffffffffffe9ffffffffffffffabffffffffffffffb3fffffffffffffff0ffffffffffffff85ffffffffffffffe7ffffffffffffff824',
        15,
        2000,
        'admin@vegbank.org'
    );