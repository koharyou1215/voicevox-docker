# VoiceVox Engine Dockerfile -【正真正銘の最終修正版】
FROM python:3.11-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# VOICEVOXエンジンをダウンロードして展開（最新の安定版 0.24.1 を使用）
RUN wget "https://github.com/VOICEVOX/voicevox_engine/releases/download/0.24.1/voicevox_engine-linux-cpu-0.24.1.zip" -O voicevox.zip \
    && unzip voicevox.zip \
    && rm voicevox.zip

# 実行権限を付与
RUN chmod +x /app/run

# Pythonの依存関係をインストール (もしapp.pyなどを使う場合はコメントを外してください)
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# アプリケーションファイルをコピー (もしapp.pyなどを使う場合はコメントを外してください)
# COPY . .

# ポートを公開
EXPOSE 50021

# VOICEVOXエンジンを起動
CMD ["./run", "--host", "0.0.0.0"]

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget -q --spider http://localhost:50021/version || exit 1
