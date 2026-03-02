# Ondemand XYZ Tile Map Service
オンデマンド型のXYZタイル地図およびＷＭＳを提供するサービス  
ブラウザからのリクエストに応じて、ダイナミックにタイル画像を生成し返却する  
作成したタイル画像は、一定期間キャッシュされる

## システム構成
- base
    - [odtiles-base](https://github.com/take4iso/odtiles-base)を基に作成
    - cron を追加して、ログローテーションとタイルキャッシュのローテーションを実行
- httpd
    - Apache2
    - httpsのアクセスをbaseのuwsgiにリバースプロキシする

## 初期化
### .env ファイルを編集する
env_exampleをコピーして、.envファイルを作成する
- SERVER_NAME
    - サーバーのホスト名
    - 例：`odtiles.example.com`
- SERVER_ADMIN
    - サーバー管理者のメールアドレス
    - 例：`admin@odtiles.example.com`
- URL
    - サーバーのURL
    - 例：`https://odtiles.example.com`
    - WMSのGetCapabilitiesで参照する
- ALLOWED_HOSTS
    - 許可するホスト名
    - 複数指定する場合は、カンマ区切りで指定する
    - 例：`odtiles.example.com,localhost`
- UWSGI_WORKERS
    - uwsgiのワーカープロセス数
    - デフォルトは `8`
- UWSGI_PORT
    - uwsgiのポート番号
    - デフォルトは `8080`
- TILE_SOURCE_FOLDER
    - タイルソースのフォルダ
    - タイル画像を生成するためのソースデータを格納する
    - ホスト側のフォルダを指定すること
    - デフォルトは `/mnt/host/tilesrc`
    - baseコンテナの `/mnt/odtiles/tilesrc` にマウントされる
- TILE_OUTPUT_FOLDER
    - タイル画像のキャッシュフォルダ
    - タイル画像を格納する
    - ホスト側のフォルダを指定すること
    - デフォルトは `/mnt/host/tileout`
    - baseコンテナの `/mnt/odtiles/tileout` にマウントされる
- WMS_OUTPUT_FOLDER
    - WMS画像のキャッシュフォルダ
    - WMSの出力画像を格納する
    - ホスト側のフォルダを指定すること
    - デフォルトは `/mnt/host/wmsout`
    - baseコンテナの `/mnt/odtiles/wmsout` にマウントされる 
- MAX_AGE
    - タイル画像の最大キャッシュ期間
    - デフォルトは `3600`（1時間）
- MAX_AGE_LIVE
    - タイル画像のライブキャッシュ期間
    - デフォルトは `60`（1分）

### SSL証明書の設定
SSL証明書を設定するために、以下のファイルを差し替える  
※ファイル名は変更しないこと
- /odtiles-docker/httpd/tls/server.crt
- /odtiles-docker/httpd/tls/server.key

## ビルド＆起動
```bash
> docker compose up -d --build
```
## トークンの確認
UPLOAD_API_TOKENはコンテナの初回起動時に自動で設定される  
以下のコマンドで確認できる
```bash
> docker logs odtiles-base-1
```
## 使い方
- タイルマップのURL
    - `https://<DOMAIN_NAME>/xyz/<sub path>/{z}/{x}/{y}.png`
- WMSのURL
    - `https://<DOMAIN_NAME>/wms/<sub path>?SERVICE=wms&REQUEST=GetCapabilities&VERSION=1.1.1`
- GeoTIFFのアップロードAPIのURL
    - `https://<DOMAIN_NAME>/upload/<sub path>`
- WMS有効化APIのURL
  -  `https://<DOMAIN_NAME>/setCapabilities/<sub path>`

使い方の詳細は、[odtiles-base](https://github.com/take4iso/odtiles-base)のREADMEを参照のこと