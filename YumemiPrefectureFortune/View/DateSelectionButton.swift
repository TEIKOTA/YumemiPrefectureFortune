import SwiftUI

struct DateSelectionButton: View {
    let placeholder: String
    @Binding var selection: Date? // 親Viewと日付を同期するためのBinding

    @State private var isSheetPresented = false
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }

    var body: some View {
        Button {
            self.isSheetPresented = true
        } label: {
            HStack {
                if let selection {
                    Text(dateFormatter.string(from: selection))
                        .foregroundColor(.accentColor)
                } else {
                    Text(placeholder)
                        .foregroundColor(Color(UIColor.placeholderText))
                }
                Spacer()
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            datePickerSheet
        }
    }
    
    private var datePickerSheet: some View {
        VStack {
            DatePicker(
                "日付を選択",
                selection: $selection.nonOptional(defaultValue: Date()),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            
            /// 日の変更のみ閉じるようにし年と月が変更された際は閉じないようにする
            /// 2025.6.12から他の月や年に変えても日付自体も変える可能性がほとんどのため
            /// 初期は今日の月のカレンダーなため生年月日の年月まで戻る際にいちいち閉じるのはUXとして最悪である
            /// その場合3回もこのボタンをタップする必要が出てくる
            .onChange(of: selection ?? Date()) { oldValue, newValue in
                let calendar = Calendar.current
                let oldDay = calendar.component(.day, from: oldValue)
                let newDay = calendar.component(.day, from: newValue)

                if oldDay != newDay {
                    isSheetPresented = false
                }
            }
            
        }
        .padding()
        .presentationDetents([.medium])
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedDate: Date? = nil
        var body: some View {
            VStack {
                DateSelectionButton(
                    placeholder: "日付を選択",
                    selection: $selectedDate
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
