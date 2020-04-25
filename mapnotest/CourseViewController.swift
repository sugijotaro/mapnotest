//
//  CourseViewController.swift
//  mapnotest
//
//  Created by JotaroSugiyama on 2020/04/24.
//  Copyright © 2020 JotaroSugiyama. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {
    
    var courseNameString = ""
    var locationNameString = ""
    var textViewString = ""

    @IBOutlet var courseNameLabel : UILabel!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var image :UIImageView!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseNameLabel.text = courseNameString
        self.navigationItem.title = courseNameString
        locationNameLabel.text = locationNameString
        textView.text = textViewString
        
        textView.isScrollEnabled = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
