//
//  AuthenticationReducer.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 12. 2. 2026..
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct AuthenticationReducer {
    
    @ObservableState
    public struct State: Equatable {
        
        var emailAndPassword: SignInWithEmailAndPasswordReducer.State = .init()
        var apple: SignInWithAppleReducer.State = .init()
        
        public init() {}
    }
    
    public enum Action {
        case emailAndPassword(SignInWithEmailAndPasswordReducer.Action)
        case apple(SignInWithAppleReducer.Action)
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.emailAndPassword, action: \.emailAndPassword, child: {
            SignInWithEmailAndPasswordReducer()
        })
        Scope(state: \.apple, action: \.apple, child: {
            SignInWithAppleReducer()
        })
    }
}

public struct AuthenticationView: View {
    
    @ComposableArchitecture.Bindable var store: StoreOf<AuthenticationReducer>
    
    public init(store: StoreOf<AuthenticationReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Spacer()
            SignInWithEmailAndPasswordView(store: store.scope(state: \.emailAndPassword, action: \.emailAndPassword))
            Text("OR")
                .font(.caption)
                .foregroundStyle(.secondary)
            SignInWithAppleView(store: store.scope(state: \.apple, action: \.apple))
                .frame(height: 56)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AuthenticationView(store: StoreOf<AuthenticationReducer>.init(
        initialState: AuthenticationReducer.State.init(),
        reducer: { AuthenticationReducer() }
    ))
}
