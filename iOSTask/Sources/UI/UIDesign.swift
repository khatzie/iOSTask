//
//  UIDesign.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/15/24.
//

import UIKit

class UIDesign: NSObject {
    
    var selected: Int = 0
    
    func primaryButton(_ button: UIButton) {
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.white.withAlphaComponent(0.3), for: .disabled)
            button.titleLabel?.font = .systemFont(ofSize: 18)
            button.layer.cornerRadius = 8
            button.backgroundColor = color("#6442EF")
        }

        func color(_ hexString: String) -> UIColor {
            debugPrint(hexString)
            return color(hexString, withAlpha: 1.0)
        }

        func color(_ hexString: String, withAlpha alpha: CGFloat) -> UIColor {
            
            var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

                if (cString.hasPrefix("#")) {
                    cString.remove(at: cString.startIndex)
                }

                if ((cString.count) != 6) {
                    return UIColor.gray
                }
            
            var rgbValue: UInt64 = 0
            debugPrint(hexString)
            Scanner(string: cString).scanHexInt64(&rgbValue)
            debugPrint(cString)
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            debugPrint(red, green, blue)
            return UIColor(red: red, green: green, blue: blue,
     alpha: alpha)
        }
    
    func addBorderTop(to view: UIView, color: UIColor, thickness: CGFloat = 1.0) {
        let borderTop = CALayer()
        borderTop.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: thickness)
        borderTop.backgroundColor = color.cgColor
        view.layer.addSublayer(borderTop)
    }
    
    
}

