#!/bin/bash

echo "🌐 Умный Водитель 2.0 - Веб-демо"
echo "==============================="
echo ""

if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter SDK не найден!"
    exit 1
fi

echo "✅ Запуск веб-демо..."
echo ""
echo "⚠️  Внимание: В веб-версии не работают:"
echo "   - GPS (используйте демо-режим)"
echo "   - TTS (голосовые подсказки)"
echo "   - Вибрация"
echo ""
echo "Открываю браузер..."
echo ""

flutter run -d chrome
