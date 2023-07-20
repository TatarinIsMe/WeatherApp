//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ильяс Каримов on 20.07.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }


}
extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString = "http://api.weatherstack.com/current?access_key=4c1730fca2cf5342a39515bbaff7d6cd&query=\(searchBar.text!.replacingOccurrences(of:" ", with: "%20"))"
        let url = URL(string: urlString)
        
        
        var locationName:String?
        var temperature: Double?
        var erorrHasOccured:Bool = false
        
        let task = URLSession.shared.dataTask(with: url!){[weak self]
            (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let _ = json["error"]{
                    erorrHasOccured = true
                }
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                if let current = json["current"]{
                    temperature = current["temperature"] as? Double
                }
                DispatchQueue.main.async {
                    
                    if erorrHasOccured {
                        self?.tempLabel.isHidden = true
                        self?.cityLabel.text = "Erorr has Occured"
                    } else {
                        self?.cityLabel.text = locationName
                        self?.tempLabel.text = "\(temperature!)"
                        self?.tempLabel.isHidden = false
                    }
                }
                
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        
        task.resume()
    }
}


