//
//  MXLoader.swift
//  SmartMX
//
//  Created by Gopi K on 04/11/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import UIKit

class CustomLoadIndicator: UIView {
    
    private weak var visualEffectView: UIVisualEffectView!
    private weak var messageLabel: UILabel!
    var isAnimating: Bool = false
    
    var message: String? {
        didSet {
            self.messageLabel.text = message
        }
    }
    
    class func loadNib() -> CustomLoadIndicator? {
        guard let nib = Bundle.main.loadNibNamed(String.init(describing: CustomLoadIndicator.self), owner: nil, options: nil)?.first as? CustomLoadIndicator else {
            return nil
        }
        return nib
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        accessibilityIdentifier = "CustomLoadIndicator"
        self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.4)
        self.alpha = 0
        self.perform(#selector(startAnimation), with: self, afterDelay: 0.2)
        self.visualEffectView = self.viewWithTag(100) as? UIVisualEffectView
        self.visualEffectView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        self.messageLabel = self.viewWithTag(200) as? UILabel
    }
    
    @objc private func startAnimation() {
        self.isAnimating = true
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.visualEffectView.alpha = 1
            self.visualEffectView.transform = .identity
            
        }
    }
    
    func stopAnimation(_ completion:(() -> Void)?) {
        self.isAnimating = false
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.visualEffectView.alpha = 0
            self.visualEffectView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (_) in
            self.removeFromSuperview()
            completion?()
        }
    }
    
}
