//
//  MainTableViewController.swift
//  SearchGithubRepositories
//
//  Created by 何常凱 on 2021/8/15.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    var searchRepository: [NSDictionary] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
    }
    
    @objc func textFieldChange(textField: UITextField) {
        if let text = textField.text {
            searchGitHubByKey(text)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRepository.count
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        if let text = searchTextField.text {
            searchGitHubByKey(text)
        }
    }
    
    func searchGitHubByKey(_ key: String) {
        Throttler.go {
            let urlString = "https://api.github.com/search/repositories?q=\(key)"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                
                do {
                    let jsonData: NSDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                    //                    print(jsonData["items"]!)
                    //                let repositorys = try JSONDecoder().decode(Results.self, from: jsonData as! Data)
                    DispatchQueue.main.async {
                        //                    self.searchRepository.append(contentsOf: repositorys.items)
                        //                    print(jsonData)
                        if let dictionary = jsonData["items"] {
                            self.searchRepository = dictionary as! [NSDictionary]
                            self.tableView.reloadData()
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
            }.resume()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gitList", for: indexPath)
        let dictionary: NSDictionary = searchRepository[indexPath.row]
        cell.textLabel?.text = dictionary["name"] as? String
        cell.detailTextLabel?.text = dictionary["full_name"] as? String
        
        return cell
    }
    
}


