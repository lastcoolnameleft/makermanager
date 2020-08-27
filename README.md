# Maker Manager

## Setup - Development

1. Copy Dev App config data to app.php
   1. `cp config/app.dev.php config/app.php`
2. Start App + DB
   1. `docker-compose -f docker-compose.dev.yml up`
3. Perform Database migrations
   1. `docker exec -it makermanager_app_1 bin/cake migrations migrate`

_DEBUGGING_

* To connect to the database: `docker exec -it makermanager_db_1 mysql -u root -pcakephp`
* To create a shell into the app: `docker exec -it makermanager_app_1 bash`

## Configuration

Read and edit `config/app.php` and setup the 'Datasources' and any other
configuration relevant for your application.

## API

### URL Routes

- endpoints - All of these routes require WHMCS authentication before access
  - addonActivate - Create/Updates an addon account, gives it a fake entry until user scans a badge
  - addonCancel - "Suspends" a badge, disables AD addon account
  - clientAdd - Webhook from whmcs that creates / updates a user in the local database, and the active directory 
  - clientChangePassword - Webhook, handles a password change update to AD, also handles if the account doesn't exist in AD
  - clientEdit
  - invoicePaid
  - moduleCreate
  - moduleSuspend
  - moduleTerminate
  - moduleUnsuspend
  
