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
    var baseUrlForImages = "https://image.tmdb.org/t/p/w500"
    var movieData = [AnyObject]()
    var ImageName:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        callAlamo(url:baseUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callAlamo(url:String)
    {
        
        let para :[String:String] = ["api_key":"b7cd3340a794e5a2f35e3abb820b497f"]
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.httpBody).responseJSON { response in
            
            let JSONData = response.data!
            
            do{
                let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as! NSDictionary
                print(readableJSON)
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
                    guard let poster_path = obj["poster_path"] as? String else{ return
                        //tempDict["poster_path"] = (obj["poster_path"] as! String)
                    }
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
        
        cell.movieNameLabel.text = movieData[indexPath.row]["title"] as! String
        cell.releaseDateLabel.text = movieData[indexPath.row]["release_date"] as! String
        ImageName = movieData[indexPath.row]["poster_path"] as? String!
        cell.tag = indexPath.row
        cell.nextButton.tag = indexPath.row
        cell.nextButton.addTarget(self,action:#selector(moveToMoviewDetailsController(sender:)), for: .touchUpInside)
        
        if movieData[indexPath.row]["adult"] as! Bool{
            cell.adultLabel.text = "A"
        }else{
            cell.adultLabel.text = "N/A"
        }
        
        URLSession.shared.dataTask(with: NSURL(string: (baseUrlForImages+ImageName!))! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print("error123=\(error)")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                if cell.tag == indexPath.row{
                    let image = UIImage(data: data!)
                    cell.movieImageView.image = image
                }
            })
            
        }).resume()

        return cell
    }
    
    func moveToMoviewDetailsController(sender:UIButton) {
        
        let buttonRow = sender.tag
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vcOBJ = storyBoard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vcOBJ.movieID = movieData[buttonRow]["id"] as! NSNumber
        vcOBJ.vote_agerage = movieData[buttonRow]["vote_average"] as! NSNumber
        navigationController?.pushViewController(vcOBJ, animated: true)
    }
 
    
 

   
}
