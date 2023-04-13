

import SwiftUI
import RealmSwift

// イベントクラス
class Event: Object {
    @objc dynamic var title: String = ""
}

struct EventListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let realm = try! Realm()
    @State private var eventTitles: [String] = []
    @State private var newEventTitle: String = ""
    @State private var defaultEventTitles: [String] = [
        "友人の結婚式", "ヨガ", "ランニング", "英語のオンラインレッスン", "カフェで読書", "美術館巡り",
        "人工知能と教育の勉強会", "ヘアサロンの予約", "車の点検", "犬のトリミング", "ジムでボディメイク",
        "プレゼンの準備", "デザインの打ち合わせ", "Webサイトの更新作業", "映画鑑賞", "ゲーム大会",
        "音楽フェス参加", "温泉旅行", "海外旅行", "マーケティングの勉強会", "ファッションショー",
        "美容イベント参加", "ブログの執筆作業", "オフィスの移転作業", "コンサルティング業務",
        "ウェブセミナーの開催", "新規プロジェクトの立ち上げ", "会議の準備", "現代アート展示会",
        "キャンドルライトディナー"
    ]
    
    // イベントの読み込み
    private func loadEvents() {
        let events = realm.objects(Event.self)
        eventTitles = events.map { $0.title }
    }
    
    // イベントの保存
    private func saveEvent(title: String) {
        let event = Event()
        event.title = title
        
        try! realm.write {
            realm.add(event)
        }
    }
    
    // 全てのイベントの削除
    private func deleteAllEvents() {
        let events = realm.objects(Event.self)
        try! realm.write {
            realm.delete(events)
        }
    }
    
    // イベントタイトルのリセット
    private func resetEventTitles() {
        deleteAllEvents()
        eventTitles = defaultEventTitles
        for title in eventTitles {
            saveEvent(title: title)
        }
    }
    
    // イベントの削除
    private func deleteEvent(at offsets: IndexSet) {
        offsets.forEach { index in
            let events = realm.objects(Event.self)
            if index < events.count {
                let event = events[index]
                try! realm.write {
                    realm.delete(event)
                }
                eventTitles.remove(at: index)
            }
        }
    }
    var body: some View {
        VStack {
            List {
                ForEach(eventTitles.indices, id: \.self) { index in
                    Text(eventTitles[index])
                }
                .onDelete(perform: deleteEvent)
            }
            .navigationBarTitle("イベント一覧", displayMode: .inline)
            
            HStack {
                TextField("新しいイベントタイトル", text: $newEventTitle)
                Button(action: {
                    if !newEventTitle.isEmpty && eventTitles.count < 32 {
                        eventTitles.append(newEventTitle)
                        saveEvent(title: newEventTitle)
                        newEventTitle = ""
                    }
                }) {
                    Image(systemName: "plus")
                }
                .disabled(eventTitles.count >= 32 || newEventTitle.isEmpty)
            }
            .padding()
            
            HStack {
                Button(action: {
                    deleteAllEvents()
                    eventTitles = []
                }) {
                    Text("全て削除")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    resetEventTitles()
                }) {
                    Text("イベント自動作成")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .onAppear(perform: loadEvents)
    }
}
