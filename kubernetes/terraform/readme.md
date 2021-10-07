Создание сервисного аккаунта в yandex cloud
Get folder id
```bash
yc config list
```
b1gaeis0eu1b5lcjtuts
```bash
SVC_ACCT="panthrashkov-service-account"
FOLDER_ID="b1gaeis0eu1b5lcjtuts"
yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
```
output -
id: aje1erpvttugl69lbbpu
folder_id: b1gaeis0eu1b5lcjtuts
created_at: "2021-07-03T19:54:55.920780828Z"
name: panthrashkov-service-account

add grants to account
```bash
ACCT_ID=$(yc iam service-account get $SVC_ACCT | grep ^id | awk '{print $2}')
yc resource-manager folder add-access-binding --id $FOLDER_ID --role editor  --service-account-id $ACCT_ID
```
save service-account credentials
```bash
CREDENTIALS_PATH=/home/alex/IdeaProjects/infra-secret
yc iam key create --service-account-id $ACCT_ID --output $CREDENTIALS_PATH/keyKubernetes.json
