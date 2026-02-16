//
//  PasswordValidatorTests.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 12. 2. 2026..
//

import Foundation
import Testing
import ComposableArchitecture
import Dependencies
import AuthenticationServices
@testable import UnitcoreAuthentication

@MainActor
struct PasswordValidatorTests {
    
    @Test(.serialized, arguments: [
        "Password123",       // Стандартный кейс
        "Aa123456",          // Ровно 8 символов (минимальная длина)
        "123456Aa",          // Цифры в начале
        "correctHorseBatteryStaple1", // Очень длинный пароль
        "Pass!234",          // Спецсимволы (допустимы, хотя и не обязательны в этом regex)
        "Z0a....."           // Минимум букв/цифр, остальное точки
    ])
    func testValidPasswords(_ password: String) async throws {
        @Dependency(\.passwordValidator) var passwordValidator
        #expect(passwordValidator(password), "Пароль '\(password)' должен быть валидным")
    }
    
    @Test(.serialized, arguments: [
        "",                  // Пустой
        "Pass1",             // Слишком короткий (5 символов)
        "Pass123",           // 7 символов (почти, но нет)
        "P a s s 1 2 3",     // Пробелы (если ваша бизнес-логика их разрешает, regex пропустит)
        
        "password123",       // Нет заглавной буквы
        "PASSWORD123",       // Нет строчной буквы
        "Password",          // Нет цифры
        "Password!",         // Нет цифры (даже со спецсимволом)
        
        "12345678",          // Только цифры
        "ABCDEFGH",          // Только заглавные
        "abcdefgh",          // Только строчные
        
        ".......1",          // Нет букв
        "       1A",         // Пробелы вместо букв (зависит от логики, но regex требует [a-z] и [A-Z])
        "\nNewLin1A"         // Перенос строки (обычно точка . в regex не матчит \n)
    ])
    func testInvalidPasswords(_ password: String) async throws {
        @Dependency(\.passwordValidator) var passwordValidator
        #expect(!passwordValidator(password), "Пароль '\(password)' должен быть не валидным")
    }
}
