//
//  UIImage+setImageAnimately.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 15/4/25.
//

import UIKit

extension UIImageView {
    func setImageAnimately(_ newImage: UIImage?) {
        image = newImage
        guard newImage != nil else { return }
        alpha = 0
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.alpha = 1
        }
    }
}
