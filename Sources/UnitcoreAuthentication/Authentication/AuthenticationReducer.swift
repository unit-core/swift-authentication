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
    
    @Dependency(\.dismiss) var dismiss
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        var isDismissButtonHidden: Bool
        var interactiveDismissDisabled: Bool
        public var isPresented: Bool
        
        var emailAndPassword: SignInWithEmailAndPasswordReducer.State = .init()
        var apple: SignInWithAppleReducer.State = .init()
        
        var welcomeText: TypewriterReducer.State = .init(fullText: "Welcome")
        
        public init(
            isDismissButtonHidden: Bool = false,
            interactiveDismissDisabled: Bool = false,
            isPresented: Bool = false
        ) {
            self.isDismissButtonHidden = isDismissButtonHidden
            self.interactiveDismissDisabled = interactiveDismissDisabled
            self.isPresented = isPresented
        }
    }
    
    public enum Action: BindableAction {
        case binding(_ action: BindingAction<State>)
        
        case isPresented(Bool)
        
        case emailAndPassword(SignInWithEmailAndPasswordReducer.Action)
        case apple(SignInWithAppleReducer.Action)
        case welcomeText(TypewriterReducer.Action)
    }
    
    public var body: some Reducer<State, Action> {
        
        BindingReducer()
        
        Scope(state: \.emailAndPassword, action: \.emailAndPassword, child: {
            SignInWithEmailAndPasswordReducer()
        })
        Scope(state: \.apple, action: \.apple, child: {
            SignInWithAppleReducer()
        })
        Scope(state: \.welcomeText, action: \.welcomeText, child: {
            TypewriterReducer()
        })
        Reduce { state, action in
            switch action {
            case .isPresented(let newValue):
                state.isPresented = newValue
                return .none
            default:
                return .none
            }
        }
    }
}

