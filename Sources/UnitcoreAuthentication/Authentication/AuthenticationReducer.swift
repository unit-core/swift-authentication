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
    
    public init() {}
    
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

