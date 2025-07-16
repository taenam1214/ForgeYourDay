# ForgeYourDay

ForgeYourDay is a productivity iOS app designed to help users build daily habits, stay accountable, and celebrate progress with friends. The app requires users to upload a photo as proof each time they complete a task, creating a trustworthy and motivating environment. With a social feed, robust friends system, and modern UI, ForgeYourDay turns productivity into a shared journey.

## Purpose
ForgeYourDay aims to:
- Encourage users to set and complete daily goals.
- Foster accountability by requiring photo proof for each completed task.
- Build a positive, supportive community through sharing, likes, and comments.
- Make habit-building fun and social, not just personal.

## Main Screens & Features

### Home Screen
- **Feed of Completed Tasks:** Shows posts from you and your friends, each with a photo, description, date, and like/comment counts.
- **Pull-to-Refresh & Refresh Button:** Easily update your feed to see the latest posts (for debugging or cleanup).
- **Trash Button:** Clear all your posts (for debugging or cleanup).
- **Relative Time Display:** Post dates update every minute to show how recent they are.
- **Automatic Cleanup:** Posts older than 24 hours are removed.
- **Like & Comment:** Like posts (persistent, user-specific) and leave comments with your username.

### Add Post Screen
- **Task List:** View and manage your daily tasks. Tasks reset every day, encouraging a fresh start.
- **Daily Goal Requirement:** Users are required to set at least 3 daily goals before starting their day.
- **Add Task:** Add new tasks if you want to make additions.
- **Complete Task:** When you finish a task, you must upload a photo and write a description as proof. Only then can you submit the task as completed.
- **Floating Add Button:** Easily add new tasks from anywhere on the screen.
- **Modern Empty State:** Placeholder message and icon when no tasks are set.

### Profile Screen
- **Profile Photo:** (Default icon, with option to upload in the future.)
- **Username:** Display and edit your username, with full data migration for all posts, friends, and requests.
- **Motivational Quote:** Rotating or static quote for encouragement (options to add in the future).
- **Tasks Completed Today:** Shows the real number of tasks you’ve completed today, updating automatically.
- **Edit Profile:** Change your username with migration of all related data.
- **Friends Button:** Opens the Friends screen.
- **Logout:** Custom animated confirmation overlay for logging out.

### Friends Screen
- **Add Friend:** Send friend requests by username. Requests are mutual—both must accept to become friends.
- **Friend Requests:** View and accept/reject incoming requests. Accepting adds both users to each other’s friends lists.
- **Friends List:** See your current friends. Unfriend with a smooth overlay UI.
- **Data Storage:** Friends and requests are stored in UserDefaults, and all lists update on username change.

## Key Functions
- **Photo Proof:** Every completed task requires a photo upload, ensuring authenticity and accountability.
- **Daily Reset:** All daily tasks reset every 24 hours, and users must set at least 3 new goals each day.
- **Social Feed:** Only you and your friends’ posts appear in your feed, making it a private, supportive space.
- **Likes & Comments:** Posts can be liked (by username) and commented on, with all data persistent and migrated on username change.
- **Friend System:** Add, accept, reject, and remove friends. Friend requests are mutual and managed in UserDefaults.
- **Username Migration:** Changing your username updates all related data everywhere—posts, comments, likes, friends, and requests.
- **Modern UI/UX:** Smooth transitions (highlight on this lol), overlays, and animations throughout the app for a delightful experience.

## Future Improvements
- **Streak Tracking:** Track how many consecutive days users complete all their daily tasks, motivating consistency.
- **Leaderboard:** Compete with friends on a leaderboard based on streaks and task completion.
- **Push Notifications:** Reminders to set daily goals and complete tasks.
- **Customizable Task Categories:** Organize tasks by category (e.g., health, work, personal growth).
- **Richer Profile Customization:** Add profile photos, bios, and more personalization options.
- **In-app Achievements:** Earn badges for milestones like streaks, number of tasks completed, or helping friends.
- **Analytics Dashboard:** Visualize your productivity trends over time.
- **Dark Mode:** Support for light and dark themes.

## Getting Started
1. Clone the repository:
   ```sh
   git clone https://github.com/taenam1214/ForgeYourDay.git
   ```
2. Open `ForgeYourDay.xcodeproj` in Xcode.
3. Build and run the app on your simulator or device.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
This project is for personal branding purposes. 