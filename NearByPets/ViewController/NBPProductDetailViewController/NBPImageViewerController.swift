//
//  NBPImageViewerController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 02/07/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//


class NBPImageViewerController: UIViewController ,UIScrollViewDelegate {

        @IBOutlet var scrollView : UIScrollView?
        @IBOutlet var imageView : UIImageView?
        @IBOutlet var imageUrlString : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView?.minimumZoomScale = 1.0
        self.scrollView?.maximumZoomScale = 2.0;
        self.scrollView?.contentSize = (self.imageView?.frame.size)!;
        self.scrollView?.delegate = self
        imageView!.imageFromUrl(imageUrlString!)
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }

    @IBAction func closeButtonClicked(sender : UIButton){
        
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}
