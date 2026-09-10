class CustomDateUtils {
  static String formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    }

    if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    }

    if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} j';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
