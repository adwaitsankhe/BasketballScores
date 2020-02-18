import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerStatLineLabel: UILabel!
    @IBOutlet weak var nerdTitleLabel: UILabel!
    @IBOutlet weak var nerdValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()        
    }
}
