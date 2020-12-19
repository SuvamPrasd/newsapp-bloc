import 'dart:async';

enum CounterAction { INCREMENT, DECREMENT, RESET }

class CounterBloc {
  int counter;

  //state stream controller pipe
  final _counterStreamController = StreamController<int>();
  StreamSink<int> get _counterSink => _counterStreamController.sink;
  Stream<int> get counterStream => _counterStreamController.stream;

  //event stream controller pipe
  final _eventStreamController = StreamController<CounterAction>();
  StreamSink<CounterAction> get eventSink => _eventStreamController.sink;
  Stream<CounterAction> get _eventStream => _eventStreamController.stream;

  CounterBloc() {
    counter = 0;
    _eventStream.listen((event) {
      if (event == CounterAction.INCREMENT)
        counter++;
      else if (event == CounterAction.DECREMENT) {
        if (counter != 0) {
          counter--;
        }
      } else if (event == CounterAction.RESET) counter = 0;
    });

    _counterSink.add(counter);
  }

  //close the streamcontroller(required)
  void dispose() {
    _counterStreamController.close();
    _eventStreamController.close();
  }
}
