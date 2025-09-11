# Ondemand XYZ Tile Map Service
オンデマンド型のXYZタイル地図を提供するサービス  
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
- UWSGI_WORKERS
    - uwsgiのワーカープロセス数
    - デフォルトは `8`
- UWSGI_PORT
    - uwsgiのアドレスとポート番号
    - デフォルトは `0.0.0.0:8080`
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
- TILE_MAX_AGE
    - タイル画像の最大キャッシュ期間
    - デフォルトは `3600`（1時間）
- TILE_MAX_AGE_LIVE
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
    - `https://<SERVER_NAME>/xyz/<sub path>/<z>/<x>/<-y>.png`
    - 例：`https://odtiles.example.com/xyz/sample/10/512/512.png`


使い方の詳細は、[odtiles-base](https://github.com/take4iso/odtiles-base)のREADMEを参照のこと