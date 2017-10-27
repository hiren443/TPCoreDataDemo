//
//  CustomCell.swift
//  OnDotDemo
//
//  Created by Hiren Bhadreshwara on 18/09/17.
//  Copyright © 2017 Hiren Bhadreshwara. All rights reserved.
//


import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var imageVw: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCellData(dict: MovieModel) {
        titleLbl.text = dict.title
//        self.backgroundColor = UIColor.yellow
        
    }
    
}

