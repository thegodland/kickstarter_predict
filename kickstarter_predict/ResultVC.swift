//
//  ResultVC.swift
//  kickstarter_predict
//
//  Created by 刘祥 on 11/4/18.
//  Copyright © 2018 shaneliu90. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    
    var passedResult : Int = -1
    var confidence : Double = 0.00

    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var resultImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(passedResult)
        
        if passedResult == 1{
            resultImg.image = UIImage(named: "pass")
            accuracyLabel.text = "Model Confidence is "+String(confidence)
        }else if passedResult == 0{
            resultImg.image = UIImage(named: "fail")
            accuracyLabel.text = "Model Confidence is "+String(1-confidence)
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func gobackTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
