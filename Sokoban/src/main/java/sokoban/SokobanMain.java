package sokoban;

import com.codingame.gameengine.runner.SoloGameRunner;

public class SokobanMain {
    public static void main(String[] args) {
        
        if (args.length != 2) {
            System.err.println("Usage: java --add-opens java.base/java.lang=ALL-UNNAMED -server -Xms2048m -Xmx2048m sokoban.SokobanMain <testCase> <testCaseInput>");
            System.exit(1);
        }

        SoloGameRunner gameRunner = new SoloGameRunner();
        gameRunner.setAgent(Agent.class);
        gameRunner.setTestCase(args[0]);
        System.setProperty("sokoban.solution", args[1]);

        gameRunner.start();
    }
}
