//
//  CharecterCardCollectionViewCell.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 11/16/23.
//

import UIKit
import SnapKit
import Kingfisher

final class CharacterCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "CharacterCardCollectionViewCell"
    var favorite: Bool = false {
            didSet{
                if favorite {
                    backgroundColor = .darkGray
                }
                else {
                    backgroundColor = .systemGray6
                }
            }
        }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsAndLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViewsAndLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favorite = false
    }
    
    func setData(_ characterData: CharacterData) {
        imageView.kf.setImage(with: characterData.imageURL)
        nameLabel.text = characterData.name
        descriptionLabel.text = characterData.description
    }
    
    private func setupViewsAndLayout() {
        addShadow()
        layer.cornerRadius = 5
        backgroundColor = .systemGray6
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(5)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(5)
            make.bottom.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    private func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 1
        layer.masksToBounds = false
        contentView.clipsToBounds = false
    }
}
