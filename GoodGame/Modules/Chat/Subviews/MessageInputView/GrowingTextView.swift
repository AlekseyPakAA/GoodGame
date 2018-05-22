
//
//  GrowingTextView.swift
//  GrowingTextViewDemo
//
//  Created by Alexey Pak on 10/05/2018.
//  Copyright © 2018 Alexey Pak. All rights reserved.
//

import UIKit

class GrowingTextView: UIView {
    
    fileprivate var innerTextView: InnerTextView
    fileprivate var previousContentSize: CGSize = .zero
    
    var maxHeight: CGFloat = 80.0
    var text: String {
        get {
            return innerTextView.text
        }
        
        set {
            innerTextView.text = newValue
        }
    }
    
    fileprivate weak var heightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        innerTextView = InnerTextView(frame: .zero)
        super .init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        innerTextView = InnerTextView(frame: .zero)
        super.init(coder: aDecoder)

        setup()
    }
    
    fileprivate func setup() {
        addSubview(innerTextView)
        
        innerTextView.translatesAutoresizingMaskIntoConstraints = false
        
        innerTextView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        innerTextView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        topAnchor.constraint(lessThanOrEqualTo: innerTextView.topAnchor).isActive = true
        innerTextView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        
        innerTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        innerTextView.delegate = self
        innerTextView.isScrollEnabled = false
        
        innerTextView.autocorrectionType = .no
        
        heightConstraint = heightAnchor.constraint(equalToConstant: maxHeight)
    }
    
    override var isFirstResponder: Bool {
        get {
            return innerTextView.isFirstResponder
        }
    }
    
    override func resignFirstResponder() -> Bool {
        return innerTextView.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        return innerTextView.becomeFirstResponder()
    }
}

extension GrowingTextView: InnerTextViewDelegate {
    
    func textView(_ textView: UITextView, didChange contentSize: CGSize) {
        if previousContentSize.height > contentSize.height {
            if maxHeight > contentSize.height && previousContentSize.height > maxHeight  {
                heightConstraint?.isActive = false
                textView.isScrollEnabled = false
            }
        } else {
            if maxHeight < contentSize.height && previousContentSize.height < maxHeight  {
                heightConstraint?.constant = contentSize.height
                heightConstraint?.isActive = true
                textView.isScrollEnabled = true
            }
        }
    
        previousContentSize = contentSize
    }
    
}

fileprivate protocol InnerTextViewDelegate: UITextViewDelegate {
    
    func textView(_ textView: UITextView, didChange contentSize: CGSize)
    
}

fileprivate class InnerTextView: UITextView {
    
    override var contentSize: CGSize {
        didSet {
            guard let delegate = delegate as? InnerTextViewDelegate, oldValue != contentSize else { return }
            delegate.textView(self, didChange: contentSize)
        }
    }
    
}
