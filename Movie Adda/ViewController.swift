//
//  ViewController.swift
//  Movie Adda
//
//  Created by Pritesh Nandgaonkar on 30/04/16.
//  Copyright © 2016 Pritesh Nandgaonkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var movieTextField: UITextField!
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    @IBOutlet weak var submitBottomConstraint: NSLayoutConstraint!
    
    var movieList = [Movie]()
    
    var movieQueried: String = ""

    var keyBoardShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillChangeFrameNotification), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillChangeFrameNotification), name: UIKeyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer.init(target:self, action: #selector(tappedOutsideTextField))
        self.view.addGestureRecognizer(tap)
        self.movieTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MovieList") {
            let vc = segue.destinationViewController as! MovieListViewController
            vc.movieList = movieList
            vc.movieQueried = movieQueried
        }

    }
    
    func tappedOutsideTextField() {
        self.movieTextField.endEditing(true)
    }
    
    func handleKeyboardWillChangeFrameNotification(keyboardNotification: NSNotification) {
        let info = keyboardNotification.userInfo!
        let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        let size = info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
        
        if(!keyBoardShown) {
            submitBottomConstraint.constant =  size!.height
            keyBoardShown = true
        }
        else{
            submitBottomConstraint.constant =  0
            keyBoardShown = false
        }
        UIView.animateWithDuration(animationDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func submitTapped(sender: AnyObject) {
        movieTextField.endEditing(true)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        movieQueried = movieTextField.text!
        Movie.fetchMovieListForQuery(movieQueried) { (movieArray) in
            self.activityIndicator.stopAnimating()
            if let arr = movieArray {
                if(movieArray?.count > 0){
                    self.movieList = arr
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.performSegueWithIdentifier("MovieList", sender: self)
                    }
                }
            }
        }
        
    }
}

extension ViewController:UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.submitTapped(textField)
        return true
    }
}
