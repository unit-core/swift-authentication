//
//  SignInWithEmailAndPasswordReducerTests.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 15. 2. 2026..
//

import Foundation
import Testing
import ComposableArchitecture
import Dependencies
import AuthenticationServices
@testable import UnitcoreAuthentication

@MainActor
struct SignInWithEmailAndPasswordReducerTests {
    
    @Test
    func testSignIn_WithValidCredentials_ShouldSucceed() async throws {
        let store = TestStore(
            initialState: SignInWithEmailAndPasswordReducer.State.init(),
            reducer: { SignInWithEmailAndPasswordReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in }
            }
        )
        await store.send(.set(\.email, "simple@example.com")) {
            $0.email = "simple@example.com"
        }
        await store.send(.set(\.password, "Password123")) {
            $0.password = "Password123"
        }
        await store.send(.signIn) {
            $0.uiState = .processing
        }
        await store.receive(\.signInResult) {
            $0.uiState = .signedIn
        }
    }
    
    @Test
    func testSignIn_WithInvalidEmail_ShouldSetInvalidEmailError() async throws {
        let store = TestStore(
            initialState: SignInWithEmailAndPasswordReducer.State.init(),
            reducer: { SignInWithEmailAndPasswordReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in }
            }
        )
        await store.send(.set(\.email, "@example.com")) {
            $0.email = "@example.com"
        }
        await store.send(.signIn) {
            $0.uiState = .error(.invalidEmail)
        }
    }
    
    @Test
    func testSignIn_WithInvalidEmail_And_ResetUiStateAfterEditing() async throws {
        let store = TestStore(
            initialState: SignInWithEmailAndPasswordReducer.State.init(),
            reducer: { SignInWithEmailAndPasswordReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in }
            }
        )
        await store.send(.set(\.email, "@example.com")) {
            $0.email = "@example.com"
        }
        await store.send(.signIn) {
            $0.uiState = .error(.invalidEmail)
        }
        await store.send(.set(\.email, "1")) {
            $0.email = "1"
            $0.uiState = .idle
        }
    }
    
    @Test
    func testSignIn_WithInvalidPassword_And_ResetUiStateAfterEditing() async throws {
        let store = TestStore(
            initialState: SignInWithEmailAndPasswordReducer.State.init(),
            reducer: { SignInWithEmailAndPasswordReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in }
            }
        )
        await store.send(.set(\.email, "simple@example.com")) {
            $0.email = "simple@example.com"
        }
        await store.send(.set(\.password, "Pass1")) {
            $0.password = "Pass1"
        }
        await store.send(.signIn) {
            $0.uiState = .error(.invalidPassword)
        }
        await store.send(.set(\.password, "1")) {
            $0.password = "1"
            $0.uiState = .idle
        }
    }
    
    @Test
    func testSignIn_WithInvalidPassword_ShouldSetInvalidPasswordError() async throws {
        let store = TestStore(
            initialState: SignInWithEmailAndPasswordReducer.State.init(),
            reducer: { SignInWithEmailAndPasswordReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in }
            }
        )
        await store.send(.set(\.email, "simple@example.com")) {
            $0.email = "simple@example.com"
        }
        await store.send(.set(\.password, "Pass1")) {
            $0.password = "Pass1"
        }
        await store.send(.signIn) {
            $0.uiState = .error(.invalidPassword)
        }
    }
    
    @Test
    func testSignIn_WithDependencyFailure_ShouldSetSignInDidFailError() async throws {
        enum TestError: Error {
            case test
        }
        let store = TestStore(
            initialState: SignInWithEmailAndPasswordReducer.State.init(),
            reducer: { SignInWithEmailAndPasswordReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in throw TestError.test }
            }
        )
        await store.send(.set(\.email, "simple@example.com")) {
            $0.email = "simple@example.com"
        }
        await store.send(.set(\.password, "Password123")) {
            $0.password = "Password123"
        }
        await store.send(.signIn) {
            $0.uiState = .processing
        }
        await store.receive(\.signInResult) {
            $0.uiState = .error(.signInDidFail(TestError.test))
        }
    }

    @Test
    func testSignIn_ClearsFocusedField() async throws {
        var initialState = SignInWithEmailAndPasswordReducer.State()
        initialState.email = "simple@example.com"
        initialState.password = "Password123"
        initialState.focusedField = .email
        let store = TestStore(
            initialState: initialState,
            reducer: { SignInWithEmailAndPasswordReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in }
            }
        )
        await store.send(.signIn) {
            $0.focusedField = nil
            $0.uiState = .processing
        }
        await store.receive(\.signInResult) {
            $0.uiState = .signedIn
        }
    }

    @Test
    func testSignIn_WithEmptyEmail_ShouldSetInvalidEmailError() async throws {
        let store = TestStore(
            initialState: SignInWithEmailAndPasswordReducer.State.init(),
            reducer: { SignInWithEmailAndPasswordReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in }
            }
        )
        await store.send(.signIn) {
            $0.uiState = .error(.invalidEmail)
        }
    }

    @Test
    func testSignIn_WithEmptyPassword_ShouldSetInvalidPasswordError() async throws {
        var initialState = SignInWithEmailAndPasswordReducer.State()
        initialState.email = "simple@example.com"
        let store = TestStore(
            initialState: initialState,
            reducer: { SignInWithEmailAndPasswordReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in }
            }
        )
        await store.send(.signIn) {
            $0.uiState = .error(.invalidPassword)
        }
    }
}
