//
//  SignInWithAppleReducerTests.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 10. 2. 2026..
//

import Foundation
import Testing
import ComposableArchitecture
import Dependencies
import AuthenticationServices
@testable import swift_authentication

@MainActor
struct SignInWithAppleReducerTests {
    
    @Test
    func testSignIn_WithValidCredentials_ShouldSucceed() async throws {
        let store = TestStore(
            initialState: SignInWithAppleReducer.State.init(),
            reducer: { SignInWithAppleReducer() },
            withDependencies: {
                $0.signInClient.signInWithApple = { _ in }
            }
        )
        await store.send(.handleCompletionResult(.success(
            AppleAuthorization.init(credential: AppleAuthorization.Credential.init(
                identityToken: "1".data(using: .utf8)
            ))
        ))) {
            $0.status = .processing
        }
        await store.receive(\.signInWithApple)
        await store.receive(\.signInWithAppleResult) {
            $0.status = .success
        }
    }
    
    @Test
    func testSignIn_WithAppleError_ShouldSetSystemError() async throws {
        enum TestError: Error {
            case test
        }
        let store = TestStore(
            initialState: SignInWithAppleReducer.State.init(),
            reducer: { SignInWithAppleReducer() },
            withDependencies: {
                $0.signInClient.signInWithApple = { _ in }
            }
        )
        await store.send(.handleCompletionResult(.failure(TestError.test))) {
            $0.status = .error(.systemError(TestError.test))
        }
    }
    
    @Test
    func testSignIn_WithMissingAuthorization_ShouldSetInvalidCredentialError() async throws {
        let store = TestStore(
            initialState: SignInWithAppleReducer.State.init(),
            reducer: { SignInWithAppleReducer() },
            withDependencies: {
                $0.signInClient.signInWithApple = { _ in }
            }
        )
        await store.send(.handleCompletionResult(.success(nil))) {
            $0.status = .error(.invalidAuthorizationCredentialType)
        }
    }
    
    @Test
    func testSignIn_WithMissingIdentityToken_ShouldSetUndefinedTokenError() async throws {
        let store = TestStore(
            initialState: SignInWithAppleReducer.State.init(),
            reducer: { SignInWithAppleReducer() },
            withDependencies: {
                $0.signInClient.signInWithApple = { _ in }
            }
        )
        await store.send(.handleCompletionResult(.success(
            AppleAuthorization.init(credential: AppleAuthorization.Credential.init(
                identityToken: nil
            ))
        ))) {
            $0.status = .error(.undefinedIdentityToken)
        }
    }
    
    @Test
    func testSignIn_WithInvalidTokenEncoding_ShouldSetInvalidTokenError() async throws {
        let store = TestStore(
            initialState: SignInWithAppleReducer.State.init(),
            reducer: { SignInWithAppleReducer() },
            withDependencies: {
                $0.signInClient.signInWithApple = { _ in }
            }
        )
        await store.send(.handleCompletionResult(.success(
            AppleAuthorization.init(credential: AppleAuthorization.Credential.init(
                identityToken: "1".data(using: .utf16)
            ))
        ))) {
            $0.status = .error(.invalidIdentityToken)
        }
    }
    
    @Test
    func testSignIn_WithSupabaseFailure_ShouldSetSupabaseError() async throws {
        enum TestError: Error {
            case test
        }
        let store = TestStore(
            initialState: SignInWithAppleReducer.State.init(),
            reducer: { SignInWithAppleReducer() },
            withDependencies: {
                $0.signInClient.signInWithApple = { _ in throw TestError.test }
            }
        )
        await store.send(.handleCompletionResult(.success(
            AppleAuthorization.init(credential: AppleAuthorization.Credential.init(
                identityToken: "1".data(using: .utf8)
            ))
        ))) {
            $0.status = .processing
        }
        await store.receive(\.signInWithApple)
        await store.receive(\.signInWithAppleResult) {
            $0.status = .error(.signInWithAppleDidFail(TestError.test))
        }
    }
}

