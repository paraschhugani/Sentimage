//
//  ViewController.swift
//  Twittermenti
//
//  Created by Paras Chhugani on 10/07/2020.
//  Copyright © 2020 ParasChhugani. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    
    
    let sentimentClassifier = twitterClassifier()
    
    let swifter = Swifter(consumerKey: "DuFjrbjMlI9R44T0G2t7NtMbl", consumerSecret:"O6eDSk0q72FGkupzHlAKHLeOwN43hpejiBpIUanSGwPQ05fjlw")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        }

    @IBAction func predictPressed(_ sender: Any) {
        
        
        
        if let searchtext = textField.text{
            
            swifter.searchTweet(using: searchtext,lang: "en",count:100 , tweetMode: .extended,success: { (results, metadata) in
                       
                       var tweets = [twitterClassifierInput]()
                       
                       for i in 0..<100 {
                           
                           if let tweet = results[i]["full_text"].string {
                           
                               let tweetforclassification = twitterClassifierInput(text: tweet)
                               tweets.append(tweetforclassification)
                               
                           }

                       }
                       
                       do{
                       
                           let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                           var sentimentScore = 0.0
                           
                           for pred in predictions{
                               let sentiment = pred.label
                               
                               if sentiment == "Pos"{
                                   sentimentScore += 1.0
                               }else if sentiment == "Neg"{
                                   sentimentScore -= 1.0
                               }else if sentiment == "Neutral"{
                                sentimentScore += 0.5
                               }

                           }
                        self.score.text = "Score : \(String(sentimentScore)) / 100"
                        
                        if sentimentScore > 40 {
                            self.sentimentLabel.text = "😍"
                        } else if sentimentScore > 20 {
                            self.sentimentLabel.text = "😀"
                        } else if sentimentScore > 0 {
                            self.sentimentLabel.text = "🙂"
                        } else if sentimentScore == 0 {
                            self.sentimentLabel.text = "😐"
                        } else if sentimentScore > -10 {
                            self.sentimentLabel.text = "😕"
                        } else if sentimentScore > -20 {
                            self.sentimentLabel.text = "😡"
                        } else {
                            self.sentimentLabel.text = "🤮"
                        }

                           
                       }catch{
                           print("there was an error in predicting \(error)")
                       }
                       
                   }) { (error) in
                       print("There was an error in Twitter API ,\(error)")
                   }
            
        }

    
    
    }
    
}

