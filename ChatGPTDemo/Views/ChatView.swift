//
//  ChatView.swift
//  ChatGPTDemo
//
//  Created by Dhaval Dobariya on 24/04/23.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollViewReader { value in
                ScrollView {
                    //                .filter({ $0.role != .system })
                    ForEach(viewModel.messages, id: \.id) { message in
                        messageView(message: message)
                            .id(message.id)
                    }
                }
                .onAppear {
                    value.scrollTo(viewModel.messages.last?.id)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    value.scrollTo(viewModel.messages.last?.id)
                }
            }
            
            if viewModel.apiCallInProgress {
                HStack(spacing: 0) {
                    typingIndicator()
                    Spacer()
                }                
            }
            
            HStack(spacing: 0) {
                TextField("Enter a message...", text: $viewModel.currentInput)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))

                Button {
                    if !viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        viewModel.sendMessage()                        
                    }
                } label: {
                    Text("Send")
                        .padding(11)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }
            }
            .cornerRadius(12)

        }
        .padding()
    }
    
    /// MessageView
    /// - Parameter message: message object
    /// - Returns: View
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user { Spacer() }
            Text (message.content)
                .padding()
                .background(message.role == .user ? Color.blue : (message.role == .system ? Color.green : Color.gray.opacity(0.2)))
                .foregroundColor(message.role == .user ? Color.white : Color.black)
                .cornerRadius(12)
            if message.role == .assistant { Spacer() }
        }
    }
    
    
    /// Typing Indicator
    @State private var numberOfTheAnimationgBall = 3
    let ballSize: CGFloat = 10
    let speed: Double = 0.3
    func typingIndicator() -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text("typing")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.gray)
            ForEach(0..<3) { i in
                Capsule()
                    .foregroundColor((self.numberOfTheAnimationgBall == i) ? .blue : Color(UIColor.darkGray))
                    .frame(width: self.ballSize, height: (self.numberOfTheAnimationgBall == i) ? self.ballSize/3 : self.ballSize)
            }
        }
        .animation(Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.1).speed(2))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { _ in
                var randomNumb: Int
                repeat {
                    randomNumb = Int.random(in: 0...2)
                } while randomNumb == self.numberOfTheAnimationgBall
                self.numberOfTheAnimationgBall = randomNumb
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
