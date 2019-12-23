//
//  SplashScreen.swift
//  Training
//
//  Created by ManhLD on 12/16/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class SplashScreen: UIViewController {
    
    @IBOutlet weak var progressing: UIProgressView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    let progress = Progress(totalUnitCount: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLoading()
        setUpNavBar()
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUpLoading() {
        progressing.progress = 0.0
        progress.completedUnitCount = 8
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            guard self.progress.isFinished == false else {
                timer.invalidate()
                return
            }
            self.progress.completedUnitCount += 1
            self.progressing.setProgress(Float(self.progress.fractionCompleted), animated: true)
            self.progressLabel.text = "Loading - \(Int(self.progress.fractionCompleted * 100)) %"
            if self.progress.completedUnitCount == 10 {
                self.setRootTabbar()
            }
        }
    }
    
    func setRootTabbar() {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
                 UIApplication.shared.windows.first?.rootViewController = vc
                 UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
 
}
