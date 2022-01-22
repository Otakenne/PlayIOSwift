//
//  HapticsManager.swift
//  PlayIO
//
//  Created by Otakenne on 10/01/2022.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    public func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
