//
//  AuthenticationReducer.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 12. 2. 2026..
//

import ComposableArchitecture
import SwiftUI
import Perception

@Reducer
public struct AuthenticationReducer {
    
    @ObservableState
    public struct State: Equatable {
        
        var emailAndPassword: SignInWithEmailAndPasswordReducer.State = .init()
        var apple: SignInWithAppleReducer.State = .init()
        
        var welcomeText: TypewriterReducer.State = .init(fullText: "Welcome")
        
        public init() {}
    }
    
    public enum Action {
        case emailAndPassword(SignInWithEmailAndPasswordReducer.Action)
        case apple(SignInWithAppleReducer.Action)
        case welcomeText(TypewriterReducer.Action)
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.emailAndPassword, action: \.emailAndPassword, child: {
            SignInWithEmailAndPasswordReducer()
        })
        Scope(state: \.apple, action: \.apple, child: {
            SignInWithAppleReducer()
        })
        Scope(state: \.welcomeText, action: \.welcomeText, child: {
            TypewriterReducer()
        })
    }
}

public struct AuthenticationView: View {
    
    @Bindable var store: StoreOf<AuthenticationReducer>
    
    public init(store: StoreOf<AuthenticationReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Spacer()
            TypewriterView(
                store: store.scope(state: \.welcomeText, action: \.welcomeText)
            )
            .font(.largeTitle)
            .fontWeight(.bold)
            Spacer()
            SignInWithEmailAndPasswordView(store: store.scope(state: \.emailAndPassword, action: \.emailAndPassword))
            Text("OR")
                .font(.caption)
                .foregroundStyle(.secondary)
            SignInWithAppleView(store: store.scope(state: \.apple, action: \.apple))
                .frame(height: 56)
        }
        .padding(.horizontal)
        .onTapGesture(perform: {
            store.send(.emailAndPassword(.binding(.set(\.focusedField, nil))))
        })
        .onAppear(perform: {
            store.send(.welcomeText(.start))
        })
    }
}

#Preview {
    AuthenticationView(store: StoreOf<AuthenticationReducer>.init(
        initialState: AuthenticationReducer.State.init(),
        reducer: { AuthenticationReducer() }
    ))
}

