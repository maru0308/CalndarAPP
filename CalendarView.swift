import SwiftUI
import FSCalendar




struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}




struct CalendarView: UIViewRepresentable {

    @Binding var selectedDate: Date

    @Binding var currentPageDate: Date
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()

        
        calendar.dataSource = context.coordinator
            calendar.delegate = context.coordinator
            calendar.appearance.headerTitleColor = UIColor.darkText // 月と年のラベルの色を設定します
            calendar.appearance.weekdayTextColor = UIColor.darkGray // 曜日のラベルの色を設定します
            calendar.appearance.titleDefaultColor = UIColor.darkText // 日付のラベルの色を設定します
            calendar.appearance.titleSelectionColor = UIColor.white // 選択された日付のラベルの色を設定します
            calendar.appearance.selectionColor = UIColor.systemBlue // 選択された日付の背景色を設定します
            calendar.appearance.todayColor = UIColor.systemGray // 今日の日付の背景色を設定します
            calendar.appearance.todaySelectionColor = UIColor.systemBlue // 今日の日付が選択された場合の背景色を設定します
            calendar.backgroundColor = UIColor.white // カレンダーの背景色を設定します
            calendar.appearance.borderRadius = 0.5 // カレンダーのセルの角の半径を設定します
            calendar.appearance.borderDefaultColor = UIColor.clear // カレンダーのセルの境界線の色を設定します
            calendar.appearance.borderSelectionColor = UIColor.clear // 選択されたカレンダーセルの境界線の色を設定します
            calendar.appearance.headerDateFormat = "MMMM yyyy" // 月と年のラベルの形式を設定します
            calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16, weight: .medium) // 日付のラベルのフォントを設定します
            calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold) // 月と年のラベルのフォントを設定します
             calendar.appearance.titleWeekendColor = .red //週末（土、日曜の日付表示カラー）
           calendar.appearance.headerDateFormat = "yyyy/MM" //ヘッダー表示のフォーマット
        
        
        return calendar
    }
    
    
    //  updateUIView(_:,context:) メソッドはSwiftUIのViewが更新されたときに呼び出され,
    //    uiView を引数として受け取ることで、メソッド内で uiView に対して様々な操作を行うことができ、その結果をSwiftUIのViewに反映させることができます
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.select(selectedDate)
        let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: currentPageDate)!
        if Calendar.current.isDate(selectedDate, equalTo: nextMonthDate, toGranularity: .month) {
            uiView.setCurrentPage(nextMonthDate, animated: true)
            currentPageDate = nextMonthDate
        } else if !Calendar.current.isDate(selectedDate, equalTo: currentPageDate, toGranularity: .month) {
            uiView.setCurrentPage(selectedDate, animated: true)
            currentPageDate = selectedDate
        }
    }
    
    
    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDataSource, FSCalendarDelegate {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
            
            super.init()
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            // 選択された日付に1を返すことでドットを表示する
            if Calendar.current.isDate(date, inSameDayAs: self.parent.selectedDate) {
                
                return 1
            } else {
                return 0
            }
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            // 選択された日付を保存する
            self.parent.selectedDate = date
            
            
            calendar.reloadData()
        }
    }
}





