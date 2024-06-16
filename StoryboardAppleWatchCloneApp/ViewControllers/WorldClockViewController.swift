//
//  WorldClockViewController.swift
//  StoryboardAppleWatchCloneApp
//
//  Created by racoon on 6/17/24.
//

import UIKit

class WorldClockViewController: UIViewController {

    @IBOutlet weak var worldClockTableView: UITableView!
    
    var timeZoneList = [
        TimeZone(identifier: "Asia/Seoul")!,
        TimeZone(identifier: "Europe/Paris")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension WorldClockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZoneList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorldClockTableViewCell.self), for: indexPath)
        
        return cell
    }
}

extension WorldClockViewController: UITableViewDelegate {
    
}
