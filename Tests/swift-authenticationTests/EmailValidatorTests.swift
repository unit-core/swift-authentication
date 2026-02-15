//
//  EmailValidatorTests.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 12. 2. 2026..
//

import Foundation
import Testing
import ComposableArchitecture
import Dependencies
import AuthenticationServices
@testable import swift_authentication

@MainActor
struct EmailValidatorTests {
    
    @Test(.serialized, arguments: [
        // --- Базовые кейсы ---
        "simple@example.com",
        "first.last@example.com",
        "1234567890@example.com",
        "TEST@EXAMPLE.COM", // Case insensitive
        "a@b.cd", // Минимальная длина

        // --- Спецсимволы в Local Part ---
        "one-two@example.co.uk", // Дефис
        "user+tag@example.org",  // Плюс (алиасы)
        "user%name@example.com", // Процент
        "user_name@example.com", // Подчеркивание
        "o'connell@example.com", // Апостроф (ОЧЕНЬ ВАЖНО)
        "test/test@example.com", // Слэш (иногда встречается)
        "shark!#$&*@example.com", // Другие разрешенные символы (опционально)

        // --- Сложные домены ---
        "test@subdomain.example.com", // Поддомен
        "user@my-company.com",        // Дефис в домене
        "contact@startup.io",         // Современные короткие TLD
        "boss@very.long.domain.name.construction", // Длинный TLD
    ])
    func testValidEmails(_ argument: String) async throws {
        @Dependency(\.emailValidator) var emailValidator
        #expect(emailValidator(argument), "Email \(argument) должен быть валидным, но валидация не прошла")
    }
    
    @Test(.serialized, arguments: [
        // --- Пустые и структурные ошибки ---
        "",
        "plainaddress",
        "@example.com",
        "user@",
        "user@com",            // Нет TLD (хотя для localhost бывает валидно, в вебе обычно нет)
        "user@example.",       // Точка в конце
        "user@example.c",      // Слишком короткий TLD
        "user@.com",           // Нет домена второго уровня
        "user@name@example.com", // Две собаки

        // --- Недопустимые символы ---
        "почта@пример.рф",     // Кириллица (если вы не поддерживаете IDN)
        "user name@example.com", // Пробел в имени
        "user@ex ample.com",     // Пробел в домене
        "user\tname@example.com", // Табуляция
        "user\nname@example.com", // Перенос строки

        // --- Проблемы с точками (Local Part) ---
        ".user@example.com",     // Точка в начале
        "user.@example.com",     // Точка в конце имени
        "user..name@example.com", // Две точки подряд

        // --- Проблемы с дефисами (Domain) ---
        "email@example..com",    // Две точки в домене (уже было у вас)
        "user@-example.com",     // Дефис в начале домена
        "user@example-.com",     // Дефис в конце части домена
        "user@example.-com",     // Дефис сразу после точки

        // --- Специфические форматы (если вы их запрещаете) ---
        "user@192.168.1.1",      // IP без скобок (обычно невалидно)
        "user@[192.168.1.1]",    // IP в скобках (валидно по RFC, но часто запрещено в UI)
        
        // --- Обертки ---
        " user@example.com",     // Пробел в начале
        "user@example.com ",     // Пробел в конце
        "<user@example.com>"     // Скобки
    ])
    func testInvalidEmails(_ argument: String) async throws {
        @Dependency(\.emailValidator) var emailValidator
        #expect(!emailValidator(argument), "Email '\(argument)' должен считаться невалидным, но валидацию прошел")
    }
}
