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
    var posts: Array<[String:String]> = [
        ["url": "prince.jpg"],
        ["url": "prince.jpg"],
        ["url": "prince.jpg"],
        ["url": "prince.jpg"],
    ]
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Pre-load")
        //loadUsers()
        
        print("Post-load")
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func tapImage(_ gestureRecognizer: UITapGestureRecognizer) {
        print("image has been tapped")
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(ceil(Double(posts.count)/3))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath)
        
        
        for i in 0...2 {
            let image = cell.contentView.subviews[0].subviews[i] as! UIImageView
            
            if posts.indices.contains(indexPath.row*3+i) {
                if let url = posts[indexPath.row*3+i]["url"] {
                    image.image = UIImage(named: url)
                    image.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
                    image.addGestureRecognizer(tapGesture)
                }
            }
        }
        
        return cell
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.frame.size.width/3)
    }
}

extension ProfileViewController: UITableViewDelegate {
    
}
