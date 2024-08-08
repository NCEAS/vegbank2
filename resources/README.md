# Flyway

Flyway is a database migration tool... but what does that mean? How does it work? To get an overview, first read their documentation:
- https://documentation.red-gate.com/flyway/flyway-cli-and-api/welcome-to-flyway

For the example below (and during my process to investigate Vegbank), I have chosen to use the Flyway Command Line App. You can download it through their website here:
- https://documentation.red-gate.com/fd/command-line-184127404.html

For more information about the Flyway CLI:
- https://github.com/flyway/flywaydb.org/blob/gh-pages/documentation/usage/commandline/index.md#tab-community

## How does it work

The command looks simple, `flyway migrate`, and it is now that you're reading this README.md document. To get flyway working, you must provide it with a configuration file. Inside of this configuration file are key-value pairs that represent the credentials you need to access the database you want to migrate to, or re-initialize. See example below:

```
// flyway.conf
flyway.url=jdbc:postgresql://localhost:5432/vegbank
flyway.user=vegbank
flyway.password=vegbank
flyway.locations=filesystem:/migrations
```

The flyway CLI will take these credentials, access your database, then automatically apply all the individual .sql files you defined in the locations folder (ex. /migrations)

**IMPORTANT** These .sql files must be named according to Flyway conventions:

```
V1.0__desc_of_content.sql
V1.1__desc_of_content.sql
V1.2__desc_of_content.sql
...
```
- For more information, see: https://documentation.red-gate.com/fd/migrations-184127470.html

That's it! In summary, set-up your configuration file, name your migration files appropriately, and run `flyway migrate`.
- Depending on your machine, you may need to add flyway to your path.
- I am on MacOS, and I did this with the following command to make flyway executable

```
sudo ln -s `pwd`/flyway-10.17.0/flyway /usr/local/bin
```
