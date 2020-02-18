import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet weak var topLabelBar: UIView!
    @IBOutlet weak var bottomLabelBar: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topScoreLabel: UILabel!
    @IBOutlet weak var bottomScoreLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var secondaryViewWidthConstraint: NSLayoutConstraint!
    public var cellId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 10
        
        // hacky fix to avoid logging breaking constrants on the bigger devices
        // added the greater than constraint to size the secondary view on various screens
        if UIScreen.main.nativeBounds.width > 750 {
            secondaryViewWidthConstraint?.isActive = false
        }
    }
}
