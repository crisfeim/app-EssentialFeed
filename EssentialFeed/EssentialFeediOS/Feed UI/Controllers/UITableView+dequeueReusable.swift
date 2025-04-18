//
//  UITableView+dequeueReusable.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 15/4/25.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
