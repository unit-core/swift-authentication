//
//  File.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 11. 2. 2026..
//

import Foundation
import AuthenticationServices

public struct AppleAuthorization: Equatable, Sendable {
    
    public let credential: Credential
    
    public init(credential: Credential) {
        self.credential = credential
    }
    
    public init?(authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return nil
        }
        self.credential = Credential(
            identityToken: credential.identityToken
        )
    }
    
    public struct Credential: Equatable, Sendable {
        
        public let identityToken: Data?
        
        public init(
            identityToken: Data?
        ) {
            self.identityToken = identityToken
        }
    }
}
