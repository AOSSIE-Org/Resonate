import 'package:resonate/utils/enums/activity_status.dart';

// The result of trying to start a call
sealed class StartCallOutcome {
  const StartCallOutcome();
}

class StartCallStarted extends StartCallOutcome {
  const StartCallStarted();
}

class StartCallBlocked extends StartCallOutcome {
  const StartCallBlocked(this.status);

  final ActivityStatus status;
}

class StartCallFailed extends StartCallOutcome {
  const StartCallFailed(this.message);

  final String message;
}
