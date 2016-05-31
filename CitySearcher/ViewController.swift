//
//  ViewController.swift
//  CitySearcher
//
//  Created by Ethan Thomas on 5/31/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!


    //properties
    var shownCities = [String]()
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        searchBar
            .rx_text //observable property thanks to RxCocoa
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged() // If they didn't occur check if the new value is the same as the old
            .subscribeNext { (query) in // Here we will be notified of every new value
                print("Query not sorted: \(query)")
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
                print("Query sorted: \(self.shownCities)")
                self.tableView.reloadData()
        }

        .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cityPrototypeCell", forIndexPath: indexPath)

        cell.textLabel?.text = shownCities[indexPath.row]
        
        return cell
    }


}

