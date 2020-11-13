//
//  APIManager.swift
//  Code_structure_with_login
//
//  Created by vishal lakum on 13/11/20.
//  Copyright © 2020 vishal lakum. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

struct AlamofireRequestModal {
    var method: Alamofire.HTTPMethod
    var path: String
    var parameters: [String: Any]?
    var encoding: ParameterEncoding
    var headers: [String: String]?

    init() {
        method = .get
        path = ""
        parameters = nil
        encoding = JSONEncoding() as ParameterEncoding
        headers = ["Content-Type": "application/json"]
    }
}

class APIManager
{
    class var shared : APIManager
    {
        struct Static
        {
            static let instance : APIManager = APIManager()
        }
        return Static.instance
    }
 

    func callWebServiceAlamofire(_ alamoReq: AlamofireRequestModal, success: @escaping APIResponseBlock, failure: @escaping APIFailureResponseBlock) {
        
        if alamoReq.path != APi.get_token.url.absoluteString {
            getTopMostViewController()?.view.showHud()
        }
        
        // Create alamofire request
        // "alamoReq" is overridden in services, which will create a request here
        
        let req = Alamofire.request(alamoReq.path, method: alamoReq.method, parameters: alamoReq.parameters, encoding: alamoReq.encoding, headers: alamoReq.headers)

        //printing the request log for debugging purpose
        print("\nType :- \(alamoReq.method.rawValue)\nCall URL:- \(alamoReq.path)\nParam :- \(alamoReq.parameters)\nHeaders :-\(alamoReq.headers)")

        // Call response handler method of alamofire
        req.validate(statusCode: 200..<600).responseJSON(completionHandler: { response in
            let statusCode = response.response?.statusCode

            switch response.result {
            case .success(let data):
                let finalJson = JSON(data)
                print("Result :- \(finalJson))")

                //handle common case status code add new or remove as per requirments
                if statusCode == 200 { //success response code
                    if alamoReq.path != APi.get_token.url.absoluteString {
                        getTopMostViewController()?.view.hideHud()
                    }
                    success(finalJson)
                } else if statusCode == 403 || statusCode == 401 { //token expiry handle
                    // Access token expire
                    self.requestForGetNewAccessToken(alaomReq: alamoReq, success: success, failure: failure)
                } else if !finalJson["success"].boolValue { // error msg from server
                    if alamoReq.path != APi.get_token.url.absoluteString {
                        getTopMostViewController()?.view.hideHud()
                    }
                    success(finalJson)
                } else { //  error in api response
                    getTopMostViewController()?.view.hideHud()
                    failure(response.result.error as NSError?)
                }
            case .failure(let error):  // failure case : error from alamofire
                getTopMostViewController()?.view.hideHud()
                failure(error as NSError?)
            }
        })
    }
}
extension String: ParameterEncoding
{
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

struct JSONArrayEncoding: ParameterEncoding {
    private let array: [Parameters]
    
    init(array: [Parameters]) {
        self.array = array
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpBody = data
        
        return urlRequest
    }
}

class Connectivity
{
    
    class func isConnectedToInternet(completion: @escaping(_ success: Bool) -> Void)
    {
        if NetworkReachabilityManager()!.isReachable
        {
            completion(true)
        }
        else
        {
            completion(false)
        }
    }
    
}
extension APIManager {

    func getAccessToken(success: @escaping APIResponseBlock, failure: @escaping APIFailureResponseBlock) {

        var request: AlamofireRequestModal = AlamofireRequestModal()
        request.method = .get
        request.path = APi.get_token.url.absoluteString
        request.headers = ["APIKey":"C51D04DE-52A9-4FD4-A4FC-F46C42D7E87A"]//secret key to gert auth token
        self.callWebServiceAlamofire(request, success: success, failure: failure)
    }

    func requestForGetNewAccessToken(alaomReq: AlamofireRequestModal, success: @escaping APIResponseBlock, failure: @escaping APIFailureResponseBlock) {

        self.getAccessToken(success: { (model) in
            Utility.userToken = model["token"].stringValue
            
            // override existing alaomReq (updating token in header)
            var request: AlamofireRequestModal = alaomReq
            request.headers = ["Content-Type": "application/json",
                               "Authorization": "Bearer " + Utility.userToken]

            self.callWebServiceAlamofire(request, success: success, failure: failure)

        }, failure: { (_)  in
            self.requestForGetNewAccessToken(alaomReq: alaomReq, success: success, failure: failure)
        })
    }

}
