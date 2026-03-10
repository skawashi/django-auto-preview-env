FROM python:3.11-slim

# 環境変数の設定
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# 作業ディレクトリの作成
WORKDIR /app

# 必要なシステムパッケージのインストール（SQLite等で必要な場合）
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# requirements.txtのコピーとインストール
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# アプリケーションコードとエントリーポイントのコピー
COPY . /app/
COPY entrypoint.sh /app/entrypoint.sh

# 実行権限の付与
RUN chmod +x /app/entrypoint.sh

# デフォルトのポート
EXPOSE 8000

# エントリーポイントの指定
ENTRYPOINT ["/app/entrypoint.sh"]
