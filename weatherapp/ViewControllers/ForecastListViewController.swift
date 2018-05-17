//
// ForecastListViewController.swift
//  weatherapp
//
//  Created by Loic B on 02/05/2018.
//  Copyright © 2018 Loic B. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa

class ForecastListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: ForecastListViewModel = {
        return ForecastListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initVM()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchData()
    }

    func initView() {
        self.navigationItem.title = "Popular"
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initVM(){
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading ?? false {
                    self?.activityIndicator.startAnimating()
                    self?.tableView.alpha = 0.0
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.alpha = 1.0
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.cellViewModels
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "forecastCell")) {
                (_, model, cell) in
                (cell as? ForecastListTableViewCell)?.configure(with: model)
            }
            .disposed(by: disposeBag)
    }
    
}



