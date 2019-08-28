class Timer {

  Stopwatch stopwatch = null;

  void createStopWatch(){
    var stopwatch = new Stopwatch()..start();
  }

  bool isRunning(){
    return stopwatch.isRunning;
  }

  void reset(){
    stopwatch.reset();
  }

  void stop(){
    stopwatch.stop();
  }

  int elapsedMilliseconds(){
    return stopwatch.elapsedMicroseconds;
  }

  int elapsedMicroseconds(){
    return stopwatch.elapsedMicroseconds;
  }

  int elapsedSeconds(){
    return (stopwatch.elapsedMicroseconds/1000000).round();
  }
  int elapsedMinutes(){
    return (stopwatch.elapsedMicroseconds/60000000).round();
  }
}