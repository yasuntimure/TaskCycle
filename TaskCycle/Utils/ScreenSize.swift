//
//  ScreenSize.swift
//  TimeZone
//
//  Created by Eyüp on 11.05.2023.
//

import Foundation
import UIKit

public struct ScreenSize {

    public static var bounds: CGRect {
        UIScreen.main.bounds
    }

    public static var nativeBounds: CGRect {
        UIScreen.main.nativeBounds
    }

    public static var width: CGFloat {
        UIScreen.main.bounds.size.width
    }

    public static var height: CGFloat {
        UIScreen.main.bounds.size.height
    }

    public static var maxLength: CGFloat {
        max(ScreenSize.width, ScreenSize.height)
    }

    public static var minLength: CGFloat {
        min(ScreenSize.width, ScreenSize.height)
    }

    public static var defaultHeight: CGFloat {
        50
    }
}

public struct Constants {
    public static var buttonMaxWidth: CGFloat = 380
}
