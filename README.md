Tutorial<br>
https://developer.hashicorp.com/terraform/tutorials/azure-get-started/infrastructure-as-code
```bash
pip install azure-cli # azure cliをインストール
az login --tenant c2f3b2c3-33c1-447c-b3fb-515c23806d7e # AzureADテナントを指定してログインする (AWS Organization)
az account show # ログイン(id)を確認
az account set --subscription "35akss-subscription-id" # サブスクリプションを指定 (AWSメンバーアカウント)
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>" # サービスプリンシパル(Role)の設定
$Env:ARM_CLIENT_ID = "<APPID_VALUE>" # サービスプリンシパル情報の設定
$Env:ARM_CLIENT_SECRET = "<PASSWORD_VALUE>"
$Env:ARM_SUBSCRIPTION_ID = "<SUBSCRIPTION_ID>"
$Env:ARM_TENANT_ID = "<TENANT_VALUE>"
```
```bash
# main.tf作成後に実行し、デプロイに必要なプラグインをダウンロードする
terraform init
```

```bash
# 構文チェックする
terraform validate
```

```bash
# ファイルのフォーマットを整形する
terraform fmt
```

```bash
# deploy内容を確認する
terraform plan
```

```bash
# deployする
terraform apply
```

```bash
# 削除する
terraform destroy
```

```bash
# デプロイされている詳細内容を表示する
terraform show
```

```bash
# デプロイされているリソースを一覧表示する
terraform state list
```

```bash
# 既存のリソースをterraformにする
terraform import
```

```bash
# 本番、開発環境を管理する
terraform workspace
```

```bash
# outputを表示する
terraform output resource_group_id
```
