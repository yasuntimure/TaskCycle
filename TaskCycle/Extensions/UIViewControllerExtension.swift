//
//  UIViewControllerExtension.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-10.
//

import UIKit

extension UIViewController {

    var root: UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window?.rootViewController
    }

}
