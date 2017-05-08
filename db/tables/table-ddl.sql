CREATE TABLE users (
        email VARCHAR UNIQUE NOT NULL,
            password BYTEA NOT NULL,
                PRIMARY KEY(email)

);

insert into users values ('admin@fakeemail.com', 'fakepwd'::bytea);

