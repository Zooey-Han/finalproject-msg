//
//  ProgressBar.swift
//  MSG
//
//  Created by sehooon on 2023/01/18.
//

import SwiftUI

struct ProgressBar: View {
    
    @Binding var progress:[(tag:String, money:Float)]
    @Binding var percentArr:[(to: Float, from: Float, percent: Float)]
    @Binding var totalMoney: Float
    @Binding var selection:String
    @State private var selectMoney = 0
    @State private var selectPercent = 0
    @State private var bright:Double = 0.0
    @State private var colorArr:[Color] = [Color("Chart1"), Color("Chart2"), Color("Chart3"), Color("Chart4"), Color("Chart5"), Color("Chart6"), Color("Chart7"),Color("Chart8")]
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
                .frame(width: 250,height: 250)
            VStack{
                if selection == "" {
                    Text("\(Int(totalMoney))원")
                        .font(.title2)
                        .fontWeight(.bold)
                }else{
                    Text("\(selectPercent)%")
                        .fontWeight(.bold)
                    Text("\(selectMoney)원")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    Text("\(selection)")
                        .fontWeight(.bold)
                }
            }.onChange(of: selection) { tagName in
                var find = false
                for expenditure in progress{
                    if tagName == expenditure.tag{
                        self.selectMoney = Int(expenditure.money)
                        self.selectPercent = Int(expenditure.money / totalMoney * 100)
                        find = true
                        break
                    }
                }
                if !find{ selection = "" }
            }
            
            ForEach(progress.indices.reversed(),id:\.self){ index in
                Circle()
                    .trim(from: CGFloat(percentArr[index].from), to: CGFloat(min(percentArr[index].to, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .brightness(selection == progress[index].tag ? 0.2 : 0)
                    .foregroundColor(colorArr[index])
                    .frame(width: 250,height: 250)
                    .rotationEffect(Angle(degrees: 270.0))
                    .onAppear{
                        withAnimation{
                            let percent = progress[index].money / totalMoney
                            percentArr[index].to = percentArr[index].from + percent
                            if index < progress.count-1 {
                                percentArr[index+1].from = percentArr[index].to
                            }
                        }
                    }
            }
        }
    }
}
//
//struct ProgressBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressBar()
//    }
//}
