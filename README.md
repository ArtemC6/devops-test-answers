# Тестовое задание: DevOps-инженер

Письменные ответы на 13 вопросов: Linux, bash, MySQL, Nginx, диагностика серверов по atop, отказоустойчивая архитектура, Ansible.

## Что в репозитории

| Файл | Что внутри |
|---|---|
| [`ANSWERS.md`](ANSWERS.md) | Ответы на все вопросы, по разделу на вопрос |
| [`scripts/check_file.sh`](scripts/check_file.sh) | Исправленная версия скрипта из вопроса 2 |
| [`nginx/block-random-query.conf`](nginx/block-random-query.conf) | Блокировка запросов `GET /?[a-z]{16}` (вопрос 8) |
| [`fail2ban/filter.d/nginx-random-query.conf`](fail2ban/filter.d/nginx-random-query.conf), [`fail2ban/jail.d/nginx-random-query.local`](fail2ban/jail.d/nginx-random-query.local) | Бан источников таких запросов на уровне файрвола (вопрос 8) |

## Как проверить

Скрипт из вопроса 2:

```bash
chmod +x scripts/check_file.sh
shellcheck scripts/check_file.sh

./scripts/check_file.sh;               echo "exit=$?"   # usage, exit=2
./scripts/check_file.sh /etc/hosts;    echo "exit=$?"   # File exists, exit=0
touch "my file.txt"
./scripts/check_file.sh "my file.txt"; echo "exit=$?"   # File exists, exit=0
./scripts/check_file.sh /nonexistent;  echo "exit=$?"   # does not exist, exit=1
```

Для сравнения: исходный скрипт без аргумента печатает `File exists` (`[ -f ]` с одним аргументом проверяет только, что строка `-f` не пустая).

Nginx (вопрос 8): блок `map` — в контекст `http`, проверка `if ($block_random_query) { return 444; }` — в нужные `server`. Затем `nginx -t && systemctl reload nginx` и запросы `curl` из комментариев в файле.

Fail2ban: файлы скопировать в `/etc/fail2ban/filter.d/` и `/etc/fail2ban/jail.d/`, проверить фильтр на своём логе через `fail2ban-regex`, затем `systemctl reload fail2ban`.

## Решения и допущения

- **Вопросы 10 и 11** разобраны по двум скриншотам atop из задания и оформлены как ответ клиенту. Выводы, которые можно подтвердить только на самом сервере, перечислены вместе с командами для проверки (`/proc/mdstat`, SMART, история atop).
- **Вопрос 9:** «самый тяжёлый» определяю по объёму работы (`Rows_examined`), а не по `Query_time`, в которое входит ожидание. Обоснование и оптимизация — в ответе.
- **Вопрос 12:** страница роли по ссылке из задания у меня не открылась (требует входа/JavaScript). Поэтому ответ описывает, где в роли искать явные и неявные зависимости и какие они обычно у роли такого типа. С кодом роли перечислю конкретно.
- **Вопросы 6 и 7:** размеры серверов — стартовая оценка без данных о реальной нагрузке, в ответах перечислено, что нужно уточнить у клиента для точного расчёта.
- Конфиги и скрипт написаны как готовые к применению, но в рамках задания на сервере не запускались.
