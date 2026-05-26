// // models/user_model.dart
// class UserModel {
//   final String id;
//   final String email;
//   final String role; // 'customer' or 'seller'
//   final String? fcmToken; // 👈 Add this
//   final DateTime updatedAt;
  
//   // Add FCM token update method
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'role': role,
//       'fcmToken': fcmToken,
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }