//
//  TypewriterView.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 15. 2. 2026..
//

import SwiftUI
import ComposableArchitecture

public struct TypewriterView: View {
    
    @Bindable var store: StoreOf<TypewriterReducer>
    
    public init(store: StoreOf<TypewriterReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Text(store.displayedText)
    }
}
