//
//  SignInWithAppleError.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 11. 2. 2026..
//

import Foundation

public enum SignInWithAppleError: Error {
    
    case systemError(any Error)
    
    case invalidAuthorizationCredentialType
    case undefinedIdentityToken
    case invalidIdentityToken
    
    case signInWithAppleDidFail(any Error)
}

extension SignInWithAppleError: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}

extension SignInWithAppleError: Equatable {
    public static func == (lhs: SignInWithAppleError, rhs: SignInWithAppleError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidAuthorizationCredentialType, .invalidAuthorizationCredentialType):
            return true
        case (.undefinedIdentityToken, .undefinedIdentityToken):
            return true
        case (.invalidIdentityToken, .invalidIdentityToken):
            return true
        case (.signInWithAppleDidFail(let e1), .signInWithAppleDidFail(let e2)):
            return e1.localizedDescription == e2.localizedDescription
        case (.systemError(let e1), .systemError(let e2)):
            return e1.localizedDescription == e2.localizedDescription
        default:
            return false
        }
    }
}
