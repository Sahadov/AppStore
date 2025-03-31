//
//  SearchResultCell.swift
//  AppStore
//
//  Created by Dmitry Volkov on 26/03/2025.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
   
    
    let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Product & Photos"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let overallStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let infoTopStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let screenShotsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var screenShot1ImageView = self.createScreenShotImageView()
    lazy var screenShot2ImageView = self.createScreenShotImageView()
    lazy var screenShot3ImageView = self.createScreenShotImageView()
    
    func createScreenShotImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(overallStackView)
        overallStackView.addArrangedSubview(infoTopStackView)
        infoTopStackView.addArrangedSubview(appIconImageView)
        infoTopStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(categoryLabel)
        verticalStackView.addArrangedSubview(ratingLabel)
        infoTopStackView.addArrangedSubview(button)
        screenShotsStackView.addArrangedSubview(screenShot1ImageView)
        screenShotsStackView.addArrangedSubview(screenShot2ImageView)
        screenShotsStackView.addArrangedSubview(screenShot3ImageView)
        overallStackView.addArrangedSubview(screenShotsStackView)
        
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            overallStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            overallStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            overallStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overallStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            appIconImageView.widthAnchor.constraint(equalToConstant: 64),
            appIconImageView.heightAnchor.constraint(equalToConstant: 64),
            button.widthAnchor.constraint(equalToConstant: 80),
            button.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    func configure(with app: Result) {
        self.titleLabel.text = app.trackName
        self.categoryLabel.text = app.primaryGenreName
        self.ratingLabel.text = String(format: "%.2f", app.averageUserRating ?? "Not rated yet")
        self.appIconImageView.sd_setImage(with: URL(string: app.artworkUrl100))
        
        if app.screenshotUrls.count > 0 {
            self.screenShot1ImageView.sd_setImage(with: URL(string: app.screenshotUrls[0]), placeholderImage: UIImage(named: "placeholder"))
        }
        
        if app.screenshotUrls.count > 1 {
            self.screenShot2ImageView.sd_setImage(with: URL(string: app.screenshotUrls[1]), placeholderImage: UIImage(named: "placeholder"))
        }
        
        if app.screenshotUrls.count > 2 {
            self.screenShot3ImageView.sd_setImage(with: URL(string: app.screenshotUrls[2]), placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
