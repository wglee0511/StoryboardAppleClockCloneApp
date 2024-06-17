//
//  CitySelectionViewController.swift
//  StoryboardAppleWatchCloneApp
//
//  Created by racoon on 6/17/24.
//

import UIKit

class CitySelectionViewController: UIViewController {
    
    var cities: [Section] = []
    var tempCities: [Section] = []

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
        tempCities = cities
    }
    
    @objc func onPressCancelButton() {
        dismiss(animated: true)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        searchBar.delegate = self
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.systemOrange, for: .normal)
        cancelButton.addTarget(self, action: #selector(onPressCancelButton), for: .touchUpInside)
        cancelButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [searchBar, cancelButton])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.width - 32).isActive = true
        navigationItem.titleView = stackView
        
        
        setUpCities()
        cityTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    

}

extension CitySelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            tempCities = cities
            cityTableView.reloadData()
            cityTableView.isHidden = false
            return
        }
        
        tempCities.removeAll()
        
        for city in self.cities {
            let filteredItems = city.items.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            
            
            if !filteredItems.isEmpty {
                tempCities.append(Section(sectionTitle: city.sectionTitle, items: filteredItems))
            }
        }
        
        cityTableView.reloadData()
        cityTableView.isHidden = tempCities.isEmpty
    }
}

extension CitySelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tempCities.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempCities[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CitySelectionTableViewCell.self), for: indexPath) as! CitySelectionTableViewCell
        
        let section = indexPath.section
        let row = indexPath.row
        
        cell.cityTextLabel.text = tempCities[section].items[row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tempCities[section].sectionTitle
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let indexList = Array("ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0) }
        return indexList
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return tempCities.firstIndex { $0.sectionTitle.uppercased() == title.uppercased() } ?? 0
    }
}


extension CitySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let targetTimeZone = tempCities[section].items[row].timeZone
        
        NotificationCenter.default.post(name: .ADD_CITY, object: nil, userInfo: ["timeZone": targetTimeZone])
        
        dismiss(animated: true)
    }
}
