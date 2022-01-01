//
//  ContentView.swift
//  Neumorphism
//
//  Created by Vincent Palma on 2021-12-23.
//

import SwiftUI
import HealthKit

extension Color {
    
    static let offWhite = Color(red: 225/255, green: 225/255, blue: 235/255)
    
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    
    static let darkEnd = Color(red: 25/255, green: 25/255, blue: 30/255)
    
    static let lightStart = Color(red: 225/255, green: 225/255, blue: 235/255)
    
    static let lightEnd = Color(red: 190/255, green: 190/255, blue: 200/255)
    
    
}

extension LinearGradient {
    init(_ colors : Color...){
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct SimpleButtonStyle: ButtonStyle {
    
    @State private var animationAmount = 1.0
    
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                Group{
                    if configuration.isPressed{
                        Circle()
                            .fill(Color.offWhite)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray,lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.black,Color.clear)))
                            )
                            .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 8)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                            
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                            )
                            /*.shadow(color: Color.black.opacity(0.2), radius: 10, x: -5, y: -5)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: 10, y: 10)
                            .animation(
                                .easeInOut(duration: 2),
                                value: animationAmount
                            )*/
                            
                    } else {
                    Circle()
                        .fill(Color.offWhite)
                        
                        
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .animation(.easeInOut(duration: 0), value: 0.0)
                         
                    }
                } .animation(
                    .easeInOut(duration: 2),
                    value: animationAmount
                )
            )
    }
                
}

// ----------------------------------------------------  LIGHT MODE  --------------------------------------------------------


// ----------------------------------------------------  BUTTONS  --------------------------------------------------------
struct ColorfulßBackground<S: Shape> : View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View{
        ZStack{
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart,Color.lightEnd),lineWidth:4)).blur(radius: 2)
                    .shadow(color: Color.lightStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.lightEnd, radius: 10, x: -5, y: -5)
                    
            }else{
                shape
                    .fill(LinearGradient(Color.lightStart, Color.lightEnd))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    .blur(radius: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                   // .shadow(color: Color.lightStart, radius: 10, x: -10, y: -10)
                   // .shadow(color: Color.lightEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}
struct ColorfulButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(22)
            .contentShape(Circle())
            .background(
                ColorfulßBackground(isHighlighted: configuration.isPressed, shape: Circle())
            )
            .animation(Animation.easeInOut(duration: 0.0), value: 0)
            
    }
}

struct ColorfulToggleStyle : ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }){
            configuration.label
                .padding(25)
                .contentShape(Circle())
            
        }
        .background(
            ColorfulßBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}


// ----------------------------------------------------  DATA WINDOW  --------------------------------------------------------


struct roundedRectangleView : View {
    
    var body : some View {
        
        RoundedRectangle(cornerRadius: 25)
            .fill(LinearGradient(Color.lightStart, Color.lightEnd))
            .frame(width: 400, height: 600)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            .blur(radius: 1.0)
    }
}



struct DataTitle: View {
    var body: some View {
        
            Text("")
            //.multilineTextAlignment(.leading)
            .font(Font.custom("KlavikaRegular-TF",size: 50.0)).padding().offset(y:-40)
        
    }
}



// ----------------------------------------------------  CONTENT VIEW  --------------------------------------------------------



struct ContentView: View {
    
    @State var todaysSteps = Int()
    @State var todaysCalories = Int()
    private var repository: HKRepository?
    
    
    @State private var steps: [Step] = [Step]()
    @State private var healthData: [HealthData] = [HealthData]()
    
    
    @ObservedObject var firestore = FireBaseViewModel()
    
    
    init(){
        repository = HKRepository()
     //   firestore.getData()
    }
    
    

    private func updateUIFromStatistics ( statisticsCollection: HKStatisticsCollection){
        let startDate = Calendar.current.date(byAdding: .day, value: -0, to: Date())!
        let endDate = Date()
        
        
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate){ statistics,stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 00), date: statistics.startDate)
            steps.append(step)
            
        }
        todaysSteps = steps.last!.count
    }
    
    @State private var isToggled = false
    
    var body: some View {
        
        VStack {
            
            ZStack (alignment: .bottom){
                
                LinearGradient(Color.lightStart, Color.lightEnd)
                DataTitle().offset(y:-680)
               
                ZStack {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(Color.lightStart, Color.lightEnd))
                            .frame(width: 300, height: 500)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            .blur(radius: 1.0)
                            .padding()
                            .offset(y:-150)
                        
                        //List
                   
                      
                        VStack {
                            Text("KCAL TODAY").padding().offset(y:-200).font(Font.custom("KlavikaRegular-TF",size: 30.0))
                            Text("\(todaysCalories)")
                                .padding()
                                .offset(y:-200)
                                .font(Font.custom("KlavikaRegular-TF",size: 40.0))
                            
                            
                            
                            Text("STEPS TODAY").padding().offset(y:-100).font(Font.custom("KlavikaRegular-TF",size: 25.0))
                          
                            Text("\(todaysSteps)")
                                .padding()
                                .offset(y:-100)
                                .font(Font.custom("KlavikaRegular-TF",size: 25.0))
                       
                            //List(steps,id:\.id){ step in // foreach
                                
                                //Text("\(step.count)")
                            //}
                       
                        }
                    }
                    //ContentWindow().padding().offset(y:-150)
                    
                  
                }
                
                
                // HORIZONTAL SETTINGS
                HStack(alignment: .center, spacing: 120){
                    Button(action: {
                        print("Data Updated")
                     //   if(){
                            
                            
                     //   }else{
                     //       firestore.updateData(todoToUpdate: todaysSteps)
                            
                    //}
                    }){
                        Image("Fire-Magenta")
                            .resizable()
                            .frame(width: 40.0, height: 45.0)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(ColorfulButtonStyle())
                    
                    Toggle(isOn: $isToggled) {
                        HStack {
                            Image("Ribbon-Magenta")
                                .resizable()
                                .frame(width: 35.0, height: 40.0)
                                .foregroundColor(.gray)
                                
                            //Spacer()
                        }

                            
                    }
                    .toggleStyle(ColorfulToggleStyle())
                    
                }
                .offset(y:-10)
                .padding(20.0)
                
                
               
            }
            .edgesIgnoringSafeArea(.all)
            
            // START OF APP DO FOLLOWING :
            
            .onAppear {
                if let repository = repository {
                    repository.requestAuthorization { success in
                        if success{

                            
                            
                            repository.calculateSteps{statisticsCollection in
                                if let statisticsCollection = statisticsCollection {
                                    // Update ui
                                    updateUIFromStatistics(statisticsCollection: statisticsCollection)
                                }
                             }
                        }
                    }
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
    }
}



/*
 // ----------------------------------------------------  DARK MODE  --------------------------------------------------------
 struct DarkBackground<S: Shape> : View {
     var isHighlighted: Bool
     var shape: S
     
     var body: some View{
         ZStack{
             if isHighlighted {
                 shape
                     .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                     .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                     .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
             }else{
                 shape
                     .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                     .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                     .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
             }
         }
     }
 }

 struct DarkButtonStyle: ButtonStyle {
     func makeBody(configuration: Configuration) -> some View {
         configuration.label
             .padding(30)
             .contentShape(Circle())
             .background(
                 DarkBackground(isHighlighted: configuration.isPressed, shape: Circle())
             )
             .animation(Animation.easeInOut(duration: 0.0), value: 0)
     }
 }




 struct DarkToggleStyle : ToggleStyle {
     func makeBody(configuration: Self.Configuration) -> some View {
         Button(action: {
             configuration.isOn.toggle()
         }){
             configuration.label
                 .padding(30)
                 .contentShape(Circle())
             
         }
         .background(
             DarkBackground(isHighlighted: configuration.isOn, shape: Circle())
         )
     }
 }
 */
