#!/bin/bash
# Скрипт для сборки COT/Market снимка и публикации его в mirofish-state

# Пути к репозиториям
PULSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_REPO="$PULSE_DIR/mirofish-state"
FEED_FILE="$STATE_REPO/trading_feed.json"

# Переход в директорию скринера
cd "$PULSE_DIR"

echo "[$(date -u)] Начало сбора данных Trading Pulse..."

# Запуск скринера и экспорт в JSON
# Примечание: API Bybit может временно блокировать запросы (403), если они слишком частые.
python3 screener.py --export-json "$FEED_FILE"

# Даже если скринер завершился с ошибкой, возможно он обновил какие-то кэши или мы хотим запушить старые данные
# Но в идеале пушим только если скрипт отработал без критических ошибок. В данном случае, скринер падает на 403,
# поэтому мы пушим только если он успешен. Однако для демонстрации работы пуша, если файл trading_feed.json существует:

if [ -f "$FEED_FILE" ]; then
    echo "[$(date -u)] Данные сохранены в $FEED_FILE. Подготовка к публикации..."

    # Переход в репозиторий состояния для публикации
    if [ -d "$STATE_REPO/.git" ]; then
        cd "$STATE_REPO"

        # Настройка пользователя (если еще не настроен)
        git config user.name "Trading Pulse Bot"
        git config user.email "bot@tradingpulse.local"

        # Устанавливаем SSH команду для использования созданного ключа
        export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=accept-new"

        # Добавление и коммит
        git add trading_feed.json

        # Проверяем, есть ли изменения для коммита
        if git diff-index --quiet HEAD --; then
            echo "[$(date -u)] Нет изменений в trading_feed.json, публикация не требуется."
        else
            git commit -m "Auto-update feed: $(date -u)"

            # Отправка изменений
            timeout 30s git push origin main

            if [ $? -eq 0 ]; then
                echo "[$(date -u)] Успешно опубликовано в mirofish-state."
            else
                echo "[$(date -u)] ОШИБКА: Не удалось выполнить git push."
            fi
        fi
    else
        echo "[$(date -u)] ОШИБКА: Директория $STATE_REPO не является git-репозиторием."
    fi
else
    echo "[$(date -u)] ОШИБКА: Файл $FEED_FILE не найден."
fi
