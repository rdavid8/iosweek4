//
//  ViewController.swift
//  GoGithub
//
//  Created by Ryan David on 2/22/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func authorizeButtonSelected(sender: UIButton)
    {
    GithubOAuth.shared.oauthRequestWithScope("email,user,repo")
    }
    @IBAction func printTokenButtonSelected(sender: UIButton)
    {
        do {
            let token = try GithubOAuth.shared.accessToken()
            print(token)
        } catch _ {}
    }
           
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}

