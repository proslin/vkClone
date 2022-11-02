//
//  ErrorMessage.swift
//  vkClient
//
//  Created by Lina Prosvetova on 31.10.2022.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidUsername     = "Создан некорректный запрос. Попробуйте снова."
    case unableToComplete    = "Невозможно выполнить запрос. Проверьте соединение с интернетом."
    case invalidResponse     = "Некорректный ответ сервера. Попробуйте снова."
    case invalidData         = "Получены некорректные данные от сервера."
}
