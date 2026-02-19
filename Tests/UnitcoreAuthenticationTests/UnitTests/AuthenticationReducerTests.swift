//
//  AuthenticationReducerTests.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 19. 2. 2026..
//

import Foundation
import Testing
import ComposableArchitecture
import Dependencies
import AuthenticationServices
@testable import UnitcoreAuthentication

@MainActor
struct AuthenticationReducerTests {

    @Test
    func testInitialState_DefaultValues() {
        let state = AuthenticationReducer.State()
        #expect(state.isDismissButtonHidden == false)
        #expect(state.interactiveDismissDisabled == false)
        #expect(state.isPresented == false)
    }

    @Test
    func testInitialState_CustomValues() {
        let state = AuthenticationReducer.State(
            isDismissButtonHidden: true,
            interactiveDismissDisabled: true,
            isPresented: true
        )
        #expect(state.isDismissButtonHidden == true)
        #expect(state.interactiveDismissDisabled == true)
        #expect(state.isPresented == true)
    }

    @Test
    func testIsPresented_WithTrue_SetsIsPresented() async throws {
        let store = TestStore(
            initialState: AuthenticationReducer.State(),
            reducer: { AuthenticationReducer() }
        )
        await store.send(.isPresented(true)) {
            $0.isPresented = true
        }
    }

    @Test
    func testIsPresented_WithFalse_SetsIsPresented() async throws {
        let store = TestStore(
            initialState: AuthenticationReducer.State(isPresented: true),
            reducer: { AuthenticationReducer() }
        )
        await store.send(.isPresented(false)) {
            $0.isPresented = false
        }
    }

    @Test
    func testChildAction_EmailAndPassword_WithInvalidEmail_SetsError() async throws {
        let store = TestStore(
            initialState: AuthenticationReducer.State(),
            reducer: { AuthenticationReducer() },
            withDependencies: {
                $0.signInClient.signInWithEmailAndPassword = { _, _ in }
            }
        )
        await store.send(.emailAndPassword(.signIn)) {
            $0.emailAndPassword.uiState = .error(.invalidEmail)
        }
    }

    @Test
    func testChildAction_Apple_WithSystemError_SetsError() async throws {
        enum TestError: Error {
            case test
        }
        let store = TestStore(
            initialState: AuthenticationReducer.State(),
            reducer: { AuthenticationReducer() },
            withDependencies: {
                $0.signInClient.signInWithApple = { _ in }
            }
        )
        await store.send(.apple(.handleCompletionResult(.failure(TestError.test)))) {
            $0.apple.status = .error(.systemError(TestError.test))
        }
    }

    @Test
    func testChildAction_WelcomeText_SetFullText_UpdatesText() async throws {
        let store = TestStore(
            initialState: AuthenticationReducer.State(),
            reducer: { AuthenticationReducer() }
        )
        await store.send(.welcomeText(.setFullText("Hello"))) {
            $0.welcomeText.fullText = "Hello"
        }
    }

    @Test
    func testBinding_UpdatesIsDismissButtonHidden() async throws {
        let store = TestStore(
            initialState: AuthenticationReducer.State(),
            reducer: { AuthenticationReducer() }
        )
        await store.send(.set(\.isDismissButtonHidden, true)) {
            $0.isDismissButtonHidden = true
        }
    }

    @Test
    func testBinding_UpdatesInteractiveDismissDisabled() async throws {
        let store = TestStore(
            initialState: AuthenticationReducer.State(),
            reducer: { AuthenticationReducer() }
        )
        await store.send(.set(\.interactiveDismissDisabled, true)) {
            $0.interactiveDismissDisabled = true
        }
    }
}
