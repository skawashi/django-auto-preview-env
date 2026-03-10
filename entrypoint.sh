#!/bin/bash
set -e

# マイグレーションの実行 (SQLiteデータベースファイルが自動作成されます)
echo "Running migrations..."
python manage.py migrate --noinput

# プレビュー環境用に初期データを投入したい場合はここで実行します
# echo "Loading initial data..."
# python manage.py loaddata fixtures/initial_data.json

# 静的ファイルの収集
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Gunicornでアプリケーションを起動 (App Runnerはデフォルトでポート8080などを期待するため、必要に応じて変更)
echo "Starting Gunicorn..."
# myproject.wsgiの部分は実際のDjangoプロジェクト名に変更してください
exec gunicorn myproject.wsgi:application --bind 0.0.0.0:8000 --workers 2
