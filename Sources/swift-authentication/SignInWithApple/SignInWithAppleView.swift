//
//  SignInWithAppleView.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 12. 2. 2026..
//

import SwiftUI
import AuthenticationServices
import ComposableArchitecture

public struct SignInWithAppleView: View {
    
    @Bindable var store: StoreOf<SignInWithAppleReducer>
    
    public init(store: StoreOf<SignInWithAppleReducer>) {
        self.store = store
    }
    
    public var body: some View {
        AuthenticationServices.SignInWithAppleButton { (request: AuthenticationServices.ASAuthorizationAppleIDRequest) in
            request.requestedScopes = store.requestedScopes
        } onCompletion: { (result: Result<AuthenticationServices.ASAuthorization, any Error>) in
            store.send(.handleCompletionResult(
                result.map({ AppleAuthorization(authorization: $0) })
            ))
        }
    }
}

#Preview {
    SignInWithAppleView(store: StoreOf<SignInWithAppleReducer>.init(
        initialState: SignInWithAppleReducer.State.init(),
        reducer: { SignInWithAppleReducer() }
    ))
}
