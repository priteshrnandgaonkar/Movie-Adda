//
//  MovieDetailViewController.swift
//  Movie Adda
//
//  Created by Pritesh Nandgaonkar on 30/04/16.
//  Copyright © 2016 Pritesh Nandgaonkar. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var plot: UILabel!
    @IBOutlet weak var genreTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var movie: Movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        duration.text = movie.duration
        rating.text = movie.rating
        if let releasedString = movie.releaseDate {
            released.text = "Released in \(releasedString)"
        }
        plot.text = movie.plot
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: self.movie.posterImgURL)
            if let imageData = data {
                dispatch_async(dispatch_get_main_queue(), {
                    self.poster.image = UIImage(data: imageData)
                });
            }
        }
        navigationItem.title = movie.title
    }
    override func viewDidLayoutSubviews(){
        
        if(movie.genres!.count >= 1){
            tableViewHeight.constant = CGFloat((movie.genres!.count * 68) + 44)
        }
        else{
            tableViewHeight.constant = 200
        }
        
    }
}

extension MovieDetailViewController:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movie.genres!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GenreCell") as! GenreTableViewCell
        cell.genre.text = self.movie.genres![indexPath.row]
        return cell
    }
}