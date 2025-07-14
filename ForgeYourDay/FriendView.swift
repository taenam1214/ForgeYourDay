import SwiftUI

struct FriendView: View {
    let username: String
    @State private var newFriendUsername = ""
    @State private var friends: [String] = []
    @State private var addFriendMessage = ""
    @State private var friendRequests: [String] = []
    @State private var requestMessage = ""
    @State private var showUnfriendOverlay = false
    @State private var selectedFriend: String? = nil
    
    var body: some View {
        ZStack {
            Color.primaryLight.ignoresSafeArea()
            VStack(spacing: 0) {
                // Friend Requests Section
                if !friendRequests.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Friend Requests")
                            .font(.manrope(size: 20, weight: .bold))
                            .foregroundColor(.accent)
                            .padding(.top, 16)
                            .padding(.leading, 8)
                        ForEach(friendRequests, id: \.self) { requester in
                            HStack(spacing: 14) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(.secondary)
                                Text(requester)
                                    .font(.manrope(size: 17, weight: .semibold))
                                    .foregroundColor(.primaryDark)
                                Spacer()
                                Button(action: { acceptRequest(from: requester) }) {
                                    Text("Accept")
                                        .font(.body)
                                        .foregroundColor(.primaryLight)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 14)
                                        .background(Color.accent)
                                        .cornerRadius(8)
                                }
                                Button(action: { rejectRequest(from: requester) }) {
                                    Text("Reject")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 14)
                                        .background(Color.secondary.opacity(0.12))
                                        .cornerRadius(8)
                                }
                            }
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(Theme.cornerRadius)
                        }
                        if !requestMessage.isEmpty {
                            Text(requestMessage)
                                .foregroundColor(requestMessage.contains("now friends") ? .accent : .red)
                                .font(.caption)
                                .padding(.leading, 8)
                        }
                    }
                    .background(Color.primaryLight)
                    .cornerRadius(Theme.cornerRadius * 1.5)
                    .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
                // Add Friend Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Add Friend")
                        .font(.manrope(size: 20, weight: .bold))
                        .foregroundColor(.accent)
                        .padding(.top, 16)
                        .padding(.leading, 8)
                    HStack {
                        TextField("Add friend by username", text: $newFriendUsername)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(Theme.cornerRadius)
                            .font(.body)
                        Button(action: sendFriendRequest) {
                            Text("Add")
                                .font(.manrope(size: 16, weight: .bold))
                                .foregroundColor(.primaryLight)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 18)
                                .background(Color.accent)
                                .cornerRadius(Theme.cornerRadius)
                        }
                    }
                    .padding(.horizontal, 4)
                    if !addFriendMessage.isEmpty {
                        Text(addFriendMessage)
                            .foregroundColor(addFriendMessage.contains("sent") ? .accent : .red)
                            .font(.caption)
                            .padding(.leading, 8)
                    }
                }
                .background(Color.primaryLight)
                .cornerRadius(Theme.cornerRadius * 1.5)
                .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                Divider()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                // Friends List Section
                VStack(alignment: .leading, spacing: 0) {
                    Text("Your Friends")
                        .font(.manrope(size: 20, weight: .bold))
                        .foregroundColor(.accent)
                        .padding(.leading, 8)
                        .padding(.bottom, 8)
                    if friends.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "person.2.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundColor(.secondary)
                            Text("No friends yet. Add some!")
                                .foregroundColor(.secondary)
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                    } else {
                        ScrollView {
                            VStack(spacing: 14) {
                                ForEach(friends, id: \.self) { friend in
                                    Button(action: {
                                        selectedFriend = friend
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            showUnfriendOverlay = true
                                        }
                                    }) {
                                        HStack(spacing: 14) {
                                            Image(systemName: "person.crop.circle")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.secondary)
                                            Text(friend)
                                                .font(.manrope(size: 17, weight: .semibold))
                                                .foregroundColor(.primaryDark)
                                            Spacer()
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(Theme.cornerRadius * 1.2)
                                        .shadow(color: Color.black.opacity(0.04), radius: 2, y: 1)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 4)
                            .padding(.top, 8)
                        }
                    }
                }
                .background(Color.primaryLight.opacity(0.85))
                .cornerRadius(Theme.cornerRadius * 1.5)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                Spacer()
            }
            .navigationTitle("Friends")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadAll)
            // Unfriend Overlay
            .overlay(
                Group {
                    if showUnfriendOverlay, let friend = selectedFriend {
                        Color.black.opacity(0.25)
                            .ignoresSafeArea()
                            .transition(.opacity)
                        VStack(spacing: 20) {
                            Text("Unfriend \(friend)?")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryDark)
                                .padding(.top, 16)
                            HStack(spacing: 18) {
                                Button(action: {
                                    unfriend(friend)
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        showUnfriendOverlay = false
                                    }
                                }) {
                                    Text("Unfriend")
                                        .font(.manrope(size: 16, weight: .bold))
                                        .frame(minWidth: 100)
                                        .padding(.vertical, 12)
                                        .background(Color.accent)
                                        .foregroundColor(.primaryLight)
                                        .cornerRadius(Theme.cornerRadius)
                                }
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        showUnfriendOverlay = false
                                    }
                                }) {
                                    Text("Cancel")
                                        .font(.manrope(size: 16, weight: .regular))
                                        .frame(minWidth: 100)
                                        .padding(.vertical, 12)
                                        .background(Color.secondary.opacity(0.12))
                                        .foregroundColor(.secondary)
                                        .cornerRadius(Theme.cornerRadius)
                                }
                            }
                            .padding(.bottom, 16)
                        }
                        .frame(maxWidth: 320)
                        .background(Color.primaryLight)
                        .cornerRadius(Theme.cornerRadius * 2)
                        .shadow(radius: 16, y: 4)
                        .padding(.horizontal, 32)
                        .opacity(showUnfriendOverlay ? 1 : 0)
                        .scaleEffect(showUnfriendOverlay ? 1 : 0.95)
                        .animation(.easeInOut(duration: 0.25), value: showUnfriendOverlay)
                    }
                }
            )
        }
    }
    
    private func loadAll() {
        loadFriends()
        loadRequests()
    }
    
    private func loadFriends() {
        let defaults = UserDefaults.standard
        let key = "friends_\(username)"
        friends = defaults.stringArray(forKey: key) ?? []
    }

    private func loadRequests() {
        let defaults = UserDefaults.standard
        let key = "friendRequests_\(username)"
        friendRequests = defaults.stringArray(forKey: key) ?? []
    }

    private func sendFriendRequest() {
        let trimmed = newFriendUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            addFriendMessage = "Please enter a username."
            return
        }
        if trimmed == username {
            addFriendMessage = "You can't add yourself."
            return
        }
        let defaults = UserDefaults.standard
        let registered = defaults.stringArray(forKey: "registeredUsernames") ?? ["Kimia", "Taenam", "Zay"]
        guard registered.contains(trimmed) else {
            addFriendMessage = "User not found."
            return
        }
        // Check if already friends
        let myFriendsKey = "friends_\(username)"
        let myFriends = defaults.stringArray(forKey: myFriendsKey) ?? []
        if myFriends.contains(trimmed) {
            addFriendMessage = "Already friends."
            return
        }
        // Check if already requested
        let theirRequestsKey = "friendRequests_\(trimmed)"
        var theirRequests = defaults.stringArray(forKey: theirRequestsKey) ?? []
        if theirRequests.contains(username) {
            addFriendMessage = "Request already sent."
            return
        }
        theirRequests.append(username)
        defaults.setValue(theirRequests, forKey: theirRequestsKey)
        addFriendMessage = "Friend request sent!"
        newFriendUsername = ""
    }

    private func acceptRequest(from requester: String) {
        let defaults = UserDefaults.standard
        // Add each other as friends
        let myFriendsKey = "friends_\(username)"
        var myFriends = defaults.stringArray(forKey: myFriendsKey) ?? []
        if !myFriends.contains(requester) {
            myFriends.append(requester)
            defaults.setValue(myFriends, forKey: myFriendsKey)
        }
        let theirFriendsKey = "friends_\(requester)"
        var theirFriends = defaults.stringArray(forKey: theirFriendsKey) ?? []
        if !theirFriends.contains(username) {
            theirFriends.append(username)
            defaults.setValue(theirFriends, forKey: theirFriendsKey)
        }
        // Remove request
        let myRequestsKey = "friendRequests_\(username)"
        var myRequests = defaults.stringArray(forKey: myRequestsKey) ?? []
        myRequests.removeAll { $0 == requester }
        defaults.setValue(myRequests, forKey: myRequestsKey)
        friendRequests = myRequests
        loadFriends()
        requestMessage = "You are now friends with \(requester)!"
    }

    private func rejectRequest(from requester: String) {
        let defaults = UserDefaults.standard
        let myRequestsKey = "friendRequests_\(username)"
        var myRequests = defaults.stringArray(forKey: myRequestsKey) ?? []
        myRequests.removeAll { $0 == requester }
        defaults.setValue(myRequests, forKey: myRequestsKey)
        friendRequests = myRequests
        requestMessage = "Request rejected."
    }

    private func unfriend(_ friend: String) {
        let defaults = UserDefaults.standard
        // Remove friend from my list
        let myFriendsKey = "friends_\(username)"
        var myFriends = defaults.stringArray(forKey: myFriendsKey) ?? []
        myFriends.removeAll { $0 == friend }
        defaults.setValue(myFriends, forKey: myFriendsKey)
        friends = myFriends
        // Remove myself from their list
        let theirFriendsKey = "friends_\(friend)"
        var theirFriends = defaults.stringArray(forKey: theirFriendsKey) ?? []
        theirFriends.removeAll { $0 == username }
        defaults.setValue(theirFriends, forKey: theirFriendsKey)
    }
} 