//
//  MovieDetailsViewController.swift
//  CodeatArtAssignment
//
//  Created by Apogee on 8/28/17.
//  Copyright © 2017 Apogee. All rights reserved.
//

import UIKit
import Alamofire
import HCSStarRatingView

class MovieDetailsViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rating1: UIImageView!
    @IBOutlet weak var rating2: UIImageView!
    @IBOutlet weak var rating3: UIImageView!
    @IBOutlet weak var rating4: UIImageView!
    @IBOutlet weak var rating5: UIImageView!
    @IBOutlet weak var titalLabel: UILabel!
    @IBOutlet weak var overViewLabel: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var overV: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var pageControlView: UIView!
    @IBOutlet weak var starSet: HCSStarRatingView!
    var movieID:NSNumber?
    var imgOne:UIImageView?
    var imgTwo:UIImageView?
    var vote_agerage:NSNumber?
    let baseUrl = "https://api.themoviedb.org/3/movie/"
    let baseUrlForImages = "https://image.tmdb.org/t/p/w500"
    
    var tempDict:[String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0

        var completeUrlforMovieDetails = baseUrl+(movieID?.stringValue)!+"?api_key=b7cd3340a794e5a2f35e3abb820b497f"
        callAlamo(url:completeUrlforMovieDetails)
        
        starSet.maximumValue = 5
        starSet.minimumValue = 1
        starSet.value = (vote_agerage as! CGFloat) / 2
        starSet.allowsHalfStars = true
        starSet.accurateHalfStars = true
        starSet.tintColor = UIColor.orange
        
        
        //---------------------------------------------------------------
        // MARK: Adding the layes to views
        //---------------------------------------------------------------
        
        setLayerToView(views:titleView)
        setLayerToView(views:overV)
        setLayerToView(views:ratingView)
        setLayerToView(views:pageControlView)
        
//        if (vote_agerage?.intValue)! >= 10{
//            self.rating1.image = UIImage(named:"rating")
//            self.rating2.image = UIImage(named:"rating")
//            self.rating3.image = UIImage(named:"rating")
//            self.rating4.image = UIImage(named:"rating")
//            self.rating5.image = UIImage(named:"rating")
//        }else if (vote_agerage?.intValue)! >= 8{
//            self.rating1.image = UIImage(named:"rating")
//            self.rating2.image = UIImage(named:"rating")
//            self.rating3.image = UIImage(named:"rating")
//            self.rating4.image = UIImage(named:"rating")
//        }else if (vote_agerage?.intValue)! >= 6{
//            self.rating1.image = UIImage(named:"rating")
//            self.rating2.image = UIImage(named:"rating")
//            self.rating3.image = UIImage(named:"rating")
//        }else if (vote_agerage?.intValue)! >= 4{
//            self.rating1.image = UIImage(named:"rating")
//            self.rating2.image = UIImage(named:"rating")
//        }else {
//            self.rating1.image = UIImage(named:"rating")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------
    // MARK: Fetching the Movies details by passing movie id
    //---------------------------------------------------------------------
    
    func callAlamo(url:String)
    {
        Alamofire.request(url).responseJSON(completionHandler: { response in
            let JSONData = response.data!
            do{
                let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as! NSDictionary
                    print(readableJSON.count)
                    self.titalLabel.text = readableJSON["title"] as! String
                if let overview_data = readableJSON["overview"] as? String{
                    self.overViewLabel.text = overview_data
                }else{
                    self.overViewLabel.text = " "
                }
                
                var count = 0.0
                if let backdrop_path = readableJSON["backdrop_path"] as? String{
                    self.setImages(image:self.imgOne!,imagename:backdrop_path)
                    self.pageControl.numberOfPages = 1
                    count = 1.0
                }
                if let poster_path = readableJSON["poster_path"] as? String{
                    self.setImages(image:self.imgTwo!,imagename:poster_path)
                    self.pageControl.numberOfPages += 1
                    count += 1.0
                }
                
                
                self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * CGFloat(count), height:self.scrollView.frame.height)
                
            }catch{
                
            }
            
        })
    }

    //---------------------------------------------------------------
    // MARK: Fetching the images from server and loading in scrollview
    //---------------------------------------------------------------
    
    func setImages(image:UIImageView,imagename:String){
        URLSession.shared.dataTask(with: NSURL(string: (baseUrlForImages+imagename))! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print("error123=\(error)")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                image.image = UIImage(data: data!)
                self.scrollView.addSubview(image)
                    
            })
            
        }).resume()
//
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
    
    }
    
    func setLayerToView(views:UIView){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.frame = CGRect.init(x: 0, y: views.frame.size.height-width, width: views.frame.size.width, height: width)
        border.backgroundColor = UIColor.lightGray.cgColor
        views.layer.addSublayer(border)
    }

    


}
