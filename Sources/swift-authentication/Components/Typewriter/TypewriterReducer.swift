//
//  TypewriterReducer.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 15. 2. 2026..
//

import ComposableArchitecture

@Reducer
public struct TypewriterReducer {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        public var fullText: String
        public var displayedText: String
        public var typingSpeed: Double
        
        public init(
            fullText: String = "",
            displayedText: String = "",
            typingSpeed: Double = 0.25
        ) {
            self.fullText = fullText
            self.displayedText = displayedText
            self.typingSpeed = typingSpeed
        }
    }
    
    public enum Action: BindableAction {
        case binding(_ action: BindingAction<State>)
        case setFullText(_ newValue: String)
        case start
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .setFullText(let newValue):
                state.fullText = newValue
                return .none
            case .start:
                state.displayedText = ""
                return .run { [
                    fullText = state.fullText,
                    typingSpeed = state.typingSpeed
                ] send in
                    var displayedText = ""
                    for character in fullText {
                        displayedText.append(character)
                        await send(.binding(.set(\.displayedText, displayedText)))
                        try await Task.sleep(for: .seconds(typingSpeed))
                    }
                }
            }
        }
    }
}
