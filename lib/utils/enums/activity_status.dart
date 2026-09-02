enum ActivityStatus {
  online('online'),
  dnd('dnd'),
  inRoom('inroom'),
  invisible('invisible'),
  offline('offline');

  const ActivityStatus(this.wire);
  final String wire;

  static const List<ActivityStatus> selectable = [online, dnd, invisible];

  bool get blocksCalls => this == dnd || this == inRoom;

  ActivityStatus get asSeenByOthers =>
      this == invisible ? ActivityStatus.offline : this;

  static ActivityStatus? fromWire(String? wire) {
    if (wire == null) return null;
    for (final status in ActivityStatus.values) {
      if (status.wire == wire) return status;
    }
    return null;
  }
}
