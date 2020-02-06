# ノウハウインデックス
## プロダクト説明
ハッカソン用プロダクト。

ワンスターのクリエイティブ施策をインデックス化して社内資産とするためのサービス。

## 開発利用技術
|項目|内容|
|:----|:----|
|OS|macOS Mojave 10.14.6|
|言語|Ruby|
|バージョン管理ツール|rbenv or RVM|
|フレームワーク|Ruby on Rails, Bootstrap|
|データベース|PostgreSQL|

## 開発環境のセットアップ
1. gitclone
```
$ git clone git@github.com:gotanda-hackathon/knowhow_index.git
```

2. bin/setup
```
$ bin/setup
```

3. 環境変数の共有

gem dotenv-rails で seed に流す管理者情報を保持しているので、.envファイルをメンバーから貰う

4. DBのセットアップ
```
$ bin/rails db:create
$ bin/rails db:migrate
$ bin/rails db:seed_fu
```

## 開発環境のバージョン
- Ruby -v 2.6.5
- Ruby on Rails -v 6.0.2.1

## 開発環境のログイン方法
<!--
  URL
  ログインアカウント情報
-->

## ドキュメント
<!-- ドキュメントへのリンク -->

## 開発ルール
GitHub上でのプルリクベースの開発手法を採択

- プッシュ時に、CircleCI で、rubocop・brakeman・RSpecが動作
- 機能ごとにmasterからブランチを切って開発
- プルリクを上げてマージする方針とする
- プルリクフォーマットに則ること
- コミットメッセージはレビュアーが読んで内容を理解できる端的で分かりやすい日本語とする

## 追加しているgemの補足
- bullet  
  デフォルトで、development/test環境では、N+1がある場合は500になるようにしています。
- [rubycritic](https://github.com/whitesmith/rubycritic)
  - `$ rubycritic` で静的コード解析ができる
- [seed-fu](https://github.com/mbleigh/seed-fu)
  - db/fixtures 配下に初期データをDSLで書き、`$ bin/rails db:seed_fu` で作成・更新できる
- [settingslogic](https://github.com/binarylogic/settingslogic)
  - config/application.yml で定数を一元管理できる。 `Settings.hoge` の形式で呼び出せる
- [simplecov](https://github.com/colszowka/simplecov)
  - `$ bin/rspec` で coverage/index.html にテストカバレッジ結果を得られる
