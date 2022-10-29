//
//  String+Extension.swift
//  FlickrPhotoApp
//
//  Created by mac 2019 on 10/25/22.
//

import Foundation
import CoreGraphics
import UIKit

extension String {
    var tr: String {
        let selectedLanguage = AppManager.shared.getLanguage()
        if let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: "Localizable", bundle: bundle, value: self, comment: self)
        }
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
