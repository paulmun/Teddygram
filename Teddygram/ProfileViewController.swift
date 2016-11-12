///
//  ViewController.swift
//  Teddygram
//
//  Created by Team No Shoes on 11/10/16.
//  Copyright © 2016 Team No Shoes. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    let domain = "https://treylitefm.com/teddygram"
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Pre-load")
        loadUsers()
        print("Post-load")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadUsers() {
        let req = URLRequest(url: URL(string: domain+"/users")!)
        
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with:data, options: []) as! Array<AnyObject>
            print(json)
            guard let item = json[0] as? [String: AnyObject],
                let profile_pic = item["profile_pic"] as? String else {
                    return
            }
            self.downloadImage(url: URL(string:profile_pic)!)
        }
        
        task.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.profilePic.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}

