//
//  GithubOAuth.swift
//  GoGithub
//
//  Created by Ryan David on 2/22/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import Foundation
import UIKit

let kAccessTokenKey = "kAccessToken"
let kOAuthBaseURLString = "https://github.com/login/oauth"
let kAccessTokenRegexPattern = "access_token=([^&]+)"
let kEmptyString = ""

typealias GithubOAuthCompletion = (success: Bool) -> ()

enum GithubOAuthError: ErrorType {
    case MissingAccessToken(String)
    case ResponseFromGithub(String)
}
enum SaveOption {
    case Keychain
    case UserDefaults
}

class GithubOAuth
{
    private var githubClientId = "a467eb65ae331bb5d82f"
    private var githubClientSecret = "160c3076116220b930f8e263df171a9507ccbd39"
    
    static let shared = GithubOAuth()
    private init() {}
    
    func oauthRequestWithScope(scope: String)
    {
        guard let requestURL = NSURL(string: "\(kOAuthBaseURLString)/authorize?client_id=\(self.githubClientId)&scope=\(scope)") else { fatalError("Error: Error creating request URL. Function: \(__FUNCTION__)")
        }
        UIApplication.sharedApplication().openURL(requestURL)
    }
    
    func tokenRequestWithCallback(url: NSURL, options: SaveOption, completion: GithubOAuthCompletion) {
        guard let codeString = url.query else { return }
        guard let requestURL = NSURL(string: "\(kOAuthBaseURLString)/access_token?client_id=\(self.githubClientId)&client_secret=\(self.githubClientSecret)&\(codeString)") else { return }
        
        let request = self.requestWith(requestURL, method: "POST")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let error = error { print("ERROR issue with URL \(error)"); return }
            if let data = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String : AnyObject], token = self.accessTokenFrom(json) {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            switch options {
                            case .Keychain: break
                            case .UserDefaults: self.saveAccessTokenToUserDefault(token)
                            }
                        })
                    }
                } catch _ { completion(success: false) }
            } else { completion(success: false) }
            }.resume()
    }
    
    func accessToken() throws -> String {
        var accessToken: String?
        if let token = self.accessTokenFromKeychain() { accessToken = token }
        if let token = self.accessTokenFromUserDefaults() { accessToken = token }
        
        guard let token = accessToken else {
            throw GithubOAuthError.MissingAccessToken("You don't have an access token saved")
        }
        
        return token
    }
    
    // Helper Functions
    
    private func requestWith(url: NSURL, method: String) -> NSMutableURLRequest
    {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    private func accessTokenFrom(json: [String : AnyObject]) -> String?
    {
        guard let token = json["access_token"] as? String else { return nil }
        return token
    }
    
    private func accessTokenFromKeychain() -> String?
    {
        var keychainQuery = self.getKeychainQuery(kAccessTokenKey)
        keychainQuery[(kSecReturnData as String)] = kCFBooleanTrue
        keychainQuery[(kSecMatchLimit as String)] = kSecMatchLimitOne
        var dataRef: AnyObject?
        
        if SecItemCopyMatching(keychainQuery, &dataRef) == noErr {
            if let data = dataRef as? NSData {
                if let token = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? String {
                    return token
                }
            }
        }
        return kEmptyString
    }
    
    private func getKeychainQuery(query: String) -> [String : AnyObject]
    {
        return [(kSecClass as String) : kSecClassGenericPassword,
            (kSecAttrService as String) : query,
            (kSecAttrAccount as String) : query,
            (kSecAttrAccessible as String) : kSecAttrAccessibleAfterFirstUnlock]
        
    }
    
    private func saveAccessTokenToKeychain(token: String) -> Bool
    {
        var keychainQuery = self.getKeychainQuery(kAccessTokenKey)
        keychainQuery[(kSecValueData as String)] = NSKeyedArchiver.archivedDataWithRootObject(token)
        
        SecItemDelete(keychainQuery)
        SecItemAdd(keychainQuery, nil)
        
        return true
    }

    private func saveAccessTokenToUserDefault(token: String) -> Bool
    {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: kAccessTokenKey)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func accessTokenFromUserDefaults() -> String?
    {
        return NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey)
    }
}