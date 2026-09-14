# vpn-ru-direct

Единый пользовательский DIRECT whitelist для наших VPN и split-tunnel конфигураций.

## Принцип работы

```text
policy\services.json
        ↓
scripts\build.ps1
        ↓
generated\ru-direct.json
        ↓
generated\ru-direct.srs
        ↓
GitHub
        ↓
Windows / Android / iPhone
```

## Правила проекта

- Список не означает «весь `.ru`».
- Добавляются только выбранные нами сервисы.
- Список не зависит от конкретного VPN-транспорта.
- WireGuard, VLESS/Reality и будущий Hysteria2 используют один и тот же rule-set.
- Файлы в `generated` автоматически создаются из `policy\services.json`.

## Сборка

```powershell
.\scripts\build.ps1 -SingBoxPath "C:\path\to\sing-box.exe"
```

Скрипт проверяет policy, создаёт source JSON, компилирует SRS через sing-box 1.14 и сверяет набор доменов после обратного преобразования.
