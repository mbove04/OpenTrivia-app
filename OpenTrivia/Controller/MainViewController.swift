//
//  MainViewController.swift
//  OpenTrivia
//
//  Created by Sailor on 13/08/2019.
//  Copyright © 2019 sailor.OpenTrivia. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainViewController: UIViewController {
    
    var trivia: Trivia?
    var filteredQuestions: [Question]?
    var currentQuestion: Question?
    var titleQuestion: String?
    var correctAnswer: String?
    var incorrectAnswer: [String]?
    var answer = [String]()
    var trueAnswer: String?
    var delegate: LogInViewController?
    
    var nickname1Str:String = ""
    var nickname2Str:String = ""
    var score1:Int = 0
    var score2:Int = 0
    var row = 0
    var rowAux = 0
    var message:String = ""
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var labelNickname1: UILabel!
    @IBOutlet weak var labelNickname2: UILabel!
    @IBOutlet weak var labelScore1: UILabel!
    @IBOutlet weak var labelScore2: UILabel!
    @IBOutlet weak var labelPlayer: UILabel!
    @IBOutlet weak var labelQuestion: UILabel!
    
    @IBOutlet weak var labelNroQuestion: UILabel!
    
    @IBOutlet weak var tableViewAnswer: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAnswer.delegate = self
        tableViewAnswer.dataSource = self
        
        labelNickname1.text = nickname1Str
        labelNickname2.text = nickname2Str
        
        loadData()
        loadResults()
    }
    
    //carga de preguntas y llamada a la API.
    func loadData(){
        let url = NSURL(string: "https://opentdb.com/api.php?amount=20")
        
        let request = NSURLRequest(url: url! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                let json = try? JSON(data: data)
                self.trivia = Trivia(jsonString: json?.description ?? "")
                self.tableViewAnswer.reloadData()
                self.loadQuestions()
            }
        })
        task.resume()
        
    }
    
    func loadQuestions(){
        guard let trivia = trivia else {return }
        filteredQuestions = trivia.questions
        loadResults()
        nextRow()
    }
    
    
    func nextRow(){
        if row < 20{
            currentQuestion = filteredQuestions?[row]
            titleQuestion = currentQuestion?.question
            correctAnswer = currentQuestion?.correctAnswer
            incorrectAnswer = currentQuestion?.incorrectAnswers
            trueAnswer = correctAnswer
            answer.removeAll()
            answer.append(correctAnswer ?? "")
            answer += incorrectAnswer ?? [""]
            answer.shuffle()
            tableViewAnswer.reloadData()
         
            row = row + 1
            // siguiente jugador
            if row == 11 {
                labelPlayer.text = nickname2Str
                rowAux = 0
            }
           
            labelNroQuestion.text = "Question \(rowAux+1)/10"
            rowAux = rowAux + 1
            
        }else{
            answer.removeAll()
            tableViewAnswer.reloadData()
            labelQuestion.text = ""
            labelPlayer.text = ""
            labelNroQuestion.text = ""
           
            if score1 > score2{
                message = "The winner is: \(nickname1Str)"
            } else if score2 > score1{
               message = "The winner is: \(nickname2Str)"
            } else{
                message = "TIED GAME"
            }
    
            finishGame(message:message)
        }
    }
    
    func finishGame(message: String){
     
        let alertResult = UIAlertController(title: "RESULTS",message: message,preferredStyle:.alert)
        
        let restarAction = UIAlertAction(title: "Restart Game", style: .default) {action in self.loadData()}
    
        alertResult.addAction(restarAction)
        present(alertResult, animated: true,completion: nil)
    }
    
    func loadResults(){
        row = 0
        rowAux = 0
        score1 = 0
        score2 = 0
        labelScore1.text = String(score1)
        labelScore2.text = String(score2)
        labelPlayer.text = nickname1Str
    }
    
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        labelQuestion.text = titleQuestion
        cell.textLabel?.text = answer[indexPath.row]
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let validateAnswer = answer[indexPath.row]
        
        if validateAnswer == trueAnswer{
            if row < 11{
                score1 += 1
                labelScore1.text = String(score1)
            } else {
                score2 += 1
                labelScore2.text = String(score2)
            }
           
            let alerController = UIAlertController(title: "The answer is...", message: "CORRECT ANSWER", preferredStyle: .alert)
           
            let okAction = UIAlertAction(title: "OK", style: .default, handler:{action in
                self.nextRow()})
            
            alerController.addAction(okAction)
           
            present(alerController, animated: true, completion:nil)
        } else {
            let alerController = UIAlertController(title: "The answer is...", message: "WRONG ANSWER", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler:{action in
                self.nextRow()})
            
            alerController.addAction(okAction)
            
            present(alerController, animated: true, completion:nil)
        }
    }
}

extension Data {
    func printJSON()
    {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8)
        {
            print(JSONString)
        }
    }
}


