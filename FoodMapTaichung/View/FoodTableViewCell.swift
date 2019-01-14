//
//  FoodTableViewCell.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/4.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    let rightView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .right
        view.isEditable = false
        view.textContainerInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 6)
        view.textColor = .gray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(rightView)
        rightView.trailingAnchor.constraint(equalTo: (self.textLabel?.trailingAnchor)!).isActive = true
        rightView.topAnchor.constraint(equalTo: (self.textLabel?.topAnchor)!).isActive = true
        rightView.bottomAnchor.constraint(equalTo: (self.textLabel?.bottomAnchor)!).isActive = true
        rightView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.textLabel?.font = UIFont(name: "Mushin", size: 20)
        self.selectionStyle = .none
        self.isOpaque = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
