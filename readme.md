# Ondemand XYZ Tile Map Service
オンデマンド型のXYZタイル地図およびＷＭＳを提供するサービス  
ブラウザからのリクエストに応じて、ダイナミックにタイル画像およびＷＭＳ画像を生成し返す  
作成した画像は、キャッシュデータとして保存され、同じ画像のアクセスにはキャッシュデータを返す

## システム構成
- base
    - [odtiles-base](https://github.com/take4iso/odtiles-base)を基に作成
    - cron を追加して、ログローテーションとタイルキャッシュのローテーションを実行
        - デフォルトではログローテーション、キャッシュローテーションは止めている
        - ローテーションを動かす場合は、`/odtiles-docker/base/Dockerfile`の35行以下のコメントアウトを外す
        - ローテーションの設定は`/odtiles-docker/base/cron.d/`にあるファイルを変更する
- httpd
    - Apache2
    - httpsのアクセスをbaseのuwsgiにリバースプロキシする

## 初期化
### .env ファイルを編集する
env_exampleをコピーして、.envファイルを作成する
- SERVER_NAME
    - サーバーのホスト名
    - 例：`odtiles`
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
    - 例：`odtiles.example.com,localhost,192.168.1.1`
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
    - baseコンテナの `/mnt/odtiles/tilesrc` にバインドされる
- TILE_OUTPUT_FOLDER
    - タイル画像のキャッシュフォルダ
    - ホスト側のフォルダを指定すること
    - baseコンテナの `/mnt/odtiles/tileout` にバインドされる
- WMS_OUTPUT_FOLDER
    - WMS画像のキャッシュフォルダ
    - ホスト側のフォルダを指定すること
    - baseコンテナの `/mnt/odtiles/wmsout` にバインドされる 
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
`UPLOAD_API_TOKEN`はコンテナの初回起動時に自動で設定される  
以下のコマンドで確認できる
```bash
> docker logs odtiles-base-1
```
## 使い方
- タイルマップのURL
    - `https://<ドメイン名>/xyz/<sub path>/{z}/{x}/{y}.png`
- WMSのURL
    - `https://<ドメイン名>/wms/<sub path>?SERVICE=wms&REQUEST=GetCapabilities&VERSION=1.1.1`
- GeoTIFFのアップロードAPIのURL
    - `https://<ドメイン名>/upload/<sub path>`
- WMS有効化APIのURL
  -  `https://<ドメイン名>/setCapabilities/<sub path>`

使い方の詳細は、[odtiles-base](https://github.com/take4iso/odtiles-base)のREADMEを参照のこと

 ## WindowsのDocker desktopを使っている場合
 `TILE_SOURCE_FOLDER`, `TILE_OUTPUT_FOLDER`, `WMS_OUTPUT_FOLDER`は、Winsows上のパスを指定する必要がある
- やり方
  - Docker desktopの設定から、`Resource` ⇒ `File sharing`
  - バインドするフォルダを登録する
  - 登録したフォルダを、`.env` に設定する
