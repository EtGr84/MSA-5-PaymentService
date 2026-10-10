# Task5. Таблица тест-кейсов

| Название                                                                              | Тип | Компоненты | Предусловия |
|---------------------------------------------------------------------------------------|-----|------------|-------------|
| Компенсационный сценарий после pivot выполняется корректно (reverse -> refund)        | Интеграционный | Payment Orchestrator, workers `reverse-merchant-transfer`, `refund-customer`, Zeebe | Процесс находится в compensation flow |
| Возврат средств клиенту после reject-ветки                                            | Интеграционный | Payment Orchestrator, worker `refund-customer`, Zeebe | Antifraud/manual review завершились отказом |
| Отправка уведомлений в success и reject сценариях                                     | Интеграционный | Payment Orchestrator, workers `notify-success`, `notify-rejection`, Zeebe | Процесс завершает success или reject flow |
| Ручная проверка с отказом оператора | E2E | Zeebe, Payment Orchestrator, PostgreSQL, все worker'ы | Полный стек запущен, antifraud возвращает `MANUAL_REVIEW`, затем отправляется сообщение ручного отказа |
| Успешное списание/резервирование средств клиента                                      | Интеграционный | Payment Orchestrator, worker `reserve-funds`, Zeebe | Процесс запущен, платёж создан |
| Ошибка списания средств приводит к отклонению процесса                                | Интеграционный | Payment Orchestrator, worker `reserve-funds`, Zeebe | Worker списания возвращает ошибку |
| Antifraud обрабатывает все основные решения (`APPROVED`, `REJECTED`, `MANUAL_REVIEW`) | Интеграционный | Payment Orchestrator, worker `fraud-check`, Zeebe | Средства успешно списаны, antifraud возвращает разные решения |
| Cut-off-time при отсутствии ответа оператора | E2E | Zeebe, Payment Orchestrator, PostgreSQL, все worker'ы | Полный стек запущен, antifraud возвращает `MANUAL_REVIEW`, ручное решение не приходит до истечения таймера |
| Полный успешный сценарий платежа (happy path) | E2E | Zeebe, Payment Orchestrator, PostgreSQL, Redis, все worker'ы | Полный docker-compose стек запущен, BPMN задеплоен, antifraud возвращает `APPROVED`, перевод контрагенту успешен |
| Отклонение antifraud -> автоматический возврат средств | E2E | Zeebe, Payment Orchestrator, PostgreSQL, все worker'ы | Полный стек запущен, antifraud возвращает `REJECTED` |
| Ручная проверка с подтверждением оператором | E2E | Zeebe, Payment Orchestrator, PostgreSQL, все worker'ы | Полный стек запущен, antifraud возвращает `MANUAL_REVIEW`, затем отправляется сообщение ручного подтверждения |
| Создание платежа и запуск процесса                                                    | Интеграционный | Payment Orchestrator, Zeebe, PostgreSQL | Zeebe и PostgreSQL запущены через Testcontainers, BPMN-процесс задеплоен |
| Ручная проверка: оператор принимает решение                                           | Интеграционный | Payment Orchestrator, Zeebe, message correlation | Процесс находится на `Task_ManualReview`, отправляется сообщение |
| Срабатывание cut-off при отсутствии ручного решения                                   | Интеграционный | Payment Orchestrator, Zeebe, timer boundary event | Процесс находится в ожидании ручной проверки |
| Ошибка перевода контрагенту переводит процесс в compensation flow                     | Интеграционный | Payment Orchestrator, worker `transfer-to-merchant`, Zeebe | Transfer worker возвращает ошибку |
| Компенсация после ошибки после pivot-точки | E2E | Zeebe, Payment Orchestrator, PostgreSQL, все worker'ы | Полный стек запущен, antifraud возвращает `APPROVED`, перевод контрагенту выполнен, затем эмулируется post-pivot failure |

# Уточнения

---
1. Основную часть сценариев, ошибок и компенсаций покрывают интеграционные тесты
2. Критичные сквозные бизнес-процессы покрывают E2E тесты
3. Проверяются отдельно: архитектурыне ограничения, отказоустойчиовать, соглашение об уровне сервиса.
