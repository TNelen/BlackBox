class Timer {

  Stopwatch stopwatch = new Stopwatch()..start();
  int duration;



  Timer(int duration){
    ///duration in seconds
    this.duration = duration;
  }

  Stopwatch getTimer(){
    return stopwatch;
  }



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

  int showTimeLeft(){
    return duration-(stopwatch.elapsedMicroseconds/1000000).round();
  }

  int elapsedSeconds(){
    return (stopwatch.elapsedMicroseconds/1000000).round();
  }
  int elapsedMinutes(){
    return (stopwatch.elapsedMicroseconds/60000000).round();
  }
}