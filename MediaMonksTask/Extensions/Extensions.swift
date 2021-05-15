//
//  Extensions.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import Foundation
import UIKit
extension String {
    var urlDescription: URL? {
        return URL.init(string: self)
    }
}
extension UIViewController {
    //Loading Methods
    var isLoading: Bool {
        if self.view.subviews.filter({ $0.accessibilityIdentifier == "CustomLoadIndicator"  }).first as? CustomLoadIndicator != nil {
            return true
        }
        return false
    }
    
    func startLoading(with message: String) {
        
        if self.isLoading {
            return
        }
        guard let loaderView: CustomLoadIndicator = .loadNib() else {
            return
        }
        loaderView.message = message
        loaderView.frame = self.view.bounds
        self.view.addSubview(loaderView)
    }
    
    func stopLoading(_ completion:(() -> Void)? = nil) {
        if let loaderView = self.view.subviews.filter({ $0.accessibilityIdentifier == "CustomLoadIndicator"  }).first as? CustomLoadIndicator, isLoading {
            loaderView.stopAnimation(completion)
        }
    }
}

extension UIStackView {
    @discardableResult
    func addBackground(color: UIColor) -> UIView {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        return subView
    }
}
