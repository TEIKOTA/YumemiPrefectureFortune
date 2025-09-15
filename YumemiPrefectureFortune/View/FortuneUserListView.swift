import SwiftUI
import SwiftData

struct FortuneUserListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var isSheetPresented = false
    
    @Query(sort: [SortDescriptor(\UserProfile.name)]) private var users: [UserProfile]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                
                List {
                    ForEach(users) { user in
                        NavigationLink(
                            destination: FortuneDetailView(viewModel: FortuneDetailViewModel(user: user))) {
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
                    // `.onDelete(perform:)` が IndexSet を自動的に渡してくれる
                    .onDelete(perform: deleteUsers)
                }
                .navigationTitle("ともだちリスト")
                .sheet(isPresented: $isSheetPresented) {
                    FortuneProfileFormView(user: nil)
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
    
    private func deleteUsers(at offsets: IndexSet) {
        for index in offsets {
            let userToDelete = users[index]
            modelContext.delete(userToDelete)
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
