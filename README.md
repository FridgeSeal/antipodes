# Antipodes
Code for my Antipodes tech test

## Docker stack exercise
The relevant files are found at the root of this repo. All infrastructure can be built and spun up using the `docker compose up` command from the root of this repo. The SQL-Server instance will automatically have a persistent volume attached and the password for the database can be controlled by either setting an environment variable called `DB_PASSWORD` in your shell, or by setting the value directly in the `compose.yaml`.  
The dockerfile for the `dev` container can be found within the `dev/` directory, along with it's immediate dependencies, and the R dependencies needed to run the etl script.  
R-Studio will block logins of users with a user-id below 1000, which means we need to provision a user (and associated home directory and permissions) in order to log in. This is performed automatically, and the user is given a placeholder password.

Currently database-migration scripts to setup the tables need to be run by hand. In a production-grade setup, we would be using a migration tool (DbMate, Atlas, EntityFrame, Bytebase, etc). The SQL necessary for setting up the tables is located at `dev/setup_schema.sql`

Once the stack is up, the R-studio endpoint can be accessed at `localhost:8787` and the jupyter notebooks can be accessed at `localhost:8888`.  
*Note* - due to the way Jupyter secures access via a token, you need to grab this token from the logs in your docker-console if you wish to access the Jupyter notebooks.  
Both services run under the `datadev` user, that has `sudo` access, as required. From within these environments, the SQL server instance is access via the hostname `sqlserver` on port 1433. The Sql Server password will need to be set so that the R script may access the database.


## ETL Script
This is a self-contained script that lives within the `dev` folder. It is included with the `dev` docker image, dependencies are versioned and managed via `renv`, and on loading the script up in RStudio Server, the session should load the `.Rprofile` file, RStudio will repair/re-instantiate any missing dependencies.  
Please note - the Sql Server password needs to be changed from it's placeholder value. Whilst this password could have been hardcoded in, I'm generally adverse to this as I try to follow best security practices wherever possible.
As per the task guidelines, the `ticker_id` parameter is set to `BKLN`. However this is parametised everywhere in the script and database tables, this same script could be used to extract other fund information by altering that parameter.


### Notes
I previously persued an approach in which R project dependencies were included during container build-time. However, this resulted in a number of file-system permissions and configuration issues, so I elected to keep the setup simple, and have dependencies built at runtime.  
In a production environment, I would rectify this issue by taking a slightly different approach with the containers: images that executed ETL jobs, would be "vanilla" R images - i.e. the docker image wouldd only contain R, the project dependencies, and the script itself, and parameters and logins would be provided via environment variables and mounted files/secrets controlled by the runtime (Kubernetes, etc). This would drastically simplify our dockerfile setup, and would remove complexities around accounts and configurations. Another approach would simply be to delegate this entire stack to a solution like "ml-workspace": https://github.com/ml-tooling/ml-workspace .Where instead of building our own, we could simply rely on community-provided (and bugfixed) solutions, notably via their "R-flavour" docker image.

## Snow SQL
Provided is both the table definitions, and the query itself in the `snow_sql.sql` file.