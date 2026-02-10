//
//  SignInWithAppleClient.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 10. 2. 2026..
//

import Dependencies
import DependenciesMacros

@DependencyClient
struct SignInWithAppleClient: Sendable {
    var signInWithSupabase: @Sendable (_ identityToken: String) async throws -> Void
}

private enum SignInWithAppleClientKey: DependencyKey {

    static let liveValue = SignInWithAppleClient(
        signInWithSupabase: { identityToken in
//            try await client.auth.signInWithIdToken(
//                credentials: .init(
//                    provider: .apple,
//                    idToken: idToken
//                )
//            )
        }
    )

    static let previewValue = SignInWithAppleClient(
        signInWithSupabase: { identityToken in }
    )
}

extension DependencyValues {
    var signInWithAppleClient: SignInWithAppleClient {
        get { self[SignInWithAppleClientKey.self] }
        set { self[SignInWithAppleClientKey.self] = newValue }
    }
}
