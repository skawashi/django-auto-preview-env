#!/bin/bash
set -e

# マイグレーションの実行 (SQLiteデータベースファイルが自動作成されます)
echo "Running migrations..."
python manage.py migrate --noinput

echo "Creating superuser if not exists..."
python -c "
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin')
    print('Superuser created successfully.')
else:
    print('Superuser already exists. Skipping...')
"

# プレビュー環境用に初期データを投入したい場合はここで実行します
echo "Loading initial data..."
python manage.py loaddata fixtures/initial_data.json

# 静的ファイルの収集
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Gunicornでアプリケーションを起動 (App Runnerはデフォルトでポート8080などを期待するため、必要に応じて変更)
echo "Starting Gunicorn..."
# myproject.wsgiの部分は実際のDjangoプロジェクト名に変更してください
exec gunicorn myproject.wsgi:application --bind 0.0.0.0:8000 --workers 2
