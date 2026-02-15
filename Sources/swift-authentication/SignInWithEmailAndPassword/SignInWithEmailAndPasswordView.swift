//
//  SignInWithEmailAndPasswordView.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 15. 2. 2026..
//

import SwiftUI
import ComposableArchitecture

public struct SignInWithEmailAndPasswordView: View {
    
    @ComposableArchitecture.Bindable var store: StoreOf<SignInWithEmailAndPasswordReducer>
    @SwiftUI.FocusState var focusedField: SignInWithEmailAndPasswordReducer.State.Field?
    
    public init(store: StoreOf<SignInWithEmailAndPasswordReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            TextField(text: $store.email) {
                Text(verbatim: "name@example.com")
            }
            .focused($focusedField, equals: .username)
            .padding(.horizontal)
            .frame(height: 56)
            .background(.secondary.opacity(0.2))
            
            if store.focusedField == .username {
                HStack {
                    Text("Latin letters, numbers, and special characters -_.+'! are supported.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .transition(.opacity)
            }
                
            HStack {
                if store.isOtpHidden {
                    SecureField("Password", text: $store.password)
                        .focused($focusedField, equals: .password)
                } else {
                    TextField("Password", text: $store.password)
                        .focused($focusedField, equals: .password)
                }
                Spacer()
                Button {
                    store.isOtpHidden.toggle()
                } label: {
                    Image(systemName: store.isOtpHidden ? "eye" : "eye.slash")
                }
            }
            .padding(.horizontal)
            .frame(height: 56)
            .background(.secondary.opacity(0.2))
            
            
            if store.focusedField == .password {
                HStack {
                    Text("At least 8 characters long and include an uppercase letter, a lowercase letter, and a number.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .transition(.opacity)
            }
            
            Button {
                store.send(.signIn)
            } label: {
                HStack {
                    Spacer()
                    Text("Sign in")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .frame(height: 56)
                .background(.blue)
            }
        }
        // Synchronize store focus state and local focus state.
        .bind($store.focusedField, to: $focusedField)
        .animation(.default, value: store.focusedField)
    }
}

#Preview {
    SignInWithEmailAndPasswordView(store: StoreOf<SignInWithEmailAndPasswordReducer>.init(
        initialState: SignInWithEmailAndPasswordReducer.State.init(),
        reducer: { SignInWithEmailAndPasswordReducer() }
    ))
}
