//
//  CheckboxView.swift
//  iBerro
//
//  Created by Danilo Araújo on 21/07/21.
//

import SwiftUI

struct CheckboxView: View {
    @State var type: CheckBoxType
    @State var list: [String]
    
    var body: some View {
        HStack{
            ForEach(0..<list.count, content: { index in
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack{
                        Image("BgCheckbox")
                            .resizable()
                            .frame(width: 184, height: 184, alignment: .trailing)
                        
                        Text(list[index])
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.bottom)
                    }
                })
            })
        }.frame(width: 900, height: 184, alignment: .center)
    }
}

enum CheckBoxType {
    case musicGender
    case maxScore
}

//struct CheckboxView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckboxView()
//    }
//}
