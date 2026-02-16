//
//  AuthenticationView.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 16. 2. 2026..
//

import SwiftUI
import ComposableArchitecture

public struct AuthenticationView: View {
    
    @Bindable var store: StoreOf<AuthenticationReducer>
    
    public init(store: StoreOf<AuthenticationReducer>) {
        self.store = store
    }
    
    public var body: some View {
        
        NavigationStack {
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
            .padding([.horizontal, .bottom])
            .onTapGesture(perform: {
                store.send(.emailAndPassword(.binding(.set(\.focusedField, nil))))
            })
            .onAppear(perform: {
                store.send(.welcomeText(.start))
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    if !store.isDismissButtonHidden {
                        Button(
                            action: {
                                store.send(.isPresented(false))
                            },
                            label: {
                                Image(systemName: "xmark")
                            }
                        )
                    }
                })
            })
        }
        .interactiveDismissDisabled(store.interactiveDismissDisabled)
    }
}

#Preview {
    AuthenticationView(store: StoreOf<AuthenticationReducer>.init(
        initialState: AuthenticationReducer.State.init(),
        reducer: { AuthenticationReducer() }
    ))
}
