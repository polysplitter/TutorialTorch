import UIKit

class CardView: UIView {
    var person: Person! {
        didSet {
            
        }
    }
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let ageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    
    func defaultInit() {
        self.backgroundColor = .blue
        
        for v in [imageView, nameLabel, ageLabel] {
            v.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(v)
        }
    }
}
