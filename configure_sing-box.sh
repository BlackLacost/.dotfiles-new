# Запрашиваем URL у пользователя
read -rp "Введите URL конфигурации: " config_url

# Проверяем, что URL введён
if [[ -z "$config_url" ]]; then
    echo "Ошибка: URL не введён." >&2
    exit 1
fi

# Скачать настройки, ссылку возьмите из своего бота
# Удаляем с помощью jq override_android_vpn и detour (на них ругается sing-box)
# Переносим direct в начало списка outbounds, чтобы по-умолчанию прокси не работал для всех адресов
curl -H 'user-agent: SFI' "$config_url" | jq '
  del(.route.override_android_vpn) |
  del(.dns.servers[] | select(.detour).detour) |
  .outbounds = (
    [.outbounds[] | select(.tag == "direct")] +
    [.outbounds[] | select(.tag != "direct")]
  )
' > /tmp/config.json
# Соединяем конфиги
ENABLE_DEPRECATED_SPECIAL_OUTBOUNDS=true sing-box merge ~/.config/vpn.json -c /tmp/config.json -c ~/.dotfiles-new/vpn.json

