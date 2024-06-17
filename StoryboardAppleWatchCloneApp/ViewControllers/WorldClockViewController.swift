//
//  WorldClockViewController.swift
//  StoryboardAppleWatchCloneApp
//
//  Created by racoon on 6/17/24.
//

import UIKit

class WorldClockViewController: UIViewController {

    var timer: Timer?
    @IBOutlet weak var worldClockTableView: UITableView!
    
    var timeZoneList = [
        TimeZone(identifier: "Asia/Seoul")!,
        TimeZone(identifier: "Europe/Paris")!,
        TimeZone(identifier: "Asia/Tehran")!,
    ]
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        worldClockTableView.setEditing(editing, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(forName: .ADD_CITY, object: nil, queue: .main) { [weak self] notification in
            guard let self, let timeZone = notification.userInfo?["timeZone"] as? TimeZone else {
                return
            }
            let isContain = timeZoneList.contains { $0.identifier == timeZone.identifier }
            
            if !isContain {
                timeZoneList
                    .append(timeZone)
                
                
                worldClockTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard Date().isMinuteChanged, let self else { return }
            
            for cell in self.worldClockTableView.visibleCells {
                guard let clockCell = cell as? WorldClockTableViewCell else { continue }
                guard let indexPath = self.worldClockTableView.indexPath(for: cell) else { continue }
                
                let targetTimeZone = timeZoneList[indexPath.row]
                
                clockCell.timeLabel.text = targetTimeZone.currentTime
                clockCell.timePeriodLabel.text = targetTimeZone.timePeriod
                clockCell.timeOffsetLabel.text = targetTimeZone.timeOffset
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
}

extension WorldClockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZoneList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorldClockTableViewCell.self), for: indexPath) as! WorldClockTableViewCell
        
        cell.timeLabel.text = timeZoneList[indexPath.row].currentTime
        cell.timePeriodLabel.text = timeZoneList[indexPath.row].timePeriod
        cell.timezoneLabel.text = timeZoneList[indexPath.row].city
        cell.timeOffsetLabel.text = timeZoneList[indexPath.row].timeOffset
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            timeZoneList.remove(at: indexPath.row)
            worldClockTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let targetTimeZone = timeZoneList.remove(at: sourceIndexPath.row)
        
        timeZoneList.insert(targetTimeZone, at: destinationIndexPath.row)
    }
}

extension WorldClockViewController: UITableViewDelegate {
    
}
