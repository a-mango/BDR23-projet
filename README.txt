BDR 2324 - Projet
=================

Date: 2024-01-21

Authors
-------

- Eva Ray <eva.ray@heig-vd.ch>
- Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
- Aubry Mangold <aubry.mangold@heig-vd.ch>

Pre-requisites
--------------

- Docker compose (https://docs.docker.com/compose)

Setup
-----

- The .env.example file must be copied to .env.

Deployment
----------

Run `docker-compose up -d` to start the infrastructure. The containers may take a while to start because
they are building the stack.

Troubleshooting
---------------

If you don't have any data in the database, verify that the shell scripts (*.sh) have LF line endings.
Git, Windows or your IDE may have converted them to CRLF, which will cause the scripts to fail.

If you get a 500 error while inserting or updating data, make sure that you are not mistakenly sending
data with values that must be unique. For example, if you are inserting a new user, make sure that the
phone number is not already used.