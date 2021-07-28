//
//  PlayingView.swift
//  iBerro
//
//  Created by Pedro Henrique Spínola de Assis on 15/07/21.
//

import SwiftUI

struct PlayingView: View {
    var matchDelegate: GameViewController
    @ObservedObject var game: GameViewModel
    
    @State var players: [Player]
    @State var filter: String = "mpb" //PEGAR DO LOBBY
    @State private var readyToSing: Bool = false
    @State var previewIsOver: Bool = false
    
    @State private var timeRemaining = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var timeRemainingToSing: Int = 15
    let timerToSing = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            
            Background()
            
            VStack(alignment: .center, spacing: 10) {
                Head(player: players.first(where: {player in player.status == .singing})!)
                    .padding(.top, 20)
                
                
                    if timeRemaining > 0 {
                        Spacer()
                        
                        InitialTimer(timeRemaining: $timeRemaining)
                        
                    } else {
                        if previewIsOver == true && timeRemainingToSing > 0 {
                            
                            SingTimer(timeRemainingToSing: $timeRemainingToSing)
                                .onReceive(timerToSing) { time in
                                    if self.timeRemainingToSing > 0 {
                                        self.timeRemainingToSing -= 1
                                    }
                                }
                                
                            
                                if readyToSing {
                                    Spacer()
                                    SoundVisualizer()
                                }
                                
                            } else {
                                if !previewIsOver {
                                    Spacer()
                                    
                                    MusicPlayer(filter: $filter, previewIsOver: $previewIsOver)
                                    
                                } else {
                                    //ir para próxima tela, pois acabou o tempo
                                    Text("Acabou o tempo").foregroundColor(.white)
                                }
                            }
                            
                        }
                    
                    Spacer()
                    
                    if readyToSing {
                        
                        DoneButton()
                        
                    } else {
                        
                        SingButton(readyToSing: $readyToSing, previewIsOver: $previewIsOver)
                        
                    }
                    
                PlayersView(players: $players)
                    
                }
                .padding(.top, 20)
            }
            .ignoresSafeArea()
            .onReceive(timer) { time in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
            }
            
        }
    }
    
    struct Background: View {
        var body: some View {
            Image("BgMenu")
                .resizable()
        }
    }
    
    struct Head: View {
        @State var player: Player
        
        var body: some View {
            HStack(spacing: 20) {
                Image(uiImage: UIImage(data: player.photo.image) ?? UIImage(named: "Group 3")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(
                        minWidth: 50,
                        idealWidth: 100,
                        maxWidth: 200,
                        minHeight: 50,
                        idealHeight: 100,
                        maxHeight: 200,
                        alignment: .center)
                    .padding([.trailing])
                
                Text("\(player.displayName.uppercased())'s TURN".localized())
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing])
                    .allowsTightening(true)
                    .lineLimit(3)
                
                Button(action: {
                    print("sair")
                }, label: {
                    ZStack(alignment: .center) {
                        Image("BgButtonCreateRoom")
                            .resizable()
                        
                        
                        Text("SKIP TURN".localized())
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                    }
                })
                .frame(minWidth: 75, idealWidth: 155, maxWidth: 225, minHeight: 75, idealHeight: 125, maxHeight: 155, alignment: .center)
            }
            //        .padding([.leading, .trailing], 20)
        }
    }
    
    struct InitialTimer: View {
        @Binding var timeRemaining: Int
        
        var body: some View {
            Text("\(timeRemaining)")
                .font(.system(size: 70))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                //            .padding()
                .frame(width: 250, height: 350, alignment: .center)
        }
    }
    
    struct SingTimer: View {
        @Binding var timeRemainingToSing: Int
        
        var body: some View {
            HStack {
                Text(String(format: "00:%02d", timeRemainingToSing))
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding([.top], 20)
                    .padding(.leading, 85)
                
                Spacer()
             }
            
        }
    }
    
    struct DoneButton: View {
        var body: some View {
            Button(action: {
                //Ir pra próxima tela (votação)
                print("Terminou de cantar")
            }, label: {
                ZStack {
                    Image("BgButtonSignIn")
                        .resizable()
                    
                    Text("FINISHED".localized())
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.bottom, 25)
                }
            })
            .frame(minWidth: 130, idealWidth: 210, maxWidth: 260, minHeight: 130, idealHeight: 180, maxHeight: 210, alignment: .center)
        }
    }
    
    struct SingButton: View {
        @Binding  var readyToSing: Bool
        @Binding var previewIsOver: Bool
        
        var body: some View {
            Button(action: {
                readyToSing.toggle()
            }, label: {
                ZStack (alignment: Alignment(horizontal: .center, vertical: .center)) {
                    if !previewIsOver {
                        Image("BgButtonSingDisabled")
                            .resizable()
                        
                        Text("BELT OUT".localized())
                            .font(.title)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)))
                            .padding(.bottom, 25)
                        
                    } else {
                        Image("BgButtonSignIn")
                            .resizable()
                        
                        Text("BELT OUT".localized())
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.bottom, 25)
                    }
                }
            })
            .disabled(!previewIsOver)
            .frame(minWidth: 130, idealWidth: 210, maxWidth: 260, minHeight: 130, idealHeight: 180, maxHeight: 210, alignment: .center)
        }
    }