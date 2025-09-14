import SwiftUI
import SwiftData

struct FortuneUserListView: View {
    @State private var isSheetPresented = false
    
    @Query(sort: [SortDescriptor(\UserProfile.name)]) private var users: [UserProfile]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationStack {
                List(users) { user in
                    // TODO: 占い結果詳細画面への遷移を実装する
                    NavigationLink(destination: Text("Detail View for \(user.name)")) {
                        HStack(spacing: 16) {
                            if let iconData = user.icon, let uiImage = UIImage(data: iconData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 44, height: 44)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 44, height: 44)
                                    .foregroundColor(Color(UIColor.placeholderText))
                            }
                            Text(user.name)
                                .font(.title3)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .navigationTitle("ともだちリスト")
                .sheet(isPresented: $isSheetPresented) {
                    FortuneProfileFormView(user: nil)
                }
            }
            
            Button(action: {
                isSheetPresented = true
            }) {
                Image(systemName: "plus")
                    .font(.title.weight(.semibold))
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .clipShape(Circle())
                    .shadow(radius: 2, x: 0, y: 4)
            }
            .padding()
        }
    }
}

#Preview("light") {
    FortuneUserListView()
            .modelContainer(SampleUserData.previewContainer)
            .preferredColorScheme(.light)

    
}

#Preview("dark") {
    FortuneUserListView()
            .modelContainer(SampleUserData.previewContainer)
            .preferredColorScheme(.dark)

    
}
