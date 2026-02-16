//
//  SignInWithAppleClient.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 10. 2. 2026..
//

import Dependencies
import DependenciesMacros

@DependencyClient
public struct SignInClient: Sendable {
    public var signInWithApple: @Sendable (_ identityToken: String) async throws -> Void
    public var signInWithEmailAndPassword: @Sendable (_ email: String, _ password: String) async throws -> Void
}

private enum SignInClientKey: DependencyKey {

    static let liveValue = SignInClient()

    static let previewValue = SignInClient(
        signInWithApple: { identityToken in },
        signInWithEmailAndPassword: { email , password in }
    )
    
    static let testValue: SignInClient = SignInClient()
}

extension DependencyValues {
    public var signInClient: SignInClient {
        get { self[SignInClientKey.self] }
        set { self[SignInClientKey.self] = newValue }
    }
}
