//
//  PasswordValidator.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 15. 2. 2026..
//

import ComposableArchitecture
import SwiftUI

extension DependencyValues {
    
    @available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
    var passwordValidator: PasswordValidator {
        get { self[PasswordValidatorKey.self] }
        set { self[PasswordValidatorKey.self] = newValue }
    }
}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
private enum PasswordValidatorKey: DependencyKey {
    
    // ^                 - Начало строки
    // (?=.*[a-z])       - Есть хотя бы одна маленькая буква
    // (?=.*[A-Z])       - Есть хотя бы одна большая буква
    // (?=.*\\d)         - Есть хотя бы одна цифра (экранируем \d)
    // .{8,}             - Любые символы, длина минимум 8
    // $                 - Конец строки
    private static let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)\\S{8,}$"
    
    static let liveValue = PasswordValidator { password in
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: password)
    }
    
    static let previewValue = PasswordValidator { password in
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: password)
    }
    
    static let testValue = PasswordValidator { password in
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: password)
    }
}

struct PasswordValidator: Sendable {

    private let handler: @Sendable (String) -> Bool
    
    public init(handler: @escaping @Sendable (String) -> Bool) {
        self.handler = handler
    }
    
    @available(watchOS, unavailable)
    @discardableResult
    func callAsFunction(_ password: String) -> Bool {
        self.handler(password)
    }
    
    @_disfavoredOverload
    func callAsFunction(_ password: String) {
        _ = self.handler(password)
    }
}
