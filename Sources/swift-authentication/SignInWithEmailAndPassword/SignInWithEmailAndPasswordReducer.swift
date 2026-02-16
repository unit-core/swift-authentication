//
//  SignInWithEmailReducer.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 12. 2. 2026..
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct SignInWithEmailAndPasswordReducer {
    
    @Dependency(\.signInClient.signInWithEmailAndPassword) var signInWithEmailAndPassword
    @Dependency(\.emailValidator) var emailValidator
    @Dependency(\.passwordValidator) var passwordValidator
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        var focusedField: Field?
        
        var email: String = ""
        var password: String = ""
        
        var isOtpHidden: Bool = false
        var isButtonEnabled: Bool = false
        
        var uiState: UIState = .idle
        
        let invalidColor: Color = .red
        
        public init() {}
        
        enum Field: String, Hashable {
            case email, password
        }
    }
    
    public enum UIState: Equatable {
        case idle
        case processing
        case error(SignInWithEmailAndPasswordError)
        case signedIn
    }

    public enum Action: BindableAction {
        case binding(_ action: BindingAction<State>)
        
        case signIn
        case signInResult(Result<Void, any Error>)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.email), .binding(\.password):
                state.uiState = .idle
                return .none
            case .signIn:
                guard emailValidator(state.email) else {
                    state.uiState = .error(.invalidEmail)
                    return .none
                }
                guard passwordValidator(state.password) else {
                    state.uiState = .error(.invalidPassword)
                    return .none
                }
                state.focusedField = nil
                state.uiState = .processing
                return .run { [
                    email = state.email,
                    password = state.password,
                    signInWithEmailAndPassword
                ] send in
                    await send(.signInResult(Result {
                        try await signInWithEmailAndPassword(email, password)
                    }))
                }

            case .signInResult(.success):
                state.uiState = .signedIn
                return .none
                
            case .signInResult(.failure(let error)):
                state.uiState = .error(.signInDidFail(error))
                return .none
            default:
                return .none
            }
        }
    }
}
