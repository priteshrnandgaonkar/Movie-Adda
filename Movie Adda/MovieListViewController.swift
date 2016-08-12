//
//  MovieListViewController.swift
//  Movie Adda
//
//  Created by Pritesh Nandgaonkar on 30/04/16.
//  Copyright © 2016 Pritesh Nandgaonkar. All rights reserved.
//

import Foundation
import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movieList = [Movie]()
    
    var movieQueried = ""
    
    var movieToShow: Movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBarHidden = false
        let color = UIColor.init(colorLiteralRed: 59.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.tintColor = .whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationItem.title = movieQueried

    }
    
    func fetchDetailsOfMovie(inout movie: Movie) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        movie.updateWithMoreDetils { (updated) in
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                
                guard let strongSelf = self else {
                    return;
                }
                
                strongSelf.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()

                if(updated){
                    strongSelf.movieToShow = movie
                    strongSelf.performSegueWithIdentifier("MovieDetail", sender: self)
                }
                else{
                    strongSelf.showAlert(movie.title)
                    }
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "MovieDetail"){
            let vc = segue.destinationViewController as! MovieDetailViewController
            vc.movie = movieToShow
        }
    }
    func showAlert(movieName: String) {
        let alert=UIAlertController(title: "Error", message: "No More Data found for \(movieName), Try Something else", preferredStyle: UIAlertControllerStyle.Alert);
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil);
    }

}
extension MovieListViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celldentifier") as! MovieTableViewCell
        cell.populateCell(movieList[indexPath.row])
        cell.selectionStyle = .None
        return cell
    }
}
extension MovieListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.fetchDetailsOfMovie(&self.movieList[indexPath.row])
    }
    
}
