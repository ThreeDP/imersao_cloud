# migração de um sistema de hotel para Muiltcloud


## Configuração do usuário S3 na aws
> A primeira etapa é a criar e configurar um novo usuário na aws para ter acesso total ao serviço S3 e gerar as chaves de acesso para esse usuário.

## Fazer o build para instanciar a os serviços

1. A segunda etapa é clonar o projeto no CLI do google cloud.

```sh
git clone git@github.com:ThreeDP/imersao_cloud.git
```

2. Importar o arquivo csv de credenciais baixado da aws.

3. Execute o arquivo .environment para obter as informações basicas do ambiente.

```sh
source .enviroment
```

4. E executar o commando make para configurar as instancias dos serviços necessários.

```sh
make
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
gcloud sql connect $SQL_INSTANCE --user=<user>
```

```sh
use dbcovidtesting;
source ~/imersao_cloud/requirements/db/create_table.sql
show tables;
exit;
```

## Crie a imagem do app
> Criar a imagem do app no kubernetes, conecta com a api, criar um arquivo de configuração de env e aplica as configurações no kubernetes.

```sh
make deploy
```

# upload do dump do banco de dados
> Faça o upload do banco de dados e faça a migre os dados para o banco no google cloud.

```sh
gcloud sql connect $SQL_INSTANCE --user=<user>
```

```sh
use dbcovidtesting;
source ~/imersao_cloud/requirements/db/db_dump.sql;
select * from records;
exit;
```

## upload dos pdfs para o bucket s3 aws
> Abra a CLI no aws e use o comando wget pra fazer o download dos pdf para o cli local

```
aws s3 sync . s3://luxxy-covid-testing-system-pdf-pt-xxxx
```