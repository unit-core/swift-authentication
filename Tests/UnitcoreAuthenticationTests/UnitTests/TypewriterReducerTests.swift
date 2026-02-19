//
//  TypewriterReducerTests.swift
//  SwiftAuthentication
//
//  Created by Spectra Esports  on 19. 2. 2026..
//

import Foundation
import Testing
import ComposableArchitecture
@testable import UnitcoreAuthentication

@MainActor
struct TypewriterReducerTests {

    @Test
    func testInitialState_DefaultValues() {
        let state = TypewriterReducer.State()
        #expect(state.fullText == "")
        #expect(state.displayedText == "")
        #expect(state.typingSpeed == 0.25)
    }

    @Test
    func testInitialState_CustomValues() {
        let state = TypewriterReducer.State(
            fullText: "Hello",
            displayedText: "He",
            typingSpeed: 0.1
        )
        #expect(state.fullText == "Hello")
        #expect(state.displayedText == "He")
        #expect(state.typingSpeed == 0.1)
    }

    @Test
    func testSetFullText_UpdatesFullText() async throws {
        let store = TestStore(
            initialState: TypewriterReducer.State(),
            reducer: { TypewriterReducer() }
        )
        await store.send(.setFullText("Welcome")) {
            $0.fullText = "Welcome"
        }
    }

    @Test
    func testSetFullText_DoesNotChangeDisplayedText() async throws {
        let store = TestStore(
            initialState: TypewriterReducer.State(displayedText: "Current"),
            reducer: { TypewriterReducer() }
        )
        await store.send(.setFullText("Welcome")) {
            $0.fullText = "Welcome"
        }
    }

    @Test
    func testStart_ResetsDisplayedText() async throws {
        let store = TestStore(
            initialState: TypewriterReducer.State(fullText: "", displayedText: "Hello"),
            reducer: { TypewriterReducer() }
        )
        await store.send(.start) {
            $0.displayedText = ""
        }
    }

    @Test
    func testStart_WithEmptyString_CompletesImmediately() async throws {
        let store = TestStore(
            initialState: TypewriterReducer.State(fullText: "", typingSpeed: 0),
            reducer: { TypewriterReducer() }
        )
        await store.send(.start)
    }

    @Test
    func testStart_WithSingleCharacter_AnimatesText() async throws {
        let store = TestStore(
            initialState: TypewriterReducer.State(fullText: "A", typingSpeed: 0),
            reducer: { TypewriterReducer() }
        )
        await store.send(.start)
        await store.receive(\.binding) {
            $0.displayedText = "A"
        }
    }

    @Test
    func testStart_WithMultipleCharacters_AnimatesTextSequentially() async throws {
        let store = TestStore(
            initialState: TypewriterReducer.State(fullText: "Hi", typingSpeed: 0),
            reducer: { TypewriterReducer() }
        )
        await store.send(.start)
        await store.receive(\.binding) {
            $0.displayedText = "H"
        }
        await store.receive(\.binding) {
            $0.displayedText = "Hi"
        }
    }
}
