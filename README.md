# 開発した背景

「チームケア」は介護者同士や介護者と事業者の交流を目的としたSNSです。<br>
介護者が孤立するという社会問題に対して、介護者同士で悩みを共有したり、介護で困っている人と介護の負担を軽減するサービスを結びつけたいと思いました。<br>
つぶやきの簡単投稿機能や日記の投稿機能を使って外部に発信することができます。<br>
またいいね機能やコメント機能で他者と交流ができます。<br>
<br>
このアプリの目的は介護者を孤立させないことです。<br>
ひとりで悩まず、まずは誰かに相談しましょう。<br>
ポートフォリオ解説動画もあります→https://youtu.be/0nSR5Mi8kP0<br>
Qiitaポートフォリオ解説記事→https://qiita.com/kawara3782/items/12a7ec102bbefa416966<br>

![ホーム画面](https://user-images.githubusercontent.com/79620911/131229065-49e5a33d-97d0-406d-889e-165a185cd2e7.gif)
<br>

## URL

・URL:https://www.teamcare-app.com/<br>
・簡単ログインボタンでスムーズにログインできます。
![簡単ログインgit hub](https://user-images.githubusercontent.com/79620911/131207004-159d4a07-bf26-4286-9f6d-c28ea105dc3a.png)
## 使用技術

●フロントエンド<br>
・HTML/CSS<br>
・Javascript<br>
・Vue.js 2.6.14<br>
●バックエンド<br>
・Ruby 2.7.3<br>
・Ruby on Rails 6.1.1<br>
・Rubocop（コード解析ツール)<br>
・Rspec（単体、結合、例外処理テスト)<br>
●インフラ<br>
・AWS (EC2 / RDS(MySQL) / S3 / VPC / IAM / Route53 / ACM / ALB)<br>
・MySQL 8.0.25 / Unicorn / Nginx<br>

## ER図
![チームケアER図](https://user-images.githubusercontent.com/79620911/130318202-99329257-b443-4e8e-b9b5-794e308bb155.png)
## インフラ構成図
![インフラ構成図 drawio](https://user-images.githubusercontent.com/79620911/132795196-469e6eba-663a-4e09-9e6c-66ef0278aa1c.png)

## 機能一覧
・ユーザー新規登録/ログイン<br>
・ユーザー情報編集<br>
・簡単ログイン<br>
・投稿(つぶやき、日記)<br>
・写真の投稿(つぶやき、日記)<br>
・絵文字の投稿(つぶやき、日記)<br>
・いいね<br>
・ブックマーク<br>
・フォロー/フォロー解除<br>
・ダイレクトメッセージ<br>
・ブロック<br>
・カテゴリー<br>
・つぶやき検索<br>
・人気表示（つぶやき、日記）<br>
・新着表示（つぶやき、日記）<br>
・コメント<br>
・通知（いいね、フォロー、コメント、ダイレクトメッセージ）<br>
・問い合わせ機能<br>
・レスポンシブ対応(パソコン、タブレット、スマートフォン)<br>
<div align="center">
<img src="https://user-images.githubusercontent.com/79620911/131207280-e7fe2722-4fa6-4037-b576-0d7890f7f1f6.gif" />
</div>

## イチ押し機能
・つぶやきの簡単投稿機能<br>
![簡単投稿機能①](https://user-images.githubusercontent.com/79620911/130345739-c01d4fc3-5b5f-4a6f-8bc2-cf1a103526d4.png)
![簡単投稿②](https://user-images.githubusercontent.com/79620911/130345755-f85f787f-7a30-4391-a83c-d540550c1984.png)
![簡単投稿機能③](https://user-images.githubusercontent.com/79620911/130345763-58ecb898-fec1-4acc-a98c-0d1b56ca1f73.png)

・ヘルプ機能(他のユーザーに助けを求める)<br>
![助けを求める①](https://user-images.githubusercontent.com/79620911/130345775-a2375c25-347d-4726-b4c7-d45ef778ef5e.png)
![助けを求める②](https://user-images.githubusercontent.com/79620911/130345783-1e0257fb-6326-49f1-9ec5-8b76ba5d4c08.png)

## 工夫した点
・介護者にフィードバックをもらった。<br>
開発中に介護者数名に設計段階で意見をもらったり、ポートフォリオを実際に使ってもらい、フィードバックを得ました。<br>
「この画面が見にくい」「この機能が使いにくい」等の意見を取り入れて、ポートフォリオを改善してきました。<br>
フィードバックを反映させた機能として、つぶやきの簡単投稿機能とヘルプ機能があります。<br>
その他、ボタンの大きさ等のデザインもフィードバックを反映させました。<br>

・ご年配の方でも使いやすいUI/UXを意識した。<br>
Vue.jsを導入して、お気に入り機能とコメント機能を非同期処理で実装しました。<br>
また絵文字の投稿を可能にし、視覚的にわかりやすいコミュニケーションが取れるようにしました。<br>

お気に入り機能(Vue.js)<br>
![Vueお気に入り](https://user-images.githubusercontent.com/79620911/131789204-956afc66-cf31-45f7-954c-f2876a042d0f.gif)
コメント機能(Vue.js)<br>
![Vueコメント](https://user-images.githubusercontent.com/79620911/131789212-272f8877-9671-4592-a6c4-1ad02734f2f5.gif)

