//
//  SignInWithEmailAndPasswordViewTests.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 15. 2. 2026..
//

#if canImport(UIKit)
import SnapshotTesting
import Testing
import ComposableArchitecture

@testable import UnitcoreAuthentication

struct SnapshotConfiguration: Sendable {
    let name: String
    let device: ViewImageConfig
    
    init(name: String, device: ViewImageConfig) {
        self.name = name
        self.device = device
    }
}

@MainActor
struct SignInWithEmailAndPasswordViewTests {
    
    @Test(arguments: [
        SnapshotConfiguration(name: "iPhone13Mini", device: .iPhone13Mini),
        SnapshotConfiguration(name: "iPhone13", device: .iPhone13),
        SnapshotConfiguration(name: "iPhone13Pro", device: .iPhone13Pro),
        SnapshotConfiguration(name: "iPhone13ProMax", device: .iPhone13ProMax)
    ])
    func testIdleState(_ argument: SnapshotConfiguration) {
        let view = SignInWithEmailAndPasswordView(
            store: StoreOf<SignInWithEmailAndPasswordReducer>.init(
                initialState: SignInWithEmailAndPasswordReducer.State.init(),
                reducer: { SignInWithEmailAndPasswordReducer() }
            )
        )
        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: argument.device)),
            named: "light.\(argument.name)",
            testName: "idle"
        )
        assertSnapshot(
            of: view
                .background(.black)
                .environment(\.colorScheme, .dark),
            as: .image(layout: .device(config: argument.device)),
            named: "dark.\(argument.name)",
            testName: "idle"
        )
    }
}
#endif
