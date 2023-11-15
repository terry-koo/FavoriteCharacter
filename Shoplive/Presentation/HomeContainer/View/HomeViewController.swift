//
//  HomeViewController.swift
//  Shoplive
//
//  Created by Terry Koo on 11/14/23.
//

import UIKit

final class HomeViewController: UIViewController {
    private let searchBar = CustomTabItemView(frame: .zero, labelText: "SEARCH")
    private let favoriteBar = CustomTabItemView(frame: .zero, labelText: "FAVORITE")
    
    private let homeViewModel = HomeViewModel()
    private var loadingIndicator: UIActivityIndicatorView?
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
    
    private func showLoading() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = view.center
        loadingIndicator?.startAnimating()
        view.addSubview(loadingIndicator!)
    }
    
    private func hideLoading() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil
    }
    
    // 메모리에 SearchViewController가 존재 하지 않을 경우만 초기화 동작
    private func showSearchView() {
        // 메모리에 SearchViewController가 존재하는 경우
        if let searchViewController = searchViewController {
            if let currentVC = currentChildViewController {
                currentVC.removeFromParent()
                currentVC.view.removeFromSuperview()
            }
            
            addChild(searchViewController)
            view.addSubview(searchViewController.view)
            
            currentChildViewController = searchViewController
        } else {
            // 메모리에 SearchViewController가 존재하지 않는 경우
            searchViewController = SearchViewController()
            
            if let currentVC = currentChildViewController {
                currentVC.removeFromParent()
                currentVC.view.removeFromSuperview()
            }
            
            if let searchViewController = searchViewController {
                searchViewController.searchViewModel = SearchViewModel()
                
                addChild(searchViewController)
                view.addSubview(searchViewController.view)
                
                currentChildViewController = searchViewController
            }
        }
        
        searchViewController?.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(favoriteBar.snp.top).offset(-10)
        }
    }
    
    // 메모리에 FavoriteViewController가 존재 하지 않을 경우만 초기화 동작
    private func showFavoriteView() {
        // 메모리에 FavoriteViewController가 존재하는 경우
        if let favoriteViewController = favoriteViewController {
            if let currentVC = currentChildViewController {
                currentVC.removeFromParent()
                currentVC.view.removeFromSuperview()
            }
            
            addChild(favoriteViewController)
            view.addSubview(favoriteViewController.view)
            
            currentChildViewController = favoriteViewController
        } else {
            // 메모리에 FavoriteViewController가 존재하지 않는 경우
            favoriteViewController = FavoriteViewController()
            
            if let currentVC = currentChildViewController {
                currentVC.removeFromParent()
                currentVC.view.removeFromSuperview()
            }
            
            if let favoriteViewController = favoriteViewController {
                favoriteViewController.favoriteViewModel = FavoriteViewModel()
                
                addChild(favoriteViewController)
                view.addSubview(favoriteViewController.view)
                
                currentChildViewController = favoriteViewController
            }
        }
        
        favoriteViewController?.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(favoriteBar.snp.top).offset(-10)
        }
    }
    
}
