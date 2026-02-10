//
//  SignInWithAppleReducer.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 10. 2. 2026..
//

import Supabase
import ComposableArchitecture

public enum SignInWithAppleError: Error {
    
    case systemError
    
    case invalidAuthorizationCredentialType
    case undefinedIdentityToken
    case invalidIdentityToken
    
    case signInWithSupabaseDidFail
}

@Reducer
public struct SignInWithAppleReducer {
    
    @Dependency(\.signInWithAppleClient.signInWithSupabase) var signInWithSupabase
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        public init() {}
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
                guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                    debugPrint("!!! SignInWithAppleError.invalidAuthorizationCredentialType")
                    return .none
                }
                guard let identityToken = credential.identityToken else {
                    debugPrint("!!! SignInWithAppleError.undefinedIdentityToken")
                    return .none
                }
                guard let identityTokenString = String(data: identityToken, encoding: .utf8) else {
                    debugPrint("!!! SignInWithAppleError.invalidIdentityToken")
                    return .none
                }
                return .send(.signInWithSupabase(identityTokenString))
            case let .handleCompletionResult(.failure(error)):
                debugPrint("!!! SignInWithAppleError.systemError")
                debugPrint("Sign in with Apple failed: \(error.localizedDescription)")
                return .none
                
            case let .signInWithSupabase(identityToken):
                return .run { [identityToken = identityToken, signInWithSupabase] send in
                    await send(.signInWithSupabaseResult(Result {
                        try await signInWithSupabase(identityToken)
                    }))
                }
            case .signInWithSupabaseResult(.success):
                return .none
            case let .signInWithSupabaseResult(.failure(error)):
                debugPrint("!!! SignInWithAppleError.signInWithSupabaseDidFail")
                debugPrint(error.localizedDescription)
                return .none
            }
        }
    }
}

// MARK: - Remove below

import SwiftUI
import AuthenticationServices

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
