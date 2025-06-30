import SwiftUI

struct AddPostView: View {
    var body: some View {
        NavigationView {
            Text("Add a new post here.")
                .font(.title)
                .foregroundColor(.primaryDark)
                .padding(Theme.padding)
                .navigationTitle("Add Post")
                .background(Color.primaryLight.ignoresSafeArea())
        }
    }
}

#Preview {
    AddPostView()
} 