import UIKit

class AdoptionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addBorderAndRoundedCorners(to: infoView, corners: [.bottomLeft, .bottomRight], borderWidth: 0.5, borderColor: .black)
        
        addBorderAndRoundedCorners(to: animalImage, corners: [.topLeft, .topRight], borderWidth: 0.5, borderColor: .black)
        
        infoView.backgroundColor = .systemBackground
        
    }
    
    func addBorderAndRoundedCorners(to view: UIView, corners: UIRectCorner, borderWidth: CGFloat, borderColor: UIColor) {
        view.layer.cornerRadius = 20.0
        view.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        view.layer.masksToBounds = true
    }
}
