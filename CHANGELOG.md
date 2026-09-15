# Changelog

## 2026-09-15 — Этап 0: создан единый проект vpn-ru-direct

- Создан независимый проект.
- Начальный список перенесён из `vpn-split` без изменения исходного проекта.
- Первоначально включены `vk.com` и `vk.ru`.
- Создан source rule-set `ru-direct.json`.
- Создан compiled rule-set `ru-direct.srs`.
- Создан `build.ps1`.
- Rule-set проверен sing-box 1.14.
- Следующий этап: публикация и подключение remote rule-set к VPN-клиентам.

## 2026-09-15 — Этап 1: опубликован публичный GitHub rule-set

- Репозиторий `alexyabumba-dot/vpn-ru-direct` опубликован.
- Ветка: `main`.
- `ru-direct.json` доступен публично.
- `ru-direct.srs` доступен публично.
- RAW URL проверены без авторизации: оба вернули HTTP 200.
- Следующий этап: подключение remote rule-set к VPN-клиентам.
