/**
 * Manages game state and instantiates levels, and players.
 * Also tracks the timer for the player's current run.
 */

 class Game {
    int startTime, stopTime;
    boolean running;  
    Game() {
        startTime = 0;
        stopTime = 0;
        running = false;
    }
    
    void start() {
        startTime = millis();
        running = true;
    }
    void stop() {
        stopTime = millis();
        running = false;
    }
    int getElapsedTime() {
        int elapsed;
        if (running) {
             elapsed = (millis() - startTime);
        }
        else {
            elapsed = (stopTime - startTime);
        }
        return elapsed;
    }
    int second() {
      return (getElapsedTime() / 1000) % 60;
    }
    int minute() {
      return (getElapsedTime() / (1000*60)) % 60;
    }
    int hour() {
      return (getElapsedTime() / (1000*60*60)) % 24;
    }
 }