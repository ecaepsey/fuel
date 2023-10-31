//
//  ReviewsViewController.swift
//  Reviews
//
//  Created by Dastan on 21/2/23.
//

import UIKit
import SnapKit
import AppStoreConnect_Swift_SDK

class ReviewsViewController: UIViewController {
    
    private lazy var reviewsTableView: UITableView = {
        let review = UITableView()
        review.backgroundColor = UIColor(red: 0.887, green: 0.885, blue: 0.885, alpha: 1)
        
        review.dataSource = self
        review.delegate = self
        
        review.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        review.rowHeight = UITableView.automaticDimension
        review.estimatedRowHeight = 72
        review.showsVerticalScrollIndicator = false
        
        return review
    }()
    
    private lazy var gradientView: UIView = {
        let gradient = UIView()
        gradient.isHidden = true
        return gradient
    }()
    
    private lazy var addLimitReviewButton: UIButton = {
        let limit = UIButton()
        limit.layer.cornerRadius = 12
        limit.layer.backgroundColor = UIColor(red: 1, green: 0.804, blue: 0, alpha: 1).cgColor
        limit.setTitle("Показать больше", for: .normal)
        limit.setTitleColor(UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1), for: .normal)
        limit.titleLabel?.font = UIFont(name: "FiraSans-Medium", size: 14)
        limit.titleLabel?.textAlignment = .center
        limit.isHidden = true
        
        limit.addTarget(self, action: #selector(addLimitTapped), for: .touchUpInside)
        
        let button = UIButton.init(type: .system)
        
        return limit
    }()
    
    @objc private func addLimitTapped(sender: UIButton) {
        countLimit += 10
        maxLimit += 10
        networkManager.limitReview += 10
        networkManager.getAppReview()
        self.limitButtonAnimation(sender)
        
    }
    
    private func limitButtonAnimation(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    private lazy var backVCButton: UIBarButtonItem = {
        let back = UIBarButtonItem()
        back.image = UIImage.init(named: "back")
        back.target = self
        back.action = #selector(backButtonTapped)
        
        return back
    }()

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private lazy var emptyReviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарии отсутствуют"
        label.font = UIFont(name: "FiraSans-Medium", size: 14)
        label.textColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    private var networkManager = NetworkManager.shared
    private var customerName: [CustomerReview] = []
    private var appName: [App] = []
    private var appNameNavBar: String
    private var countLimit: Int = 10
    private var maxLimit: Int = 10
    
    init(appNameNavBar: String) {
        self.appNameNavBar = appNameNavBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.887, green: 0.885, blue: 0.885, alpha: 1)
        
        networkManager.networkDelegate = self
        
        setupSubviews()
        setupConstraints()
        
        networkManager.sorting = .minuscreatedDate
        networkManager.limitReview = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        gradientSetup()
    }
    
    private  func setupNavigation() {
        let font = [NSAttributedString.Key.font: UIFont(name: "FiraSans-Bold", size: 18)!]
        let color = UIColor(red: 0.137, green: 0.137, blue: 0.145, alpha: 1)
        
        self.navigationItem.setLeftBarButton(backVCButton, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = appNameNavBar
        self.navigationController?.navigationBar.titleTextAttributes = font
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.887, green: 0.885, blue: 0.885, alpha: 1)
        
        networkManager.limitReview = countLimit
        networkManager.getAppReview()
    }
    
    private func setupSubviews() {
        view.addSubview(reviewsTableView)
        view.addSubview(gradientView)
        view.addSubview(addLimitReviewButton)
        view.addSubview(emptyReviewsLabel)
    }
    
    private func setupConstraints() {
        reviewsTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
        
        gradientView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-76)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.bottom.equalTo(view.snp_bottomMargin).offset(0)
        }
        
        addLimitReviewButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.height.equalTo(36)
        }
        
        emptyReviewsLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.view)
            $0.centerX.equalTo(self.view)
        }
    }
    
    private func gradientSetup() {
        let topColor = UIColor(red: 0.887, green: 0.885, blue: 0.885, alpha: 1)
        let bottomColor = UIColor(red: 0.887, green: 0.885, blue: 0.885, alpha: 0)

        let startPointX: CGFloat = 0.5
        let startPointY: CGFloat = 0.7

        let endPointX: CGFloat = 0.5
        let endPointY: CGFloat = 0.3
        
//        let topColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        let bottomColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
//
//        let startPointX: CGFloat = 0.25
//        let startPointY: CGFloat = 0.5
//
//        let endPointX: CGFloat = 0.75
//        let endPointY: CGFloat = 0.5
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension ReviewsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return customerName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewsTableViewCell
        let articleName = customerName[indexPath.section]
        cell.initialSetup(article: articleName)
        
        cell.clipsToBounds = true
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reviewsTableView.deselectRow(at: indexPath, animated: false)
        
        let article = customerName[indexPath.section]
        let detailsVC = ReviewDetailsViewController(article: article, appNameNavBar: appNameNavBar)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == customerName.count - 1 {
            return 76
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.clear
        return footer
    }
    
}

extension ReviewsViewController: NetworkDelegate {
    func getApps(app: [AppStoreConnect_Swift_SDK.App]) {
        self.appName = app
    }
    
    func getAppReview(app: [AppStoreConnect_Swift_SDK.CustomerReview]) {
        self.customerName = app
        self.countLimit = app.count
        DispatchQueue.main.async {
            self.reviewsTableView.reloadData()
            
            if app.count == 0 {
                self.emptyReviewsLabel.isHidden = false
            } else {
                self.addLimitReviewButton.isHidden = false
                self.gradientView.isHidden = false
            }

            guard self.customerName.count == self.maxLimit else {
                self.addLimitReviewButton.setTitle("Показано максимум: \(self.customerName.count)", for: .normal)
                return
            }
        }
    }
    
    func getAppID(id: String) {
    
    }
    
    func getSort(sort: AppStoreConnect_Swift_SDK.APIEndpoint.V1.Apps.WithID.CustomerReviews.GetParameters.Sort) {
        networkManager.sorting = sort
    }
    
    func getLimitReview(limit: Int) {
        networkManager.limitReview = limit
    }
    
    func getError(error: Error) {
    }
}
