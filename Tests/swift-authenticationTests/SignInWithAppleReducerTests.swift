//
//  SignInWithAppleReducerTests.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 10. 2. 2026..
//

import Testing
import ComposableArchitecture
import Dependencies
@testable import swift_authentication

@MainActor
struct SignInWithAppleReducerTests {
    
    @Test
    func example() async throws {
        let store = TestStore(
            initialState: SignInWithAppleReducer.State.init(),
            reducer: { SignInWithAppleReducer() },
            withDependencies: {
                $0.signInClient.signInWithApple = { _ in }
            }
        )
        await store.send(.signInWithSupabase("1"))
        await store.receive(\.signInWithSupabaseResult)
    }
}

