/* database creation
 * prefixes:
 * # : launch with superuser
 * $ : launch with normal user
 * create a linux user
 *        #  adduser unrealt
 *        #  passwd unrealt
 *
 * become database superuser
 *        #  su - postgresql
 *
 * connect to the db server
 *        $  psql template1 < {this_script}
 *
 */
CREATE DATABASE unreal_tournament;

/* create admin user */
CREATE USER unrealt WITH PASSWORD 'unrealt';
GRANT ALL PRIVILEGES ON DATABASE unreal_tournament TO unrealt WITH GRANT OPTION;

/* needed for django testdb creation */
ALTER USER unrealt CREATEDB;

/* logout from db
 *        template1=# \q
 */