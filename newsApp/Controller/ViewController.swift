//
//  ViewController.swift
//  newsApp
//
//  Created by оля on 04.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var numItemsInPage = 5

    let queryService = QueryService()
    
    var currentRequest: URLRequest? = nil
    var createRequest = CreateRequest()

    var queryResults: [New] = []
    var loadedNews: [New] = []
    var wisibleNews: [New] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 600
        
        self.configureRefreshControl()
        
        currentRequest = createRequest.getTopsforCountry(conuntry: "us")
        if currentRequest != nil{
            updateNews()
        }
    }
    
    func updateNews(){
        guard let request = currentRequest else { return }
        queryService.getNews(request: request) { [weak self] (results, errorMessage) in
            
          if let results = results {
            self?.queryResults = results
            if var numWisibleItems = self?.numItemsInPage {
                if numWisibleItems >= results.count {
                    numWisibleItems = results.count - 1
                }
                self?.loadedNews = Array(results[...numWisibleItems])
                self?.wisibleNews = self?.loadedNews ?? []
            }
            self?.tableView.reloadData()
          }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetailSegue"{
            guard
              let indexPath = tableView.indexPathForSelectedRow,
              let newDetailViewController = segue.destination as? NewDetailViewController
              else {
                return
            }
              let new = queryResults[indexPath.row]
              newDetailViewController.url = new.url
        }
        
        else if  segue.identifier == "ShowFilters"{
            guard let applyFiltersViewController = segue.destination as? ApplyFiltersViewController
            else {
                return
            }
            applyFiltersViewController.delegate = self
        }
    }
    
    
    func configureRefreshControl() {
       tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        updateNews()
        
       DispatchQueue.main.async {
          self.tableView.refreshControl?.endRefreshing()
       }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wisibleNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewCell = tableView.dequeueReusableCell(withIdentifier: NewCell.identifier, for: indexPath) as! NewCell

        cell.configure(new: wisibleNews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        if indexPath.row == wisibleNews.count - 1 {
            let wisibleItemsAmount = wisibleNews.count + numItemsInPage
            
            if wisibleItemsAmount < queryResults.count - 1 {
                loadedNews = Array(queryResults[...wisibleItemsAmount])
                wisibleNews = loadedNews
                self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
                
                let spinner = UIActivityIndicatorView(style: .gray)
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

                    self.tableView.tableFooterView = spinner
                    self.tableView.tableFooterView?.isHidden = false
                }
            
            else{ self.tableView.tableFooterView?.isHidden = true }
            }
        }
    
    @objc func loadTable() {
         self.tableView.reloadData()
     }
    
    }

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            wisibleNews = loadedNews
        }
        else{
            wisibleNews = loadedNews.filter { (item: New) -> Bool in
                return item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
        tableView.reloadData()
    }
}



extension ViewController: ApplyFiltersDelegate{
    func applyFilter(filter: FilterItem) {
        switch filter.filterType
        {
        case "country":
            currentRequest = createRequest.getTopsforCountry(conuntry: filter.nameForQuery)
        case "sources":
            currentRequest = createRequest.getTopsforSources(sources: filter.nameForQuery)
        case "category":
            currentRequest = createRequest.getTopsforCategory(category: filter.nameForQuery)
        default:
            break
        }
        
        if currentRequest != nil{
            updateNews()
        }
    }
}
