//
//  PhotoListTableViewCell.swift
//  weatherapp
//
//  Created by Loic B on 07/05/2018.
//  Copyright © 2018 Loic B. All rights reserved.
//

import UIKit

class ForecastListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure(with viewModel: ForecastListCellViewModel) {
        self.titleLabel.text = String(viewModel.day)
        self.detailLabel.text = "\(viewModel.temp_min) \(viewModel.temp_max)"
    }
}
