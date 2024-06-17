//
//  CitySelectionViewController.swift
//  StoryboardAppleWatchCloneApp
//
//  Created by racoon on 6/17/24.
//

import UIKit

class CitySelectionViewController: UIViewController {
    
    var cities: [Section] = []

    @IBOutlet weak var cityTableView: UITableView!
    
    func setUpCities () {
        var tempDict: [String: [TimeZone]] = [:]
        
        let timeZones = TimeZone.knownTimeZoneIdentifiers
        
        for timeZoneString in timeZones {
            let city = timeZoneString.components(separatedBy: "/").last
            
            guard let city else {
                return
            }
            
            let key = city.chosung ?? "Unknown"
            var timeZoneList = [TimeZone(identifier: timeZoneString)!]
            
            if let targetList = tempDict[key] {
                timeZoneList.append(contentsOf: targetList)
            }
            
            tempDict[key] = timeZoneList
            
        }
        
        for (key, value) in tempDict {
            let items = value.sorted {
                guard let lhs = $0.city, let rhs = $1.city else {
                    return false
                }
                
                return lhs < rhs
            }.map {
                Item(title: $0.city ?? $0.identifier, timeZone: $0)
            }
            
            let section = Section(sectionTitle: key, items: items)
            
            cities.append(section)
        }
        
        cities.sort { $0.sectionTitle < $1.sectionTitle }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCities()
        cityTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    

}

extension CitySelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CitySelectionTableViewCell.self), for: indexPath) as! CitySelectionTableViewCell
        
        let section = indexPath.section
        let row = indexPath.row
        
        cell.cityTextLabel.text = cities[section].items[row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cities[section].sectionTitle
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let indexList = Array("ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0) }
        return indexList
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return cities.firstIndex { $0.sectionTitle.uppercased() == title.uppercased() } ?? 0
    }
}
