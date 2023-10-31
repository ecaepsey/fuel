//
//  AppsViewController.swift
//  Reviews
//
//  Created by Dastan on 20/2/23.
//

import UIKit
import SnapKit
import AppStoreConnect_Swift_SDK

class AppsViewController: UIViewController {
    
    private lazy var searchTextField: UISearchBar = {
        let search = UISearchBar()
        
        search.searchTextField.layer.cornerRadius = 10
        search.searchTextField.backgroundColor = .white
        search.searchTextField.layer.masksToBounds = true
        search.frame.size.height = 48
        search.placeholder = "Поиск"
        search.searchTextField.font = UIFont(name: "FiraSans-Regular", size: 14)
        search.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
        search.delegate = self
        
        return search
    }()
    
    private lazy var appsTableView: UITableView = {
        let table = UITableView()
        
        table.dataSource = self
        table.delegate = self
        
        table.register(UINib(nibName: "AppTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        table.layer.cornerRadius = 12
        
        table.showsVerticalScrollIndicator = false
        
        return table
    }()
    
    private var networkManager = NetworkManager.shared
    private var appsName: [App] = []
    var appsNameDict = [String: String]()
    var appNameArray: [String] = ["Ramzan"]
    var searchedAppArray: [String] = []
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.887, green: 0.885, blue: 0.885, alpha: 1)
        
        setupNavigation()
        setupSubviews()
        setupConstraints()
        
        networkManager.networkDelegate = self
        self.appsTableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkManager.getApps()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchTextField.resignFirstResponder()
    }
    
    func setupNavigation() {
        let font = [NSAttributedString.Key.font: UIFont(name: "FiraSans-Bold", size: 18)!]
        let color =  UIColor(red: 0.137, green: 0.137, blue: 0.145, alpha: 1)
        
        self.navigationItem.title = "Отзывы"
        self.navigationController?.navigationBar.titleTextAttributes = font
        self.navigationController?.navigationBar.tintColor = color
    }
    
    func setupSubviews() {
        view.addSubview(searchTextField)
        view.addSubview(appsTableView)
    }
    
    func setupConstraints() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        appsTableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.safeAreaLayoutGuide.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
    }
    
    func initialSetup(a: [App]) {
        a.forEach { app in
            appsNameDict.updateValue(app.id, forKey: (app.attributes?.name)!)
            appNameArray.append((app.attributes?.name)!)
        }
    }
}

extension AppsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return searchedAppArray.count
        } else {
            return appsName.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AppTableViewCell
        if isSearching == true {
            let appName = searchedAppArray[indexPath.row]
            cell.initialSetupFilter(appsName: appName)
        } else {
            let appName = appsName[indexPath.row]
            cell.initialSetup(name: appName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appsTableView.deselectRow(at: indexPath, animated: false)
        if isSearching == true {
            let a = searchedAppArray[indexPath.row]
            let newVC = ReviewsViewController(appNameNavBar: a)
            if let appID = appsNameDict[a] {
                networkManager.appsID = appID
            }
            navigationController?.pushViewController(newVC, animated: true)
        } else {
            let appName = appsName[indexPath.row]
            let reviewVC = ReviewsViewController(appNameNavBar: (appName.attributes?.name)!)
            networkManager.appsID = appName.id
            navigationController?.pushViewController(reviewVC, animated: true)
        }
    }
}

extension AppsViewController: NetworkDelegate {
    func getApps(app: [AppStoreConnect_Swift_SDK.App]) {
        self.appsName = app
        initialSetup(a: appsName)
        DispatchQueue.main.async {
            self.appsTableView.reloadData()
        }
    }
    
    func getAppReview(app: [AppStoreConnect_Swift_SDK.CustomerReview]) {
    }
    
    func getAppID(id: String) {
        networkManager.appsID = id
    }
    
    func getSort(sort: AppStoreConnect_Swift_SDK.APIEndpoint.V1.Apps.WithID.CustomerReviews.GetParameters.Sort) {
    }
    
    func getLimitReview(limit: Int) {
    }
    
    func getError(error: Error) {
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension AppsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let lower = appNameArray.map({$0.lowercased()})
//        let searched = lower.filter({$0.prefix(searchText.count) == searchText.lowercased()})
//        let capitalized = searched.map({$0.capitalized})
//        self.searchedAppArray = capitalized
//        self.searchedAppArray = appNameArray.map({$0.lowercased()}).filter({$0.prefix(searchText.count) == searchText.lowercased()})
        self.searchedAppArray = appNameArray.filter({$0.prefix(searchText.count) == searchText})
        if searchText == "" || searchText == " " {
            self.isSearching = false
        } else {
            self.isSearching = true
        }
        appsTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchTextField.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTextField.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        appsTableView.reloadData()
        self.searchTextField.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchTextField.endEditing(true)
        self.searchTextField.endEditing(true)
        self.searchTextField.setShowsCancelButton(false, animated: true)
        self.searchTextField.text = ""
        self.isSearching = false
        self.appsTableView.reloadData()
    }
}
