//
//  KeyboardInternalSetting.swift
//  azooKey
//
//  Created by ensan on 2021/03/12.
//  Copyright © 2021 ensan. All rights reserved.
//

import Foundation

protocol UserDefaultsKeys: RawRepresentable where RawValue == String {
    associatedtype Manager: UserDefaultsManager
    init(keyPath: PartialKeyPath<Manager>)
}

protocol UserDefaultsManager {
    associatedtype Keys: UserDefaultsKeys where Keys.Manager == Self
    mutating func update<T: Codable>(_ value: KeyPath<Self, T>, newValue: T)
    mutating func update<T: Codable>(_ value: KeyPath<Self, T>, process: (inout T) -> Void)
}

extension UserDefaultsManager {
    mutating func update<T: Codable>(_ value: KeyPath<Self, T>, newValue: T) {
        if let value = value as? WritableKeyPath {
            self[keyPath: value] = newValue
            update(value: value)
        }
    }

    mutating func update<T: Codable>(_ value: KeyPath<Self, T>, process: (inout T) -> Void) {
        if let value = value as? WritableKeyPath {
            process(&self[keyPath: value])
            update(value: value)
        }
    }
}

fileprivate extension UserDefaultsManager {
    mutating func update(value: WritableKeyPath<Self, some Codable>) {
        do {
            let data = try JSONEncoder().encode(self[keyPath: value])
            let key = Keys(keyPath: value)
            UserDefaults.standard.set(data, forKey: key.rawValue)
        } catch {
            debug(error)
        }
    }

    static func load<T: KeyboardInternalSettingValue>(key: Keys) -> T {
        if let value = UserDefaults.standard.data(forKey: key.rawValue) {
            do {
                let value = try JSONDecoder().decode(T.self, from: value)
                return value
            } catch {
                debug(error)
            }
        }
        return T.initialValue
    }
}

protocol KeyboardInternalSettingValue: Codable {
    static var initialValue: Self {get}
}

struct KeyboardInternalSetting: UserDefaultsManager {
    static var shared = Self()

    enum Keys: String, UserDefaultsKeys {
        typealias Manager = KeyboardInternalSetting
        case one_handed_mode_setting
        case tab_character_preference
        case emoji_tab_expand_mode_preference

        init(keyPath: PartialKeyPath<Manager>) {
            switch keyPath {
            case \Manager.oneHandedModeSetting:
                self = .one_handed_mode_setting
            case \Manager.tabCharacterPreference:
                self = .tab_character_preference
            case \Manager.emojiTabExpandModePreference:
                self = .emoji_tab_expand_mode_preference
            default:
                fatalError("Unknown Key Path: \(keyPath)")
            }
        }
    }

    private(set) var oneHandedModeSetting: OneHandedModeSetting = Self.load(key: .one_handed_mode_setting)
    private(set) var tabCharacterPreference: TabCharacterPreference = Self.load(key: .tab_character_preference)
    private(set) var emojiTabExpandModePreference: EmojiTabExpandModePreference = Self.load(key: .emoji_tab_expand_mode_preference)
}

struct ContainerInternalSetting: UserDefaultsManager {
    static var shared = Self()

    enum Keys: String, UserDefaultsKeys {
        typealias Manager = ContainerInternalSetting
        case walkthrough_state

        init(keyPath: PartialKeyPath<Manager>) {
            switch keyPath {
            case \Manager.walkthroughState:
                self = .walkthrough_state
            default:
                fatalError("Unknown Key Path: \(keyPath)")
            }
        }
    }

    private(set) var walkthroughState: WalkthroughInformation = Self.load(key: .walkthrough_state)
}
