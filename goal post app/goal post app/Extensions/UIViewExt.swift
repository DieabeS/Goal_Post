//
//  UIViewExt.swift
//  goal post app
//
//  Created by medicusMac on 8/19/22.
//

import UIKit

extension UIView {
    
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIView.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIView.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIView.keyboardAnimationCurveUserInfoKey] as! UInt
        let startingFrame = (notification.userInfo![UIView.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endingFrame = (notification.userInfo![UIView.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endingFrame.origin.y - startingFrame.origin.y
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0.0,
            options: KeyframeAnimationOptions(rawValue: curve),
            animations: {self.frame.origin.y += deltaY},
            completion: nil)
    }
}
