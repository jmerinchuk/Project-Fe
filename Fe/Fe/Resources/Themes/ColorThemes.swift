//
//  ColorThemes.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-09-10.
//

//MARK: Imports
import Foundation
import UIKit

/*------------------------------------------------------------------------
 //MARK: extension UIColor
 - Description: Holds this apps color themes
 -----------------------------------------------------------------------*/
public extension UIColor {
    static var FeDisabledRed: UIColor { return UIColor(red: 125/255, green: 85/255, blue: 85/255, alpha: 1) }
    static var FeDisabledGrey: UIColor { return UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1) }
    static var FeValidationRed: UIColor { return UIColor(red: 250/255, green: 50/255, blue: 50/255, alpha: 1) }
    static var FeValidationGreen: UIColor { return UIColor(red: 205/255, green: 245/255, blue: 215/255, alpha: 1) }
    static var FeButtonGreen: UIColor { return UIColor(red: 20/255, green: 95/255, blue: 15/255, alpha: 1) }
    static var FeButtonOrange: UIColor { return UIColor(red: 235/255, green: 135/255, blue: 45/255, alpha: 1) }
    static var FeButtonRed: UIColor { return UIColor(red: 125/255, green: 15/255, blue: 15/255, alpha: 1) }
}
