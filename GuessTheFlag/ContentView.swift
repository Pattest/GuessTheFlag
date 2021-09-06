//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Baptiste Cadoux on 01/09/2021.
//

import SwiftUI

struct FlagImage: View {
    var name: String

    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
            .opacity(1)
    }
}

struct ContentView: View {
    @State private var animationAmount = 0.0
    @State private var enabled = false
    @State private var countries = [
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Italy",
        "Nigeria",
        "Poland",
        "Russia",
        "Spain",
        "UK",
        "US"]
        .shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""

    @State private var score = 0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of...")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                .foregroundColor(.white)

                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation {
                            self.animationAmount += 360
                            self.enabled = true
                        }
                        self.flagTapped(number)
                    }) {
                        FlagImage(name: self.countries[number])
                    }
                    .rotation3DEffect(
                        .degrees(isCorrectFlag(number) ?
                                    animationAmount : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.default)
                    .opacity(!isCorrectFlag(number) && enabled ?
                                0.25 : 1)
                }

                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .fontWeight(.black)

                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle),
                  message: Text("Your score is \(score)"),
                  dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                    self.enabled = false
                })
        }
    }

    func isCorrectFlag(_ number: Int) -> Bool {
        return number == correctAnswer
    }

    func flagTapped(_ number: Int) {
        if isCorrectFlag(number) {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }

        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
