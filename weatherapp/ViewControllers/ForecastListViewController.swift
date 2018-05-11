//
// ForecastListViewController.swift
//  weatherapp
//
//  Created by Loic B on 02/05/2018.
//  Copyright © 2018 Loic B. All rights reserved.
//

import UIKit
//import Alamofire

class ForecastListViewController: UIViewController {
    
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: ForecastListViewModel = {   //cf
        return ForecastListViewModel()
    }()
    
    /* Day - Min.Temp. - Max. Temp */
    let weatherData = [
    ("Monday", "3", "12"),
    ("Tuesday", "4", "12"),
    ("Wednesday", "5", "12"),
    ("Thursday", "6", "12"),
    ("Friday", "6", "12"),
    ("Saturday", "7", "12"),
    ("Sunday", "1", "12") ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    initVM()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVM(){
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.tableView.alpha = 0.0
                }else {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.alpha = 1.0
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as? PhotoListTableViewCell else { fatalError("Cell not exists in storyboard")}
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        
        //let(day, minTmp, maxTmp) = weatherData[indexPath.row]
        cell.titleLabel.text = cellVM.day
        cell.detailLabel.text = cellVM.temp_min+" "+cellVM.temp_max
        return cell
    }
}

extension ForecastListViewController : 

class PhotoListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}

