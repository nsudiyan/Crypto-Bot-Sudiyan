# Crypto-Bot-Sudiyan

Этот репозиторий содержит материалы и инструменты для криптотрейдинга по стратегии скальпинга.

## Стратегия

Подробное описание торговой стратегии, скринеров (Trading Pulse, RedScalp) и терминала для торговли (MetaScalp) можно найти в документе:
[TRADING_STRATEGY.md](TRADING_STRATEGY.md)

## Управление состоянием (mirofish-state)
Сервер публикации Пульса может использовать SSH Deploy Key для выгрузки снимков в отдельный репозиторий `nsudiyan/mirofish-state`.
Для настройки:
1. Создайте ключ: `ssh-keygen -t ed25519 -f ~/.ssh/mirofish_deploy_key -N ""`
2. Добавьте `~/.ssh/mirofish_deploy_key.pub` как Deploy Key (c правами write) в репозиторий `mirofish-state` на GitHub.
3. Настройте скрипт публикации (например, `dashboard_feed.py` или ваш регулярный сервис) на использование этого ключа для выполнения `git push`, задав переменную окружения:
   `export GIT_SSH_COMMAND="ssh -i ~/.ssh/mirofish_deploy_key -o StrictHostKeyChecking=accept-new"`
