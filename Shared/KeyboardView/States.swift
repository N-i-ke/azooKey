//
//  EnvironmentValue.swift
//  Keyboard
//
//  Created by ensan on 2021/02/06.
//  Copyright © 2021 ensan. All rights reserved.
//

import enum UIKit.UIReturnKeyType

enum KeyboardLayout: String, CaseIterable, Equatable {
    /// フリック入力式のレイアウトで表示するスタイル
    case flick = "flick"
    /// qwerty入力式のレイアウトで表示するスタイル
    case qwerty = "roman"
}

enum InputStyle: String {
    /// 入力された文字を直接入力するスタイル
    case direct = "direct"
    /// ローマ字日本語入力とするスタイル
    case roman2kana = "roman"
}

enum KeyboardLanguage: String, Codable, Equatable {
    case en_US
    case ja_JP
    case el_GR
    case none

    var symbol: String {
        switch self {
        case .en_US:
            return "A"
        case .el_GR:
            return "Ω"
        case .ja_JP:
            return "あ"
        case .none:
            return ""
        }
    }
}

enum ResizingState {
    case fullwidth // 両手モードの利用
    case onehanded // 片手モードの利用
    case resizing  // 編集モード
}

enum KeyboardOrientation {
    case vertical       // width<height
    case horizontal     // height<width
}

enum RoughEnterKeyState {
    case `return`
    case edit
    case complete
}

enum EnterKeyState {
    case complete   // 決定
    case `return`(UIReturnKeyType)   // 改行
    case edit       // 編集
}

enum BarState {
    case none   // なし
    case tab    // タブバー
    case cursor // カーソルバー
}

enum ConverterBehaviorSemantics {
    /// 標準的な日本語入力のように、変換する候補を選ぶパターン
    case conversion
    /// iOSの英語入力のように、確定は不要だが、左右の文字列の置き換え候補が出てくるパターン
    case replacement([ReplacementTarget])

    enum ReplacementTarget: UInt8 {
        case emoji
    }
}
