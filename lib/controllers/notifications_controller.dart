import 'package:get/get.dart';
import 'package:resonate/models/notification.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  /// Fetch notifications from the backend
  /// TODO: Implement actual backend call to fetch user notifications
  /// This is a placeholder that fetches an empty list for now.
  /// Once the notification backend is implemented, replace this with:
  /// 
  /// Future<void> fetchNotifications() async {
  ///   try {
  ///     isLoading.value = true;
  ///     error.value = null;
  ///     final response = await apiService.getNotifications();
  ///     notifications.assignAll(response);
  ///   } on Exception catch (e) {
  ///     error.value = e.toString();
  ///   } finally {
  ///     isLoading.value = false;
  ///   }
  /// }
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      error.value = null;
      // TODO: Replace with actual backend call
      // For now, notifications list remains empty
      // Simulating a small delay to mimic backend call
      await Future.delayed(const Duration(milliseconds: 300));
      notifications.clear();
    } on Exception catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh notifications list
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  /// Mark notification as read (placeholder for future implementation)
  Future<void> markAsRead(NotificationModel notification) async {
    // TODO: Implement backend call to mark notification as read
  }

  /// Delete a notification
  Future<void> deleteNotification(NotificationModel notification) async {
    // TODO: Implement backend call to delete notification
    notifications.remove(notification);
  }
}
