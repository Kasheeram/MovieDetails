//
//  MovieListUTableViewController.swift
//  CodeatArtAssignment
//
//  Created by Apogee on 8/26/17.
//  Copyright © 2017 Apogee. All rights reserved.
//

import UIKit
import Alamofire

class MovieListUTableViewController: UITableViewController {
    var baseUrl = "https://api.themoviedb.org/3/movie/upcoming"
    var movieData = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        callAlamo(url:baseUrl)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieTableViewCell
        //cell.textLabel?.text = "kashee"
        cell.movieNameLabel.text = movieData[indexPath.row]["title"] as! String
       // cell.textLabel?.text = movieData[indexPath.row]["title"] as! String
        cell.releaseDateLabel.text = movieData[indexPath.row]["release_date"] as! String
        //cell.releaseDateLabel.text = movieData[indexPath.row]["adult"] as! Bool
       // cell.releaseDateLabel.text = movieData[indexPath.row]["release_date"] as! String
        
        URLSession.shared.dataTask(with: NSURL(string: (movieData[indexPath.row]["poster_path"] as? String!)!)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print("error123=\(error)")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                
//                var imagframe = UIImageView(frame: CGRect(x:0, y:0,width: UIScreen.main.bounds.width, height: 150))
//                
//                imagframe.image = UIImage(data: data!)
//                
//                cell.addSubview(imagframe)
                //cell.imageVw = UIImageView(image: UIImage(data: data!))
                //cell.sendSubview(toBack:  )
                //cell.imageVw.image = image
                cell.movieImageView.image = image
            })
            
        }).resume()

        

        

        return cell
    }
    
    
    func callAlamo(url:String)
    {
        
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
                    self.tableView.reloadData()
                }
            }catch{
                
                
            }
            
            print(self.movieData)
            
        }
    }

 

   
}
