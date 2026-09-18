# Crypto-Bot-Sudiyan

Этот репозиторий содержит материалы и инструменты для криптотрейдинга по стратегии скальпинга.

## Стратегия

Подробное описание торговой стратегии, скринеров (Trading Pulse, RedScalp) и терминала для торговли (MetaScalp) можно найти в документе:
[TRADING_STRATEGY.md](TRADING_STRATEGY.md)

## Автоматическая публикация фида в mirofish-state

Для того чтобы скринер автоматически собирал данные с Bybit и публиковал их в репозиторий `nsudiyan/mirofish-state` каждые 5 минут, необходимо настроить SSH-ключ (Deploy Key) и cron.

### Настройка SSH доступа:
1. На вашем сервере (VPS) сгенерируйте SSH ключ, если его еще нет:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
   ```
2. Выведите публичный ключ на экран и скопируйте его:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
3. Зайдите в настройки репозитория `nsudiyan/mirofish-state` на GitHub -> **Settings** -> **Deploy keys** -> **Add deploy key**.
4. Вставьте скопированный ключ, поставьте галочку **"Allow write access"** и сохраните.

### Клонирование репозитория состояния и настройка git
Клонируйте репозиторий `mirofish-state` в папку с проектом Trading Pulse, используя SSH-ссылку:
```bash
git clone git@github.com:nsudiyan/mirofish-state.git
```

### Настройка cron
Добавьте скрипт `publish_feed.sh` в планировщик `cron` для выполнения каждые 5 минут:
1. Откройте crontab для редактирования:
   ```bash
   crontab -e
   ```
2. Добавьте следующую строку, заменив `/путь/к/папке` на реальный абсолютный путь до `publish_feed.sh`:
   ```cron
   */5 * * * * /путь/к/папке/publish_feed.sh >> /путь/к/папке/publish_feed.log 2>&1
   ```
