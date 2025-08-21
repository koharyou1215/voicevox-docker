# VoiceVox Engine Dockerfile -【正真正銘の最終修正版】
FROM python:3.9-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# VoiceVoxエンジンをダウンロードして展開 (正しいCPU版URL)
RUN wget "https://github.com/VOICEVOX/voicevox_engine/releases/download/0.24.1/voicevox_engine-linux-cpu-0.24.1.zip" -O voicevox.zip \
    && unzip voicevox.zip \
    && rm voicevox.zip

# 実行権限を付与
RUN chmod +x /app/run

# ポートを公開
EXPOSE 50021

# 起動コマンド
CMD ["./run", "--host", "0.0.0.0", "--port", "50021"]

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget -q --spider http://localhost:50021/version || exit 1
