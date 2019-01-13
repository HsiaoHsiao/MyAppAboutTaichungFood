//
//  CategoryTableCellTableViewCell.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/17.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit

class CategoryTableCellTableViewCell: UITableViewCell {
    
    let starButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "tink"), for: .normal)
        button.tintColor = .red
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return button
    }()
    
    lazy var showBool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryView = starButton
        accessoryView?.tintColor = .gray
        
        self.textLabel?.font = UIFont(name: "Mushin", size: 20)
        self.selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
