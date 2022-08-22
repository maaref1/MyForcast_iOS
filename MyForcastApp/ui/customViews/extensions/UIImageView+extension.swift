//
//  UIImageView+extension.swift
//  MyForcastApp
//
//  Created by MacBook Air on 22/08/2022.
//

import Foundation
import UIKit

// This will be our image memory cache
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    /*
     This function will load image from an external URL and save on cache to be reused
     */
    func load(url: URL) {
        if let img = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = img
            return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: url as AnyObject)
                        self.image = image
                    }
                }
            }
        }
    }
}
