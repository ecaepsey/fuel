//
//  NetworkManager.swift
//  Reviews
//
//  Created by Dastan on 20/2/23.
//

import UIKit
import AppStoreConnect_Swift_SDK

protocol NetworkDelegate {
    func getApps(app: [AppStoreConnect_Swift_SDK.App])
    func getAppReview(app: [AppStoreConnect_Swift_SDK.CustomerReview])
    func getAppID(id: String)
    func getSort(sort: APIEndpoint.V1.Apps.WithID.CustomerReviews.GetParameters.Sort)
    func getLimitReview(limit: Int)
    func getError(error: Error)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var networkDelegate: NetworkDelegate?
    
    var appsID: String = ""
    var sorting: APIEndpoint.V1.Apps.WithID.CustomerReviews.GetParameters.Sort?
    var limitReview: Int = 1
    
    private let configuration = APIConfiguration(issuerID: "69a6de7a-7e0a-47e3-e053-5b8c7c11a4d1", privateKeyID: "5UNX6Z8SNT", privateKey: "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgb+bxskeUbGNceL92uIf4wAMh5LO+yj+CaKgKJ4W5aj+gCgYIKoZIzj0DAQehRANCAASW9V09O/aBzJUvPYpiA2rkyWLTWbtDQEKEjkCBJWm/jbSHF+dieZs9fJquvCxrQbp9HzlJEhhwpd70FHNtaJWq")
    
    private lazy var provider: APIProvider = APIProvider(configuration: configuration)
    
    func getApps() {
        let request = APIEndpoint
            .v1
            .apps
            .get(parameters: .init(
                sort: [.name ],
                fieldsApps: [ .name, .bundleID ]
            ))
        
        provider.request(request) { data in
            switch data {
            case .success(let responce):
                let result = responce.data
                self.networkDelegate?.getApps(app: result)
            case .failure(_):
                break
            }
        }
    }
    
    func getAppReview() {
        let request = APIEndpoint
            .v1
            .apps
            .id(self.appsID)
            .customerReviews
            .get(parameters: .init(
                sort: [ sorting! ],
                fieldsCustomerReviews: [ .title, .body, .reviewerNickname, .createdDate, .rating ],
                limit: limitReview
            ))
        
        provider.request(request) { data in
            switch data {
            case .success(let response):
                let result = response.data
                self.networkDelegate?.getAppReview(app: result)
            case .failure(_):
                break
            }
            
        }
    }
    
}
