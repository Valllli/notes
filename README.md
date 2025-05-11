# 📒 Заметки — Flutter-приложение

Простое Flutter-приложение для создания, редактирования и удаления текстовых и аудио заметок с локальным хранением данных.

---

## 🚀 Как запустить проект

1. Установи Flutter SDK: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
2. Клонируй репозиторий:
   ```bash
   git clone https://github.com/Valllli/notes.git
   cd notes-app
   ```
3. Установи зависимости:
   ```bash
   flutter pub get
   ```
4. Запусти приложение:
   ```bash
   flutter run
   ```

---

## 🧱 Архитектура

В проекте используется подход **MVVM + Clean Architecture**:

- **Model** — сущности `Note`, работа с хранилищем
- **ViewModel** — `NoteViewModel` управляет состоянием и логикой заметок
- **View (UI)** — `NoteListScreen`, `NoteEditScreen`,`AudioNoteScreen`, `SettingsScreen`
- Разделение слоёв по папкам: `data`, `domain`, `presentation`

**Управление состоянием:** реализовано через [`provider`](https://pub.dev/packages/provider)

---

## ✨ Дополнительные фичи

- ✅ Тёмная и светлая тема (можно переключать в настройках)
- ✅ BottomNavigationBar с переключением между заметками и настройками
- ✅ Удаление заметок свайпом или по кнопке
- ✅ Валидация полей (заголовок обязателен, не допускается только пробел)
- ✅ Обработка ошибок при сохранении (с отображением SnackBar)
- ✅ Реализованно 2 вида заметок: Текст и Аудио  
- ⚙️ Поддержка Flutter Web (опционально, если включено)
- 🧪 Мини-тесты: 1-2 unit/widget теста (если добавлены)

---