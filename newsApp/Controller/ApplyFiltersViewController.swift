//
//  ApplyFiltersViewController.swift
//  newsApp
//
//  Created by оля on 05.12.2020.
//

import UIKit

protocol ApplyFiltersDelegate
{
    func applyFilter(filter: FilterItem)
}

class ApplyFiltersViewController: UIViewController {
    
    var delegate: ApplyFiltersDelegate?
    
    let queryService = QueryService()
    let createRequest = CreateRequest()
    var currentDataSource: [FilterItem] = []
    
    var mainViewController: ViewController?
    
    var selectedRowIndexPath: Int? = nil
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var countries: [FilterItem] = [
        FilterItem(fullName: "Argentina", nameForQuery: "ar"),
        FilterItem(fullName: "Ukraine", nameForQuery: "ua"),
        FilterItem(fullName: "USA", nameForQuery: "us")
    ]
    
    var sources: [FilterItem] = []
    
    var category = [
        FilterItem(fullName: "business", nameForQuery: "business"),
        FilterItem(fullName: "entertainment", nameForQuery: "entertainment"),
        FilterItem(fullName: "health", nameForQuery: "health"),
        FilterItem(fullName: "science", nameForQuery: "science"),
        FilterItem(fullName: "sport", nameForQuery: "sport"),
        FilterItem(fullName: "tehnologies", nameForQuery: "tehnologies")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.remembersLastFocusedIndexPath = true
        currentDataSource = countries
    
        if sources.isEmpty {
            if let request = createRequest.getAllSources() {
                queryService.getSources(request: request) { [weak self] (results, errorMessage) in

                  if let results = results {
                    self?.sources = results
                    self?.tableView.reloadData()
                  }
                }
            }
        }
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        if let index = selectedRowIndexPath{
            var filter: FilterItem
            switch segmentedControl.selectedSegmentIndex
            {
            case 0:
                filter = countries[index]
                filter.filterType = "country"
            case 1:
                filter = sources[index]
                filter.filterType = "sources"
            case 2:
                filter = category[index]
                filter.filterType = "category"
            default:
                filter = countries[index]
            }
            delegate?.applyFilter(filter: filter)
        }
        
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.currentDataSource = countries
        case 1:
            self.currentDataSource = sources
        case 2:
            self.currentDataSource = category
        default:
            break
        }
        
        selectedRowIndexPath = nil
        addSpinerIfNoData()
        tableView.reloadData()
    }
    
    func addSpinerIfNoData(){
        if currentDataSource.isEmpty {
            let spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width:    tableView.bounds.width, height: CGFloat(44))

                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false
            }
        
        else{ self.tableView.tableFooterView?.isHidden = true }
    }
}

extension ApplyFiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FilterCell = tableView.dequeueReusableCell(withIdentifier:FilterCell.identifier , for: indexPath) as! FilterCell

        cell.nameLabel?.text = self.currentDataSource[indexPath.row].fullName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}

extension ApplyFiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowIndexPath = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            return "Country"
        case 1:
            return "Sources"
        case 2:
            return "Category"
        default:
            return ""
        }
    }
    
    
}
