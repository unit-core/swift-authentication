//
//  SignInWithAppleReducer.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 10. 2. 2026..
//

import ComposableArchitecture
import AuthenticationServices

@Reducer
public struct SignInWithAppleReducer {
    
    @Dependency(\.signInClient.signInWithApple) var signInWithApple
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        var requestedScopes: [ASAuthorization.Scope]? = [.email, .fullName]
        
        var status: UIState = .idle
        
        public init() {}
    }
    
    public enum UIState: Equatable {
        case idle
        case success
        case error(SignInWithAppleError)
        case processing
    }
    
    public enum Action {
        
        case handleCompletionResult(Result<AppleAuthorization?, any Error>)
        
        case signInWithApple(_ identityToken: String)
        case signInWithAppleResult(Result<Void, any Error>)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .handleCompletionResult(.success(authorization)):
                state.status = .processing
                guard let authorization else {
                    state.status = .error(.invalidAuthorizationCredentialType)
                    return .none
                }
                guard let identityToken = authorization.credential.identityToken else {
                    state.status = .error(.undefinedIdentityToken)
                    return .none
                }
                guard let identityTokenString = String(data: identityToken, encoding: .utf8) else {
                    state.status = .error(.invalidIdentityToken)
                    return .none
                }
                return .send(.signInWithApple(identityTokenString))
            case let .handleCompletionResult(.failure(error)):
                state.status = .error(.systemError(error))
                return .none
                
            case let .signInWithApple(identityToken):
                return .run { [identityToken = identityToken, signInWithApple] send in
                    await send(.signInWithAppleResult(Result {
                        try await signInWithApple(identityToken)
                    }))
                }
            case .signInWithAppleResult(.success):
                state.status = .success
                return .none
            case let .signInWithAppleResult(.failure(error)):
                state.status = .error(.signInWithAppleDidFail(error))
                return .none
            }
        }
    }
}
