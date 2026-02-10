//
//  SignInWithAppleReducer.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 10. 2. 2026..
//

import Supabase
import ComposableArchitecture
import AuthenticationServices

public enum SignInWithAppleError: Error {
    
    case systemError
    
    case invalidAuthorizationCredentialType
    case undefinedIdentityToken
    case invalidIdentityToken
    
    case signInWithSupabaseDidFail
}

@Reducer
public struct SignInWithAppleReducer {
    
    @Dependency(\.signInClient.signInWithApple) var signInWithApple
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        var status: StateStatus = .idle
        
        public init() {}
    }
    
    public enum StateStatus: Equatable {
        case idle
        case success
        case error(SignInWithAppleError)
        case loading
    }
    
    public enum Action {
        
        case handleCompletionResult(Result<ASAuthorization, any Error>)
        
        case signInWithSupabase(_ identityToken: String)
        case signInWithSupabaseResult(Result<Void, any Error>)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .handleCompletionResult(.success(authorization)):
                state.status = .loading
                guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                    state.status = .error(.invalidAuthorizationCredentialType)
                    return .none
                }
                guard let identityToken = credential.identityToken else {
                    state.status = .error(.undefinedIdentityToken)
                    return .none
                }
                guard let identityTokenString = String(data: identityToken, encoding: .utf8) else {
                    state.status = .error(.invalidIdentityToken)
                    return .none
                }
                return .send(.signInWithSupabase(identityTokenString))
            case let .handleCompletionResult(.failure(error)):
                debugPrint("Sign in with Apple failed: \(error.localizedDescription)")
                state.status = .error(.systemError)
                return .none
                
            case let .signInWithSupabase(identityToken):
                return .run { [identityToken = identityToken, signInWithApple] send in
                    await send(.signInWithSupabaseResult(Result {
                        try await signInWithApple(identityToken)
                    }))
                }
            case .signInWithSupabaseResult(.success):
                state.status = .success
                return .none
            case let .signInWithSupabaseResult(.failure(error)):
                debugPrint(error.localizedDescription)
                state.status = .error(.signInWithSupabaseDidFail)
                return .none
            }
        }
    }
}

// MARK: - Remove below

import SwiftUI

struct SignInWithAppleScreenView: View {
    
    @ComposableArchitecture.Bindable var store: StoreOf<SignInWithAppleReducer>
    
    var body: some View {
        SignInWithAppleButton { (request: ASAuthorizationAppleIDRequest) in
            // request.requestedScopes = [.email, .fullName]
        } onCompletion: { (result: Result<ASAuthorization, any Error>) in
            store.send(.handleCompletionResult(result))
        }
    }
}
