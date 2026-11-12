String realtimeAction(List<String> events) {
  for (final event in events) {
    if (event.endsWith('.create')) return 'create';
    if (event.endsWith('.update')) return 'update';
    if (event.endsWith('.delete')) return 'delete';
  }
  return '';
}
