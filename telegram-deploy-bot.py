#!/usr/bin/env python3
"""
Telegram Bot для отправки готового APK пользователю
"""
import asyncio
import os
from telegram import Bot

# Токен от пользователя
BOT_TOKEN = "8679357716:AAGYiHkx_iVYmeATd2bMy6QUKg-OSZWgccE"

# Chat ID пользователя (Евгений @GURU_707)
CHAT_ID = 5928067034

async def send_apk():
    """Отправить APK файл пользователю"""
    bot = Bot(token=BOT_TOKEN)
    
    # Путь к APK файлу
    apk_path = "/home/openclaw/.openclaw/workspace/projects/smart-driver-2/build/app/outputs/flutter-apk/app-release.apk"
    
    if not os.path.exists(apk_path):
        # Если APK не найден, отправляем сообщение
        await bot.send_message(
            chat_id=CHAT_ID,
            text="❌ APK файл не найден. Начинаю сборку...\n\n"
                 "Это займёт ~15-20 минут. Я уведомлю вас когда будет готово! 🚀"
        )
        return False
    
    # Проверяем размер файла
    file_size = os.path.getsize(apk_path)
    file_size_mb = file_size / (1024 * 1024)
    
    # Отправляем файл
    await bot.send_message(
        chat_id=CHAT_ID,
        text=f"🎉 **Умный Водитель 2.0** готов!\n\n"
             f"📦 Размер: {file_size_mb:.1f} MB\n"
             f"📱 Установка: откройте файл на Android устройстве\n\n"
             f"Отправляю APK...",
        parse_mode="Markdown"
    )
    
    with open(apk_path, 'rb') as apk_file:
        await bot.send_document(
            chat_id=CHAT_ID,
            document=apk_file,
            filename="UmnyiVoditel-2.0.apk",
            caption="✅ Установите файл на Android устройстве\n\n"
                    "⚠️ При установке разрешите \"Установку из неизвестных источников\""
        )
    
    print(f"✅ APK отправлен пользователю! Размер: {file_size_mb:.1f} MB")
    return True

async def send_build_status(status: str, message: str):
    """Отправить статус сборки"""
    bot = Bot(token=BOT_TOKEN)
    
    emoji = {
        "start": "🚀",
        "progress": "⏳",
        "success": "✅",
        "error": "❌"
    }.get(status, "ℹ️")
    
    await bot.send_message(
        chat_id=CHAT_ID,
        text=f"{emoji} {message}",
        parse_mode="Markdown"
    )

if __name__ == "__main__":
    # Проверяем существование APK и отправляем
    asyncio.run(send_apk())
