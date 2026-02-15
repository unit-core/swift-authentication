//
//  SignInWithEmailAndPasswordViewTests.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 15. 2. 2026..
//

import SnapshotTesting
import Testing
import ComposableArchitecture

@testable import swift_authentication

@MainActor
struct SignInWithEmailAndPasswordViewTests {
    
    @Test
    func testIdleState() {
        let view = SignInWithEmailAndPasswordView(
            store: StoreOf<SignInWithEmailAndPasswordReducer>.init(
                initialState: SignInWithEmailAndPasswordReducer.State.init(),
                reducer: { SignInWithEmailAndPasswordReducer() }
            )
        )
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}
