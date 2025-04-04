//
//  LabelHeader.swift
//  AppStore
//
//  Created by Dmitry Volkov on 04/04/2025.
//

import UIKit

final class LabelHeaderView: UICollectionReusableView {
    static let identifier = "LabelHeaderView"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.text = ""
        label.font = .boldSystemFont(ofSize: 22)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
