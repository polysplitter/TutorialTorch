import UIKit

class CardView: UIView {
    var person: Person! {
        didSet {
            imageView.image = person.image
            nameLabel.text = person.name
            ageLabel.text = String(person.age)
        }
    }
    
    let likeLabel = StatusPill()
    let nopeLabel = StatusPill()
    
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
        self.backgroundColor = .white
        
        for v in [imageView, nameLabel, ageLabel] {
            v.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(v)
        }
        
        // Image View
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.8, constant: 0).isActive = true
        
        // Name Label
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 7).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        // Age Label
        NSLayoutConstraint(item: ageLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -7).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        nameLabel.textAlignment = .left
        
        ageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        ageLabel.textAlignment = .right
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        
        for v in [nopeLabel, likeLabel] {
            self.addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: v, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: v, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            v.alpha = 0
        }
        
        nopeLabel.text = "Nope"
        nopeLabel.color = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1)
        
        likeLabel.text = "Like"
        likeLabel.color = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1)
    }
}
