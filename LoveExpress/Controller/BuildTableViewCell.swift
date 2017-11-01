//
//  BuildTableViewCell.swift
//  LoveExpress
//
//  Created by chenxi on 2017/10/30.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import UIKit

class BuildTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buildImg: UIImageView!
    
    @IBOutlet weak var buildDistance: UILabel!
    
    @IBOutlet weak var buildName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
