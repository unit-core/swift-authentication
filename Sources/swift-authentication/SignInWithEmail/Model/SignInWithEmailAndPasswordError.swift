//
//  SignInWithEmailAndPasswordError.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 15. 2. 2026..
//

import Foundation

public enum SignInWithEmailAndPasswordError: Error {
    
    case invalidEmail
    case invalidPassword
    
    case signInDidFail(any Error)
}

extension SignInWithEmailAndPasswordError: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}

extension SignInWithEmailAndPasswordError: Equatable {
    public static func == (lhs: SignInWithEmailAndPasswordError, rhs: SignInWithEmailAndPasswordError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidEmail, .invalidEmail):
            return true
        case (.invalidPassword, .invalidPassword):
            return true
        case (.signInDidFail(let e1), .signInDidFail(let e2)):
            return e1.localizedDescription == e2.localizedDescription
        default:
            return false
        }
    }
}

