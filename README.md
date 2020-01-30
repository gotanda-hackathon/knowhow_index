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
- Ruby -v 2.7.0
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

## seed_fu の使い方
db/fixtures ディレクトリを作り、配下に rb ファイルを置く。
ファイル名に`01_` とプレフィックスを書けば、採番順に実行される。

初期データ流しの実行コマンドは `$ bin/rails db:seed_fu`。
`$ bin/rails db:seed_fu FILTER=○○` で○○に部分一致するファイルのみ実行。

特徴としては、
**新規データは作成され、既存データは更新される**
[**バリデーションは無視される**](https://github.com/mbleigh/seed-fu/blob/34c054c914858c3d7685f83d16dea5c0e2114561/lib/seed-fu/seeder.rb#L74)
[**データ投入は複数投入に対応して transaction が入っている**](https://github.com/mbleigh/seed-fu/blob/34c054c914858c3d7685f83d16dea5c0e2114561/lib/seed-fu/seeder.rb#L35)

- 単発データの入れ方
```ruby
Post.seed do |s|
  s.id = 1
  s.title = 'hoge'
end
```
- 複数データの入れ方
```ruby
Post.seed(:id,
          { id: 1, name: 'hoge' },
          id: 2, title: 'huga')
```
