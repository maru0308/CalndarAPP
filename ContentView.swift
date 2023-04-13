
import SwiftUI
import RealmSwift

struct ContentView: View {
    @State var selectedDate = Date()
    @State var currentPageDate = Date()
    
    let realm = try! Realm()

    // イベントタイトルを取得する関数
    func getEventTitles() -> [String] {
        let events = realm.objects(Event.self)
        return events.map { $0.title }
    }
    

    
    var body: some View {
        NavigationView {
            VStack {
                // タイトルテキスト
                Text("Calendar")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .rotationEffect(.degrees(10))

                // 現在の日付テキスト
                Text(currentPageDate, style: .date)
                    .font(.headline)
                    .padding(.top, 10)

                // カレンダービュー
                CalendarView(selectedDate: $selectedDate, currentPageDate: $currentPageDate)
                    .frame(width: 300, height: 300)
                    .background(Color.white)
                    .padding()

                // 本日の予定タイトルテキスト
                Text("本日の予定")
                    .font(.system(size: 20, weight: .semibold))

                // 選択された日のイベントを表示
                if Calendar.current.isDate(selectedDate, inSameDayAs: selectedDate) {
                    Text(getEventTitles().randomElement() ?? "")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                        .scaleEffect(1.5)
                }

                // イベントリストビューへのナビゲーションリンク
                NavigationLink(destination: EventListView().navigationTitle("イベント設定")) {
                    Image(systemName: "pencil.tip.crop.circle")
                        .foregroundColor(.black)
                        .font(.system(size: 80))
                }
                .padding(.bottom, 40) // ナビゲーションリンクと下部の間のスペースを追加
            }
            .padding(.horizontal, 10) // 横方向のスペースを追加してiPhone SEとiPadで収まるようにする
        }
    }

}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

