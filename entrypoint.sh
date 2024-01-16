#!/bin/bash
set -e

# Rails に対応したファイル server.pid が存在しているかもしれないので削除する。
rm -f /myapp/tmp/pids/server.pid

# production環境の場合のみ
if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails assets:precompile
  # --------------------------------------
  # 本番環境（AWS ECS）への初回デプロイ時に利用
  # 初回デプロイ後にコメントアウトする
  # bundle exec rails db:create
  # --------------------------------------
  # マイグレーション処理
  bundle exec rails db:migrate
fi

# コンテナーのプロセスを実行する。（Dockerfile 内の CMD に設定されているもの。）
exec "$@"
