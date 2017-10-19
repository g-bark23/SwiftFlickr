//
//  SecondViewController.swift
//  SwiftFlickr
//
//  Created by Garrett Barker on 10/18/17.
//  Copyright © 2017 Garrett Barker. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var myImageView: UIImageView!
    var myImageData: Data? = nil

    @IBAction func panImage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @IBAction func zoomImage(_ sender: UIPinchGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImageView?.image = UIImage(data: myImageData!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
