//
//  SemiStaticStates.swift
//  azooKey
//
//  Created by ensan on 2022/12/18.
//  Copyright © 2022 ensan. All rights reserved.
//

import Foundation
import SwiftUI
import class CoreHaptics.CHHapticEngine

/// 実行しないと値が確定しないが、実行されれば全く変更されない値。収容アプリでも共有できる形にすること。
final class SemiStaticStates {
    static let shared = SemiStaticStates()
    private init() {}

    // MARK: 端末依存の値
    private(set) lazy var needsInputModeSwitchKey = {
        UIInputViewController().needsInputModeSwitchKey
    }()
    private(set) lazy var hapticsAvailable = false

    func setNeedsInputModeSwitchKey(_ bool: Bool) {
        self.needsInputModeSwitchKey = bool
    }

    func setHapticsAvailable() {
        self.hapticsAvailable = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }

    // MARK: 「キーボードを開く」—「キーボードを閉じる」の動作の間に変更しない値
    private(set) var hasFullAccess = {
        UIInputViewController().hasFullAccess
    }()

    func setHasFullAccess(_ bool: Bool) {
        self.hasFullAccess = bool
    }

    /// - do not  consider using screenHeight
    /// - スクリーンそのもののサイズ。キーボードビューの幅は片手モードなどによって変更が生じうるため、`screenWidth`は限定的な場面でのみ使うことが望まし。
    private(set) var screenWidth: CGFloat = UIScreen.main.bounds.width
    private(set) var keyboardHeightScale: CGFloat = 1

    /// - note: キーボードが開かれたタイミングで一度呼ぶのが望ましい。
    func setKeyboardHeightScale(_ scale: CGFloat) {
        self.keyboardHeightScale = scale
    }

    /// Function to set the width of area of keyboard
    /// - Parameter width: 使用可能な領域の幅.
    func setScreenWidth(_ width: CGFloat) {
        self.screenWidth = width
    }
}
