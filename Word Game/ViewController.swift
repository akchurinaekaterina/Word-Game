//
//  ViewController.swift
//  Word Game
//
//  Created by Ekaterina Akchurina on 26.09.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var labels = [UILabel]()
    var textsForLabels = ["Score: 0", "CLUES", "ANSWERS"]
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var wordsguessed = 0
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1 {
        didSet {
            loadlevel()
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        cluesLabel = UILabel()
        answersLabel = UILabel()
        
        labels += [scoreLabel, cluesLabel, answersLabel]
        
        for label in labels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = textsForLabels[labels.firstIndex(of: label)!]
            label.font = UIFont.systemFont(ofSize: 16)
            if label != scoreLabel {
                label.font = UIFont.systemFont(ofSize: 24)
                label.numberOfLines = 0
                label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
            }
            if label != cluesLabel {
                label.textAlignment = .right
            }
            view.addSubview(label)
        }
  
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 10
        buttonsView.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)

            
        ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterbutton = UIButton(type: .system)
                letterbutton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterbutton.setTitle("WWW", for: .normal)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterbutton.frame = frame
                letterbutton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                buttonsView.addSubview(letterbutton)
                letterButtons.append(letterbutton)
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadlevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {return}
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        
            guard let answerText = currentAnswer.text else {return}
            guard let index = solutions.firstIndex(of: answerText) else {
                let mistakeAlert = UIAlertController(title: "You are wrong!", message:"Try again", preferredStyle: .alert)
                mistakeAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    for button in self.activatedButtons {
                        button.isHidden = false
                    }
                    self.activatedButtons.removeAll()
                    self.currentAnswer.text = ""
                    self.score -= 1
                }))
                present(mistakeAlert, animated: true, completion: nil)
                return
                
            }
                
            var solutionsarray = answersLabel.text!.components(separatedBy: "\n")
            solutionsarray[index] = answerText
            answersLabel.text = solutionsarray.joined(separator: "\n")
        activatedButtons.removeAll()
        currentAnswer.text = ""
        score += 1
        wordsguessed += 1
        
        if wordsguessed % 7 == 0 {
            let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text?.removeAll()
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
        
    }
    
    func loadlevel(){
        var cluestring = ""
        var solutionString = ""
        var letterBits = [String]()
         
        DispatchQueue.global().async {
            if let levelFileURL = Bundle.main.url(forResource: "level\(self.level)", withExtension: ".txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    cluestring += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters.\n"
                    self.solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
            DispatchQueue.main.async {
            
            self.cluesLabel.text = cluestring.trimmingCharacters(in: .whitespacesAndNewlines)
            self.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
            if letterBits.count == self.letterButtons.count {
                for i in 0..<self.letterButtons.count {
                self.letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
            }
    }
    }
    func levelUp(_ action: UIAlertAction){
        solutions.removeAll()
        for btn in letterButtons {
            btn.isHidden = false
        }
        if level == 1 {
            level += 1
        } else {
            level = 1
        }
    }

}

