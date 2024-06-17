//
//  WorldClockTableViewCell.swift
//  StoryboardAppleWatchCloneApp
//
//  Created by racoon on 6/17/24.
//

import UIKit

class WorldClockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeOffsetLabel: UILabel!
    @IBOutlet weak var timezoneLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var spacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timePeriodLabel.backgroundColor = .systemBackground
        timeLabel.backgroundColor = .systemBackground
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if (self.superview as? UITableView) == nil {
            return
        }
        
        timeLabel.isHidden = editing
        timePeriodLabel.isHidden = editing
        spacingConstraint.isActive = !editing
        timeTrailingConstraint.constant = editing ? -32 : 0
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
}
