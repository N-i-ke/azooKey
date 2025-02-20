//
//  Tab.swift
//  azooKey
//
//  Created by ensan on 2022/12/20.
//  Copyright © 2022 ensan. All rights reserved.
//

import CustardKit
import Foundation

enum UpsideComponent: Equatable {
    case search([ConverterBehaviorSemantics.ReplacementTarget])
}

enum Tab: Equatable {
    case existential(ExistentialTab)
    case user_dependent(UserDependentTab)
    case last_tab

    enum ExistentialTab: Equatable {
        case flick_hira
        case flick_abc
        case flick_numbersymbols
        case qwerty_hira
        case qwerty_abc
        case qwerty_number
        case qwerty_symbols
        case custard(Custard)
        case special(SpecialTab)

        public static func == (lhs: ExistentialTab, rhs: ExistentialTab) -> Bool {
            switch (lhs, rhs) {
            case (.flick_hira, .flick_hira), (.flick_abc, .flick_abc), (.flick_numbersymbols, .flick_numbersymbols), (.qwerty_hira, .qwerty_hira), (.qwerty_abc, .qwerty_abc), (.qwerty_number, .qwerty_number), (.qwerty_symbols, .qwerty_symbols): return true
            case (.custard(let l), .custard(let r)):
                return l.identifier == r.identifier
                    && l.input_style == r.input_style
                    && l.language == r.language
                    && l.metadata == r.metadata
                    && l.interface == r.interface
            default: return false
            }
        }

        var inputStyle: InputStyle {
            switch self {
            case .qwerty_hira:
                return .roman2kana
            case let .custard(custard):
                switch custard.input_style {
                case .direct:
                    return .direct
                case .roman2kana:
                    return .roman2kana
                }
            default:
                return .direct
            }
        }

        var layout: KeyboardLayout {
            switch self {
            case .flick_hira, .flick_abc, .flick_numbersymbols:
                return .flick
            case .qwerty_hira, .qwerty_abc, .qwerty_number, .qwerty_symbols:
                return .qwerty
            case let .custard(custard):
                switch custard.interface.keyStyle {
                case .tenkeyStyle:
                    return .flick
                case .pcStyle:
                    return .qwerty
                }
            case .special:
                // FIXME: 仮置き
                return .flick
            }
        }

        var language: KeyboardLanguage? {
            switch self {
            case .flick_abc, .qwerty_abc:
                return .en_US
            case .flick_hira, .qwerty_hira:
                return .ja_JP
            case let .custard(custard):
                switch custard.language {
                case .ja_JP:
                    return .ja_JP
                case .en_US:
                    return .en_US
                case .el_GR:
                    return .el_GR
                case .undefined:
                    return nil
                case .none:
                    return KeyboardLanguage.none
                }
            case .flick_numbersymbols, .qwerty_number, .qwerty_symbols:
                return nil
            case .special:
                return KeyboardLanguage.none
            }
        }

        var replacementTarget: [ConverterBehaviorSemantics.ReplacementTarget] {
            switch self {
            case .special(.emoji):
                return [.emoji]
            default: return []
            }
        }
    }

    enum SpecialTab: Equatable {
        case clipboard_history_tab
        case emoji
    }

    enum UserDependentTab: Equatable {
        case japanese
        case english

        @MainActor var actualTab: ExistentialTab {
            // ユーザの設定に合わせて遷移先のタブ(非user_dependent)を返す
            switch self {
            case .english:
                @KeyboardSetting(.englishKeyboardLayout) var layout
                switch layout {
                case .flick:
                    return .flick_abc
                case .qwerty:
                    return .qwerty_abc
                case let .custard(identifier):
                    return .custard((try? CustardManager.load().custard(identifier: identifier)) ?? .errorMessage)
                }
            case .japanese:
                @KeyboardSetting(.japaneseKeyboardLayout) var layout
                switch layout {
                case .flick:
                    return .flick_hira
                case .qwerty:
                    return .qwerty_hira
                case let .custard(identifier):
                    return .custard((try? CustardManager.load().custard(identifier: identifier)) ?? .errorMessage)
                }
            }
        }
    }

    @MainActor var inputStyle: InputStyle {
        switch self {
        case let .existential(tab):
            return tab.inputStyle
        case let .user_dependent(tab):
            let actualTab = tab.actualTab
            return actualTab.inputStyle
        case .last_tab:
            fatalError()
        }
    }

    @MainActor var layout: KeyboardLayout {
        switch self {
        case let .existential(tab):
            return tab.layout
        case let .user_dependent(tab):
            let actualTab = tab.actualTab
            return actualTab.layout
        case .last_tab:
            fatalError()
        }
    }

    @MainActor var language: KeyboardLanguage? {
        switch self {
        case let .existential(tab):
            return tab.language
        case let .user_dependent(tab):
            let actualTab = tab.actualTab
            return actualTab.language
        case .last_tab:
            fatalError()
        }
    }
}
