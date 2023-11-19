//
//  HomeViewController.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 11/14/23.
//

import UIKit

final class HomeViewController: UIViewController {
    private let searchBar = CustomTabItemView(frame: .zero, labelText: "SEARCH")
    private let favoriteBar = CustomTabItemView(frame: .zero, labelText: "FAVORITE")
    
    private let homeViewModel = HomeViewModel()
    
    private var currentChildViewController: UIViewController?
    private var searchViewController: SearchViewController?
    private var favoriteViewController: FavoriteViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsAndLayout()
        bind()
    }
    
    private func bind() {
        homeViewModel.currentPage.observe(on: self) { category in
            // 현재 유저가 보고 있는 Page
            switch category {
            case .search:
                self.searchBar.active()
                self.favoriteBar.inactive()
                self.showSearchView()
                
            case .favorite:
                self.searchBar.inactive()
                self.favoriteBar.active()
                self.showFavoriteView()
            }
        }
    }
        
}

// Event
extension HomeViewController {
    @objc func searchBarTapped(_ sender: UITapGestureRecognizer) {
        homeViewModel.currentPage.value = .search
    }
    
    @objc func favoriteBarTapped(_ sender: UITapGestureRecognizer) {
        homeViewModel.currentPage.value = .favorite
    }
}

// UI
extension HomeViewController {
    private func setupViewsAndLayout() {
        view.backgroundColor = .white
        setupTabbar()
        searchBar.active()
    }
    
    private func setupTabbar() {
        let stackView = UIStackView(arrangedSubviews: [searchBar, favoriteBar])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        searchBar.isUserInteractionEnabled = true
        searchBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchBarTapped(_:))))
        
        favoriteBar.isUserInteractionEnabled = true
        favoriteBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteBarTapped(_:))))
    }
    
    private func showChildViewController(_ viewController: UIViewController) {
        if let currentVC = currentChildViewController {
            currentVC.removeFromParent()
            currentVC.view.removeFromSuperview()
        }
        
        addChild(viewController)
        view.addSubview(viewController.view)
        
        currentChildViewController = viewController
        
        viewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(favoriteBar.snp.top).offset(-10)
        }
    }
    
    private func showSearchView() {
        if let searchViewController = searchViewController {
            showChildViewController(searchViewController)
        } else {
            searchViewController = SearchViewController()
            
            if let searchViewController = searchViewController {
                searchViewController.searchViewModel = CharacterSearchViewModel()
                showChildViewController(searchViewController)
            }
        }
    }
    
    private func showFavoriteView() {
        if let favoriteViewController = favoriteViewController {
            showChildViewController(favoriteViewController)
        } else {
            favoriteViewController = FavoriteViewController()
            
            if let favoriteViewController = favoriteViewController {
                favoriteViewController.favoriteViewModel = FavoriteCharacterViewModel()
                showChildViewController(favoriteViewController)
            }
        }
    }
    
}
