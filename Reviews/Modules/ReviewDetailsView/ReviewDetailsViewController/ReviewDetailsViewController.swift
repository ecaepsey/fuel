//
//  ReviewDetailsViewController.swift
//  Reviews
//
//  Created by Dastan on 21/2/23.
//

import UIKit
import SnapKit
import AppStoreConnect_Swift_SDK

class ReviewDetailsViewController: UIViewController {
    
    private lazy var reviewView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        return view
    }()
    
    private lazy var reviewTitle: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.font = UIFont(name: "FiraSans-Medium", size: 14)
        title.textColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        title.numberOfLines = 0
        
        return title
    }()
    
    private lazy var rating: UITextField = {
        let rate = UITextField()
        rate.textAlignment = .left
        rate.textColor = UIColor(red: 0.97, green: 0.81, blue: 0.27, alpha: 1.00)
        rate.isEnabled = false
        
        return rate
    }()
    
    private lazy var reviewDate: UILabel = {
        let date = UILabel()
        date.textAlignment = .right
        date.font = UIFont(name: "FiraSans-Regular", size: 14)
        date.textColor = UIColor(red: 0.563, green: 0.563, blue: 0.563, alpha: 1)
        date.numberOfLines = 0
        
        return date
    }()
    
    private lazy var reviewerNickname: UILabel = {
        let nick = UILabel()
        nick.textAlignment = .right
        nick.font = UIFont(name: "FiraSans-Regular", size: 14)
        nick.textColor = UIColor(red: 0.563, green: 0.563, blue: 0.563, alpha: 1)
        nick.numberOfLines = 0
        
        return nick
    }()
    
    private lazy var reviewBody: UILabel = {
        let body = UILabel()
        body.textAlignment = .left
        body.font = UIFont(name: "FiraSans-Regular", size: 14)
        body.numberOfLines = 0
        body.textColor = UIColor(red: 0.137, green: 0.137, blue: 0.145, alpha: 1)
        
        return body
    }()
    
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
    
    private lazy var replyToReview: UITextField = {
        let text = UITextField()
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor(red: 0.563, green: 0.563, blue: 0.563, alpha: 1).cgColor
        text.layer.cornerRadius = 10.5
        text.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        text.font = UIFont(name: "FiraSans-Regular", size: 14)
        text.placeholder = "Ответить"
        text.tintColor = UIColor(red: 1, green: 0.804, blue: 0, alpha: 1)
        
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        text.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        text.leftViewMode = .always
        text.rightViewMode = .always
        
        text.delegate = self
        
        return text
    }()
    
    private lazy var sendReplyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.backgroundColor = UIColor(red: 1, green: 0.804, blue: 0, alpha: 1).cgColor
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor(UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "FiraSans-Medium", size: 14)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        let btn = UIButton.init(type: .system)
        
        button.isHidden = true
        
        return button
    }()
    
    @objc private func sendButtonTapped(sender: UIButton) {
        self.sendButtonAnimate(sender)
    }
    
    private func sendButtonAnimate(_ buttonToAnimate: UIView) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
            buttonToAnimate.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
                buttonToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }

    var article: CustomerReview
    var appNameNavBar: String
    
    init(article: CustomerReview, appNameNavBar: String) {
        self.article = article
        self.appNameNavBar = appNameNavBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.887, green: 0.885, blue: 0.885, alpha: 1)
        
        setupNavigation()
        setupSubviews()
        setupConstraints()
        setupInitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
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
        
    }
    
    func setupSubviews() {
        view.addSubview(reviewView)
        reviewView.addSubview(reviewTitle)
        reviewView.addSubview(rating)
        reviewView.addSubview(reviewDate)
        reviewView.addSubview(reviewerNickname)
        reviewView.addSubview(reviewBody)
        view.addSubview(replyToReview)
        view.addSubview(sendReplyButton)
    }
    
    func setupConstraints() {
        reviewView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        reviewTitle.snp.makeConstraints {
            $0.top.equalTo(reviewView.safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-96)
            $0.bottom.equalTo(reviewBody.safeAreaLayoutGuide.snp.top).offset(-28)
        }
        
        rating.snp.makeConstraints {
            $0.top.equalTo(reviewTitle.safeAreaLayoutGuide.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(8)
        }
        
        reviewDate.snp.makeConstraints {
            $0.top.equalTo(reviewTitle.safeAreaLayoutGuide.snp.top).offset(0)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        reviewerNickname.snp.makeConstraints {
            $0.top.equalTo(reviewDate.safeAreaLayoutGuide.snp.bottom).offset(0)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        reviewBody.snp.makeConstraints {
//            $0.top.equalTo(reviewTitle.safeAreaLayoutGuide.snp.top).offset(28)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(reviewView.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
        
        replyToReview.snp.makeConstraints {
            $0.top.equalTo(reviewView.safeAreaLayoutGuide.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
        
        sendReplyButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
            $0.height.equalTo(36)
        }
    }
    
    func setupInitial() {
        if let title = article.attributes?.title {
            reviewTitle.text = title
        }
        if let rate = article.attributes?.rating {
            var cicle = 0
            while cicle < rate {
                rating.text! += "★"
                cicle += 1
            }
            var fullRate = 5 - rate
            
            while fullRate > 0 {
                rating.text! += "☆"
                fullRate -= 1
            }
        }
        if let body = article.attributes?.body {
            reviewBody.text = body
        }
        if let date = article.attributes?.createdDate {
            let dateString = "\(date)"
            let prefixDate = dateString.prefix(10)
            reviewDate.text = String(prefixDate)
        }
        if let nick = article.attributes?.reviewerNickname {
            reviewerNickname.text = nick
        }
    }
}


extension ReviewDetailsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        replyToReview.layer.borderColor = UIColor(red: 1, green: 0.804, blue: 0, alpha: 1).cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        replyToReview.layer.borderColor = UIColor(red: 0.563, green: 0.563, blue: 0.563, alpha: 1).cgColor
        if self.replyToReview.text == "" || self.replyToReview.text == " " {
            self.sendReplyButton.isHidden = true
        } else {
            self.sendReplyButton.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        replyToReview.resignFirstResponder()
        
        return true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
