//
//  PointDetailView.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import UIKit

class PointDetailView: UIView {
    
    private let workLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = .italicSystemFont(ofSize: 11.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 11.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(addressLabel)
        addSubview(workLabel)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints() {
        addressLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        addressLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100.0).isActive = true
        
        workLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5.0).isActive = true
        workLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        workLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        workLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        workLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100.0).isActive = true
    }
    
    // MARK: - public
    
    func setAddress(_ value: String?) {
        self.addressLabel.text = value
    }
    
    func setWorkHours(_ value: String?) {
        self.workLabel.text = value
    }
}
