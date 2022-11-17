# antipodes
Code for my Antipodes tech test

## Docker stack exercise
The relevant files are found at the root of this repo. All infrastructure can be built and spun up using the `docker compose up` command from the root of this repo. The SQL-Server instance will automatically have a persistent volume attached.  
The dockerfile for the `dev` container can be found within the `dev/` directory, along with it's immediate dependencies, and the R dependencies needed to run the etl script.  
The `setup_secrets.sh` script should be run before the `docker compose up` command as it sets up the secrets (via env vars) that are used by the Sql Server instance, and for creating the linux user that RStudio uses for login credentials (`datadev`).

Currently database-migration scripts to setup the tables need to be run by hand, in a production-grade setup, we would be using a migration tool (DbMate, Atlas, EntityFrame, Bytebase, etc). The SQL necessary for setting up the tables is located at `dev/setup_schema.sql`


## ETL Script
This is a self-contained script that lives within the `dev` folder. It is included with the `dev` docker image, dependencies are versioned and managed via `renv`, and on loading the script up in RStudio Server, the session should load the `.Rprofile` file, which will then load any missing dependencies into the environment.