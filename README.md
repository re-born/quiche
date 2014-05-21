# Quiche

## 概要

### [読んだ記事]を気軽に(共有|ストック|検索)するサービス

- クローズドコミュニティでの利用を想定
- テクノロジーの記事を中心に集める
- 思い出す時に便利

## 用語

- `Quiche`: サービス名。文脈によっては`投稿された記事`のことも`Quiche`と呼ぶ。
- `Quicheを"焼く"`: 記事を投稿すること

## 仕組み


### chrome拡張側

1. chromeの拡張のボタンを押す

  1.1. 初回はtwitterでログイン

2. http://q.l0o0l.co/item/create に (URL|user)情報をPOST

### Rails側

1. 拡張側から (URL|user)情報を取得

2. [Readability(gem)](https://github.com/cantino/ruby-readability)を用いて、URLから記事の(本分|画像のurl)を抽出, 保存
3. 同じQuicheが焼かれた場合には、焼いたuserが `Reader` として追加される

  3.1. 同じ記事かどうかは、記事ページのtilte情報で判断している


## data-schema

![](http://gyazo.l0o0l.co/img/2014-05-14/7e00e4f6887f685fba3954375913bc12.png)

## 環境設定 [WIP]

```
ruby: 2.0.0

git clone https://github.com/re-born/lab_cache/
bundle install
rake acts_as_taggable_on_engine:install:migrations
rake db:create
rake db:migrate
rake db:seed
rails generate sunspot_rails:install
rake sunspot:solr:start
rake sunspot:solr:reindex
rails s
```
