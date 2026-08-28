import 'package:flutter_riverpod/flutter_riverpod.dart';
class UserProfile {
  final String name;
  final String email;
  final String avatarInitial;

  const UserProfile({
    required this.name,
    required this.email,
    required this.avatarInitial,
  });
}
final userProfileProvider = Provider<UserProfile>((ref) {
  return const UserProfile(
    name: 'Nathan Randriamahefa',
    email: 'nathan.demo@example.com',
    avatarInitial: 'N',
  );
});
