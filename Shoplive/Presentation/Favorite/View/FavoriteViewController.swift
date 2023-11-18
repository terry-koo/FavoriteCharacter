//
//  FavoritViewController.swift
//  Shoplive
//
//  Created by Terry Koo on 11/14/23.
//

import UIKit
import SnapKit

final class FavoriteViewController: UIViewController {
    var favoriteViewModel: FavoriteCharacterViewModelProtocol?
    
    private let characterCardCollectionView: UICollectionView = {        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let padding = (width - (width / 2.2) * 2) / 3
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width / 2.2, height: height / 3)
        layout.sectionInset = UIEdgeInsets(top: 10, left: padding, bottom: 10, right: padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CharacterCardCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCardCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아하는 영웅이 비어있습니다."
        label.textColor = .gray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsAndLayout()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteViewModel?.fetchFavoriteCharacters()
    }
    
    private func bind() {
        guard let favoriteViewModel else { return }
        
        favoriteViewModel.favoriteCharacterData.observe(on: self) { [weak self] favoriteCharacters in
            guard let self else { return }
            
            characterCardCollectionView.reloadData()
            
            if favoriteCharacters.isEmpty {
                showMessageLabel()
            } else {
                removeMessageLabel()
            }
        }
        
        favoriteViewModel.isLoading.observe(on: self) { [weak self] isLoading in
            guard let self else { return }
            
            if isLoading {
                showLoading()
            } else {
                hideLoading()
                characterCardCollectionView.reloadData()
            }
        }
    }

}

// UI
extension FavoriteViewController {
    private func setupViewsAndLayout() {
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(characterCardCollectionView)
        
        characterCardCollectionView.delegate = self
        characterCardCollectionView.dataSource = self
        
        characterCardCollectionView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    
    private func showLoading() {
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
    }
    
    private func hideLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
    
    private func showMessageLabel() {
        view.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func removeMessageLabel() {
        messageLabel.removeFromSuperview()
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let favoriteViewModel else { return 0 }
        
        return favoriteViewModel.getFavoriteCharacterDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCardCollectionViewCell.identifier, for: indexPath) as! CharacterCardCollectionViewCell
        
        guard let favoriteViewModel else { return cell }
        
        cell.favorite = true
        
        if let characterData = favoriteViewModel.getFavoriteCharacter(index: indexPath.row) {
            cell.setData(characterData)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        favoriteViewModel?.deSelectFavoriteCharacter(index: indexPath.row)
    }
}
