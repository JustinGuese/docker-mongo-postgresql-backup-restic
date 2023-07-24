# docker-mongo-postgresql-backup-restic

a docker image to backup MongoDB or PostgreSQL to a github repository. 

## Usage

input EITHER a postgres or mongodb connection url to the environment variable `POSTGRES_URI` or `MONGODB_URI` respectively.

Then, input the environment variables BACKUP_NAME and GIT_REPO. 

Finally, you need to add your ssh key to github and add that key as a file mounted to /root/.ssh/id_rsa (see docker compose)