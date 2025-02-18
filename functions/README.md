# Flow of updating Firestore after development on DEV
## Indexes
Firstly you need to print out current indexes on DEV.

Switch to DEV
```
firebase use default
```

Print Firestore indexes
```
firebase firestore:indexes
```

Current DEV indexes will be printed to stdout of terminal. Now you should copypaste them into the file `firestore.indexes.json`. Or use `firebase firestore:indexes > firestore.indexes.json` from project root.

Then switch to PROD 
```
firebase use prod
```

and deploy indexes

```
firebase deploy --only firestore:indexes
```

And don't forget to commit changes into repo, so we all have the last version.
TODO: Create a script that does this automatically.

# How to deploy Firebase Functions
## Select correct Firebase project

There are two Firebase projects configured.
- (default) DEV environment `Zachran obed DEV`
- (prod) PROD environment `Zachran obed`

**BEWARE**
functions/src/index.ts contains service account id in `setGlobalOptions`. This account is for prod account. You can change account to DEV one.
PROD: firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com
DEV: firebase-adminsdk-ju14s@zachran-obed-dev.iam.gserviceaccount.com

You can select project where you want deploy functions with `firebase use` e.g.
```
firebase use prod
```

By invoking `firebase use` you can see list of available projects and which one is currently selected.

## Exporting data from Firestore for emulator

This can be accomplished through a set of commands in terminal on the existing project:

1. Login to firebase and Gcloud:
    ```
    firebase login
    gcloud auth login
    ```
2. See a list of your projects and connect to one:
    ```
    firebase projects:list
    firebase use zachran-obed-dev
    ```
    ```
    gcloud projects list
    gcloud config set project zachran-obed-dev
    ```
3. Export your production data to gcloud bucket with chosen name:
    ```
    gcloud firestore export gs://export-for-emulator
    ```
4. Now copy this folder to your local machine, I do that in functions   folder directly:

    Note : Don't miss the dot ( . ) at the end of below command
    ```
    cd functions
    gsutil -m cp -r gs://export-for-emulator .
    ```

## Using emulator for development

Use `firebase init emulators` for initialization and configuration of emulator. For this project select **Firestore** and **Functions** emulators.

```
firebase init emulators
```

After that you can run emulators by

```
firebase emulators:start
```

If you want to use exported Firestore DB from previous steps you can use following command to import and export emulator db from project root.

```
firebase emulators:start --import functions/seed/export-for-emulator/2024-04-05T11:33:06_69896/ --export-on-exit functions/seed/export-for-emulator/2024-04-05T11:33:06_69896/
```

Also to run the emulator easier you can use `npm run serve` which compiles functions and starts the emulator with seed data.

## Deploy functions to cloud

To deploy Firebase Function to a selected environment you need to run following command in `functions` directory. Do not delete non-existing functions in sourcecode. There are funtions that are needed by Rowy or other connected services.

```
npm run deploy
```

If you run into any lint issues, you can try to solve them automatically by running following command in `functions` direcotry.

```
npm --prefix "$RESOURCE_DIR" run lint:fix
```

# Snippets
## Create box shipment in deliveries collection
```
curl -X POST \
  "http://localhost:8080/v1/projects/zachran-obed-dev/databases/(default)/documents/deliveries" \
  -H 'Content-Type: application/json' \
  -d '{
    "fields": {
      "donorId": {"stringValue": "test-zo-jidelna"},
      "foodBoxes": {
        "arrayValue": {
          "values": [
            {
              "mapValue": {
                "fields": {
                  "count": {"stringValue": "1"},
                  "foodBoxId": {"stringValue": "ikea_small"}
                }
              }
            },
            {
              "mapValue": {
                "fields": {
                  "count": {"stringValue": "1"},
                  "foodBoxId": {"stringValue": "ikea_large"}
                }
              }
            }
          ]
        }
      },
      "recipientId": {"stringValue": "test-zo-charita"},
      "type": {"stringValue": "BOX_DELIVERY"}
    }
  }'

```

## Update food delivery with correct state for box shipment
*Note: At the end of url needs to be existing `documentId` and **there needs to be real update in data** *
```
curl -X PATCH \
  "http://localhost:8080/v1/projects/zachran-obed-dev/databases/(default)/documents/deliveries/L07P06Ya0GY6Mq8VJvON" \
  -H 'Content-Type: application/json' \
  -d '{
    "fields": {
      "donorId": {"stringValue": "test-zo-jidelna"},
      "foodBoxes": {
        "arrayValue": {
          "values": [
            {
              "mapValue": {
                "fields": {
                  "count": {"stringValue": "1"},
                  "foodBoxId": {"stringValue": "ikea_small"}
                }
              }
            },
            {
              "mapValue": {
                "fields": {
                  "count": {"stringValue": "1"},
                  "foodBoxId": {"stringValue": "ikea_large"}
                }
              }
            }
          ]
        }
      },
      "recipientId": {"stringValue": "test-zo-charita"},
      "type": {"stringValue": "FOOD_DELIVERY"},
      "state": {"stringValue": "OFFERED"}
    }
  }'

```