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
    @State private var isEnabled = false

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
                        isEnabled = true
                        withAnimation {
                            animationAmount += 360
                        }
                        flagTapped(number)
                    }) {
                        FlagImage(name: self.countries[number])
                    }
                    .rotation3DEffect(
                        .degrees(isCorrectFlag(number) ?
                                    animationAmount : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .opacity(!isCorrectFlag(number) && isEnabled ?
                                0.25 : 1)
                    .disabled(isEnabled)
                }

                Text("""
                    Score: \(score)
                    \(scoreTitle)
                    """)
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)

                Button("Next round") {
                    self.askQuestion()
                    self.isEnabled = false
                }
                .disabled(!isEnabled)
                .foregroundColor(.white)
                .font(.title)
                .padding(7.5)
                .background(Color.orange)
                .clipShape(Capsule())

                Spacer()
            }
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
    }

    func askQuestion() {
        scoreTitle = ""
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
