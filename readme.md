# migração de um sistema de hotel para Muiltcloud


## Configuração do usuário S3 na aws
> A primeira etapa é a criar e configurar um novo usuário na aws para ter acesso total ao serviço S3 e gerar as chaves de acesso para esse usuário.

## Fazer o build para instanciar a os serviços

```sh
make key_secret=./key.csv
```

## Declarar as variaveis de ambiente necessárias
> Crie um arquivo .env no diretorio raiz do projeto.

```
AWS_BUCKET="luxxy-covid-testing-system-pdf-pt-xxxx>"
S3_ACCESS_KEY="xxxxxxxxxxxxxxxxxx"
S3_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
DB_HOST_NAME="<ip_publico_mysql>"
DB_USER="<sql_user>"
DB_PASSWORD="<sql_password>"
DB_NAME="dbcovidtesting"
DB_PORT="3306"
```

## Crie um usuário MYSQL
> Crie um usuário com o mesmo user e pass declarados no .env e execute os seguintes comandos

## Crie a tabela para os dados

```sh
mysql --host="<ip_publico_mysql>" --port="3306" -u <sql_user> -p
# Digite a senha
use dbcovidtesting;
source ~/imersao_cloud/requirements/db/create_table.sql
show tables;
exit;
```

## Crie a imagem do app

```sh
export GOOGLE_CLOUD_PROJECT_ID=$(gcloud config get-value project)
export CONTAINER_LUXXY_COVID_NAME=gcr.io/$GOOGLE_CLOUD_PROJECT_ID/luxxy-covid-testing-system-app-pt
cd ~/imersao_cloud/requirements/app
gcloud builds submit --tag $CONTAINER_LUXXY_COVID_NAME
```

## Execute o kubernets

```sh
cd ~/imersao_cloud/
kubectl create configmap luxxy-covid-config --from-env-file=.env
cd ~/imersao_cloud/requirements/kubernets
kubectl apply -f luxxy-covid-testing-system.yaml
```