package sokoban;

import com.codingame.gameengine.runner.SoloGameRunner;
import parsers.JsonToPDDL;
import parsers.PddlProblem;
import solver.PDDLSolver;

public class SokobanMain {
    public static void main(String[] args) {
        
        if (args.length != 1) {
            System.err.println("Usage: java --add-opens java.base/java.lang=ALL-UNNAMED -server -Xms2048m -Xmx2048m sokoban.SokobanMain <testCaseInput>");
            System.exit(1);
        }

        SoloGameRunner gameRunner = new SoloGameRunner();
        gameRunner.setAgent(Agent.class);
        gameRunner.setTestCase(args[0]);

        PddlProblem pddlProblem = JsonToPDDL.readProblem(args[0]);


        String solution = PDDLSolver.solve("domain.pddl", JsonToPDDL.createProblem(pddlProblem));

        System.setProperty("sokoban.solution", solution);

        gameRunner.start(4200);
    }
}
