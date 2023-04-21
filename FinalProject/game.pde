/**
 * Manages game state and instantiates levels, and players.
 * Also tracks the timer for the player's current run.
 */

 class Game {
    int startTime, stopTime;
    boolean running;  
    // defualt construtor, sets the time to 0 
    Game() {
        startTime = 0;
        stopTime = 0;
        running = false;
    }
    
    // starts the time
    void start() {
        startTime = millis();
        running = true;
    }
    // stops the time
    void stop() {
        stopTime = millis();
        running = false;
    }

    // gets the current ellapsed time
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

    // calculates seconds
    int second() {
      return (getElapsedTime() / 1000) % 60;
    }

    // calculates minutes 
    int minute() {
      return (getElapsedTime() / (1000*60)) % 60;
    }
  
 }