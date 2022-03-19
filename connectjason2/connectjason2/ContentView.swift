import SwiftUI
struct ContentView: View {
    enum piece {
        case White
        case Blue
        case kosong
    }

    @AppStorage("white") var white = 0
    @AppStorage("blue") var blue = 0
    @AppStorage("draw") var draw = 0
    @State private var Board = Array(repeating: piece.kosong, count: 42)
    @State private var RedPiece = 21
    @State private var YellowPiece = 21
    @State private var turn = "user"
    @State private var finish = false
    @State private var winner = ""
    @State private var connect : [Int] = []
    var body: some View {
        NavigationView {
            GeometryReader {
                geometry in
                ZStack{
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    circleimage(name: "crycat")
                    HStack {
                        Circle()
                        .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                        .foregroundColor(Color(red: 255/255, green: 255/255, blue: 255/255))
                        VStack {
                            HStack {
                                Text("White : \(white)")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                Spacer()
                                Text("Draw : \(draw)")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                Spacer()
                                Text("Blue: \(blue)")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                            }
                            HStack {
                                Text("")
                                Spacer()
                                Text("VS")
                                    .foregroundColor(Color.white)
                                Spacer()
                                Text("")
                            }
                        }
                        Circle()
                        .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                        .foregroundColor(Color.blue)
                    }
                    let col = Array(repeating: GridItem(), count:7)
                    LazyVGrid(columns: col) {
                        ForEach(Board.indices) {
                            index in
                            switch Board[index] {
                                case .kosong:
                                Circle()
                                .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                                    .foregroundColor(Color.gray)
                                .onTapGesture {
                                    if (!finish && turn == "user" && winner != "draw") {
                                        turn = "White"
                                        redTurn(index: index)
                                        RedPiece -= 1
                                        finish = PlayerWin()
                                        if (finish) {
                                            winner = "White"
                                            white += 1
                                            RedPiece = 21
                                        }
                                        turn = "Blue"
                                    }
                                    else if (!finish && turn == "Blue" && winner != "draw") {
                                        yellowTurn(index: index)
                                        YellowPiece -= 1
                                        finish = PlayerWin()
                                        if (finish) {
                                            winner = "Blue"
                                            blue += 1
                                            YellowPiece = 21
                                        }
                                        else if (YellowPiece == 0) {
                                            winner = "draw"
                                            draw += 1
                                        }
                                        else {
                                            turn = "user"
                                        }
                                    }
                                }
                                case .White:
                                if connect.contains(index) {
                                    Circle()
                                    .background(Circle().fill(Color(red: 255/255, green: 255/255, blue: 255/255)))
                                    .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                                }
                                else {
                                    Circle()
                                    .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                                    .foregroundColor(Color(red: 255/255, green: 255/255, blue: 255/255))
                                }
                                case .Blue:
                                if connect.contains(index) {
                                    Circle()
                                    .background(Circle().fill(Color.blue))
                                    .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                                }
                                else {
                                    Circle()
                                    .frame(width: geometry.size.width/9, height: geometry.size.width/9)
                                    .foregroundColor(Color.blue)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(red: 70/255, green: 70/255, blue: 70/255))
                    .cornerRadius(15)
                    .padding(.bottom)
                    HStack {
                        Spacer()
                        if (turn == "user" && winner == "") {
                            Text("White Turn")
                            .bold()
                            .font(.largeTitle)
                        }
                        if (turn == "Blue" && winner == "") {
                            Text("Blue Turn")
                            .bold()
                            .font(.largeTitle)
                        }
                        if (winner == "White") {
                            Text("White Win！")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        }
                        else if (winner == "Blue") {
                            Text("Blue Win!")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        }
                        else if (YellowPiece == 0){
                            Text("Draw")
                            .font(.largeTitle)
                        }
                        Spacer()
                    }
                    .padding(8)
                    .background(Color(red: 70/255, green: 70/255, blue: 70/255))
                    .cornerRadius(15)
                    .padding(.bottom)
                    if (winner != "") {
                        HStack {
                            Spacer()
                            Button {
                                Board = Array(repeating: piece.kosong, count: 42)
                                RedPiece = 21
                                YellowPiece = 21
                                turn = "user"
                                finish = false
                                winner = ""
                                connect = []
                            }
                            label: {
                                Text("New Round")
                                .bold()
                                .font(.largeTitle)
                            }
                            Spacer()
                        }
                        .padding(8)
                        .background(Color(red: 70/255, green: 70/255, blue: 70/255))
                        .cornerRadius(15)
                        
                    }
                    HStack{
                        Text("Connect 4")
                        .foregroundColor(Color.blue)
                            .bold()
                        .font(.largeTitle)
                        Spacer()
                        Button {
                            Board = Array(repeating: piece.kosong, count: 42)
                            RedPiece = 21
                            YellowPiece = 21
                            turn = "user"
                            finish = false
                            winner = ""
                            connect = []
                            white = 0
                            blue = 0
                            draw = 0
                        }
                        label: {
                            Text("Reset")
                            .bold()
                            .font(.title)
                            .scaledToFit()
                            .padding(9)
                                .background(Color(red: 70/255, green: 70/255, blue: 70/255))
                                .cornerRadius(/*@START_MENU_TOKEN@*/13.0/*@END_MENU_TOKEN@*/)
                        }
                    }
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.black/*@END_MENU_TOKEN@*/)
                }
            }
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.black/*@END_MENU_TOKEN@*/)
        }
            .navigationBarHidden(true)
    }
    }

    func redTurn(index: Int) {
        var cons = index
        while (cons+7 <= 41 && self.Board[cons+7] == piece.kosong) {
            cons += 7
        }
        self.Board[cons] = piece.White
    }

    func yellowTurn(index: Int) {
        var cons = index
        while (cons+7 <= 41 && self.Board[cons+7] == piece.kosong) {
            cons += 7
        }
        self.Board[cons] = piece.Blue
    }

    func PlayerWin() -> Bool {
        for r in 0...2 {
            for c in 0...3 {
                if (self.Board[7*r+c] != .kosong
                    && self.Board[7*r+c] == self.Board[7*r+c+8]
                    && self.Board[7*r+c+8] == self.Board[7*r+c+16]
                    && self.Board[7*r+c+16] == self.Board[7*r+c+24]) {
                    connect.append(7*r+c)
                    connect.append(7*r+c+8)
                    connect.append(7*r+c+16)
                    connect.append(7*r+c+24)
                    return true
                }
            }
        }
        for r in 0...2 {
            for c in 0...3 {
                if (self.Board[7*r+3+c] != .kosong
                    && self.Board[7*r+3+c] == self.Board[7*r+3+c+6]
                    && self.Board[7*r+3+c+6] == self.Board[7*r+3+c+12]
                    && self.Board[7*r+3+c+12] == self.Board[7*r+3+c+18]) {
                    connect.append(7*r+3+c)
                    connect.append(7*r+3+c+6)
                    connect.append(7*r+3+c+12)
                    connect.append(7*r+3+c+18)
                    return true
                }
            }
        }
        for r in 0...2 {
            for c in 0...6 {
                if (self.Board[7*r+c] != .kosong
                    && self.Board[7*r+c] == self.Board[7*r+c+7]
                    && self.Board[7*r+c+7] == self.Board[7*r+c+14]
                    && self.Board[7*r+c+14] == self.Board[7*r+c+21]) {
                    connect.append(7*r+c)
                    connect.append(7*r+c+7)
                    connect.append(7*r+c+14)
                    connect.append(7*r+c+21)
                    return true
                }
            }
        }
        for r in 0...5 {
            for c in 0...3 {
                if (self.Board[7*r+c+1] != .kosong
                    && self.Board[7*r+c] == self.Board[7*r+c+1]
                    && self.Board[7*r+c+1] == self.Board[7*r+c+2]
                    && self.Board[7*r+c+2] == self.Board[7*r+c+3]) {
                    connect.append(7*r+c)
                    connect.append(7*r+c+1)
                    connect.append(7*r+c+2)
                    connect.append(7*r+c+3)
                    return true
                }
            }
        }
        return false
    }

}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

}
struct circleimage: View {
    let name: String
    
    var body: some View{
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .shadow(radius: 20)
}

}



