//
//	UserModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class UserModel : NSObject, NSCoding{

	var data : UserData!
	var success : Bool!
	var token : String!

    override init() {
        success = false
        token = ""
    }
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let dataJson = json["data"]
		if !dataJson.isEmpty{
			data = UserData(fromJson: dataJson)
		}
		success = json["success"].boolValue
		token = json["token"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if data != nil{
			dictionary["data"] = data.toDictionary()
		}
		if success != nil{
			dictionary["success"] = success
		}
		if token != nil{
			dictionary["token"] = token
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObject(forKey: "data") as? UserData
         success = aDecoder.decodeObject(forKey: "success") as? Bool
         token = aDecoder.decodeObject(forKey: "token") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}
		if token != nil{
			aCoder.encode(token, forKey: "token")
		}

	}

    //MARK ~ api call
    func getOrderDetails(ById: Int,success_block: @escaping APIResponseBlock,failur_block: @escaping APIFailureResponseBlock) {
        var request: AlamofireRequestModal = AlamofireRequestModal()
        request.method = .get
        request.path = APi.register.url.absoluteString
        request.headers = ["Content-Type": "application/json",
                           "Authorization": "Bearer " + Utility.userToken]
        APIManager.shared.callWebServiceAlamofire(request, success: success_block, failure: failur_block)
    }

}

class UserData : NSObject, NSCoding{

	var id : Int!
	var name : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["id"].intValue
		name = json["name"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}

	}

}
