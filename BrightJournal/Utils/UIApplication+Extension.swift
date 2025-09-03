//
//  UIApplication+Extension.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import UIKit

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}