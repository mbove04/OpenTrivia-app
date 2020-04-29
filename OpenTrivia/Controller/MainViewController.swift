//
//  MainViewController.swift
//  OpenTrivia
//
//  Created by Sailor on 13/08/2019.
//  Copyright © 2019 sailor.OpenTrivia. All rights reserved.
//

import UIKit
import SwiftyJSON
import ProgressHUD //for Objetive-c


class MainViewController: UIViewController {
    //MARK: - Advancer Variables
    var trivia: Trivia?
    var filteredQuestions: [Question]?
    var currentQuestion: Question?
    var titleQuestion: String?
    var correctAnswer: String?
    var incorrectAnswer: [String]?
    var answer = [String]()
    var trueAnswer: String?
    var delegate: LogInViewController?
    //MARK: - Normal Variables
    var nickname1Str:String = ""
    var nickname2Str:String = ""
    var countQuestionPlayer = 0
    var currentPlayer = 1
    var score1:Int = 0
    var score2:Int = 0
    var row = 0
    var rowAux = 0
    var rowBool: Bool = false
    var rowProgess: Int = 0
    var message:String = ""
    var individualCountQuestion: Int = 0
    
    //MARK: - Outlets
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var labelNickname1: UILabel!
    @IBOutlet weak var labelNickname2: UILabel!
    @IBOutlet weak var labelScore1: UILabel!
    @IBOutlet weak var labelScore2: UILabel!
    @IBOutlet weak var labelPlayer: UILabel!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var labelNroQuestion: UILabel!
    @IBOutlet weak var tableViewAnswer: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewAnswer.delegate = self
        tableViewAnswer.dataSource = self
      
        labelNickname1.text = nickname1Str
        labelNickname2.text = nickname2Str
        countQuestionPlayer = individualCountQuestion * 2
        progressBar.isHidden = true
        
        loadData()
        loadResults()
    }
    
    
    // MARK: - FUNC
    
    //carga de preguntas y llamada a la API.
    func loadData(){
        let url = NSURL(string: "https://opentdb.com/api.php?amount=\(countQuestionPlayer)")
        
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
        
        if row < countQuestionPlayer{
            //carga de la pregunta
            loadNewQuestion()
         
            row = row + 1
            rowProgess = row
            
            // siguiente jugador
            if row == (individualCountQuestion) + 1 {
                labelPlayer.text = nickname2Str
                currentPlayer = 2
                rowAux = 0
            }
            
            rowAux = rowAux + 1
            labelNroQuestion.text = "Question \(rowAux)/\(individualCountQuestion)"
           
            if currentPlayer == 2{
               rowProgess = rowAux
            }
            //barra de progreso
            progressBarFunc()
            
        } else {
            progressBar.isHidden = true
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
    
    func loadNewQuestion(){
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
    }
    
    
    func loadResults(){
        row = 0
        rowAux = 0
        rowProgess = 0
        score1 = 0
        score2 = 0
        labelScore1.text = String(score1)
        labelScore2.text = String(score2)
        labelPlayer.text = nickname1Str
    }
    
    func progressBarFunc(){
        progressBar.isHidden = false
        
        for constraints in self.progressBar.constraints{
            if constraints.identifier == "barWidhtConstrain" {
                constraints.constant = (self.view.frame.size.width) / CGFloat(self.individualCountQuestion) * CGFloat(self.rowProgess)
            }
        }
    }
    
    
    func finishGame(message: String){
      
         let alertResult = UIAlertController(title: "RESULTS",message: message,preferredStyle:.alert)
         
         let restarAction = UIAlertAction(title: "Restart Game", style: .default) {action in self.loadData()}
     
         alertResult.addAction(restarAction)
         
        //retraso de 1 segundo en presentar
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.present(alertResult, animated: true,completion: nil)
         }
        
     }
    
}

// MARK: - Extension TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        labelQuestion.text = titleQuestion
        cell.textLabel?.text = answer[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .systemOrange
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let validateAnswer = answer[indexPath.row]
               
        if validateAnswer == trueAnswer{
            
            if currentPlayer == 1{
                score1 += 1
                labelScore1.text = String(score1)
            } else {
                score2 += 1
                labelScore2.text = String(score2)
            }
           
            ProgressHUD.showSuccess("CORRECT ANSWER")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nextRow()
            }
            
        } else {
            
            ProgressHUD.showError("WRONG ANSWER")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nextRow()
            }
            
        }
        
     
    }
}




