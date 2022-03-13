import UIKit

class ButtonStyleView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var onTouch: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(image: UIImage, title: String, action: (() -> ())?) {
        self.init(frame: CGRect())
        
        imageView.image = image
        titleLabel.text = title
        addSubview(imageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        onTouch = action
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouch!()
    }
}
