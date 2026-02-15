//
//  File.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 12. 2. 2026..
//

import ComposableArchitecture
import SwiftUI

extension DependencyValues {
    
    @available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
    var emailValidator: EmailValidator {
        get { self[EmailValidatorKey.self] }
        set { self[EmailValidatorKey.self] = newValue }
    }
}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
private enum EmailValidatorKey: DependencyKey {
    
    private static let regex =  "^[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?(?:\\.[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)*\\.[A-Za-z]{2,}$"
    
    static let liveValue = EmailValidator { email in
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: email)
    }
    
    static let previewValue = EmailValidator { email in
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: email)
    }
    
    static let testValue = EmailValidator { email in
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: email)
    }
}

struct EmailValidator: Sendable {

    private let handler: @Sendable (String) -> Bool
    
    public init(handler: @escaping @Sendable (String) -> Bool) {
        self.handler = handler
    }
    
    @available(watchOS, unavailable)
    @discardableResult
    func callAsFunction(_ email: String) -> Bool {
        self.handler(email)
    }
    
    @_disfavoredOverload
    func callAsFunction(_ email: String) {
        _ = self.handler(email)
    }
}

