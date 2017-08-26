//
//  ViewController.swift
//  CodeatArtAssignment
//
//  Created by Apogee on 8/26/17.
//  Copyright © 2017 Apogee. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //var baseUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=b7cd3340a794e5a2f35e3abb820b497f"
    
    @IBOutlet weak var tableView: UITableView!
    var baseUrl = "https://api.themoviedb.org/3/movie/upcoming"
    var movieData = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        callAlamo(url:baseUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callAlamo(url:String)
    {
//        Alamofire.request(url).responseJSON(completionHandler: { response in
//            //self.parseData(JSONData:response.data!)
//            
//            let JSONData = response.data!
//            //self.userData.removeAll()
//            //print(response)
//            
//            do{
//                let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as! NSDictionary
//                print(readableJSON)
////
//                //                for i in 0..<readableJSON.count
//                //                {
////                let arr = readableJSON["data"] as! NSArray
////                print(arr)
////                for i in 0..<arr.count
////                {
////                    let obj = arr[i] as! [String:AnyObject]
////                    var tempDict:[String:Any] = [:]
////                    tempDict["_id"] = obj["_id"] as! String
////                    tempDict["hostname"] = obj["hostname"] as! String
////                    tempDict["ip"] = obj["ip"] as! String
////                    tempDict["mac"] = obj["mac"] as! String
////                    tempDict["online"] = obj["online"] as! Bool
////                    //ResultData.append(tempDict as AnyObject)
////                    self.userData.append(tempDict as AnyObject)
////                }
////                
////                print(self.userData)
////                self.tableView.reloadData()
////                
////
//            }catch{
//                
//            }
//
            // print(JSONData)
       // })
//
        
        let para :[String:String] = ["api_key":"b7cd3340a794e5a2f35e3abb820b497f"]
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.httpBody).responseJSON { response in
            
            let JSONData = response.data!
            
            do{
                let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as! NSDictionary
                    //print(readableJSON.count)
            
                let data = readableJSON["results"] as! NSArray
                print(data.count)
                
                for i in 0..<data.count{
                    let obj = data[i] as! [String:AnyObject]
                    var tempDict:[String:Any] = [:]
                    tempDict["id"] = obj["id"] as! NSNumber
                    tempDict["title"] = obj["title"] as! String
                    tempDict["vote_average"] = obj["vote_average"] as! NSNumber
                    tempDict["popularity"] = obj["popularity"] as! NSNumber
                    tempDict["adult"] = obj["adult"] as! Bool
                    tempDict["overview"] = obj["overview"] as! String
                    tempDict["poster_path"] = obj["poster_path"] as! String
                    tempDict["release_date"] = obj["release_date"] as! String
                    self.movieData.append(tempDict as AnyObject)
                }
            }catch{
                
                self.tableView.reloadData()
            }
            
            print(self.movieData)
            
        }
}
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MoviesListTableViewCell
        //cell.movieNameLabel.text = "kashee"
        cell.textLabel?.text = "kashee"
        
        return cell
    }
}

