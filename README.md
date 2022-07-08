# Photo

## Description

Приложение для просмотра фотографий.
На первой вкладке — коллекция случайных фотографий с Unsplash. Вверху строка поиска по фотографиям с Unsplash. При нажатии на ячейку пользователь попадает на экран подробной информации.</br>
На второй вкладке — список любимых фотографий. При нажатии на ячейку — переход в экран подробной информации.
Экран подробной информации содержит в себе фотографию, имя автора, дату создания, местоположение и количество скачиваний.
Также экран содержит кнопку, нажатие на которую может добавить фотографию в список любимых фотографий и удалить из него.
API – https://unsplash.com/documentation

## Preview

### Просмотр случайных и избранных фото 

![Simulator Screen Recording - iPhone 13 - 2022-07-08 at 10 07 19](https://user-images.githubusercontent.com/72994567/177937119-e634d95c-f739-4267-8dca-909a43385b13.gif)

### Поиск случайных фото

![Simulator Screen Recording - iPhone 13 - 2022-07-08 at 10 15 07](https://user-images.githubusercontent.com/72994567/177938021-86d9e6d0-adc2-4962-a84f-eff2cbd8a018.gif)

### Добавление / удаление фото из списка избранных

![Simulator Screen Recording - iPhone 13 - 2022-07-08 at 10 09 04](https://user-images.githubusercontent.com/72994567/177937262-6a99268c-08a0-483d-b867-2802afbb1da4.gif)

## Settings

Перед запуском необходимо добавить файл *.xcconfig со значением API_KEY для работы с Unsplash в корневой каталог проекта.</br>
Пример - https://medium.com/swift-india/secure-secrets-in-ios-app-9f66085800b4

## Stack

- Swift
- UIKit
- Storyboards
- Combine
- SDWebImage
- MVVM
