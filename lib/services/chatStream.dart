import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/models/message.dart' as chatMessage;
import 'dart:async';

class djangoStreams {
  djangoStreams();

  var streamController = StreamController.broadcast();
// the first subscription
//   streamController.stream.listen((event) {
//     print('first subscription: $event');
//   });
// // the second subscription
//   streamController.stream.listen((event) {
//     print('second subscription: ${event + event}');
//   });
// // push events
//   streamController.sink.add(1);
//   streamController.sink.add(100);

  Stream<List<chatMessage.Message>?> loadChatMessages = (() async* {
    List<chatMessage.Message>? _msgs =
        await Repository().getMessageByContact('1');
    // await Future<void>.delayed(Duration(milliseconds: 2));

    yield _msgs;
    // for (int i = 1; i <= 5; i++) {
    //   await Future<void>.delayed(Duration(milliseconds: 1));
    //   yield i;
    // }
  })();
}
