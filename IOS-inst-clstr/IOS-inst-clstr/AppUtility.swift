//
//  AppUtility.swift
//  IOS-inst-clstr
//
//  Created by Richard Wei on 10/16/20.
//

import Foundation
import UIKit

struct AppUtility {

    static let originalWidth = UIScreen.main.bounds.width;
    static let originalHeight = UIScreen.main.bounds.height;
    static var topSafeAreaInsetHeight = UIApplication.shared.windows[0].safeAreaInsets.top;
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation;
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation);
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation();
    }

}
