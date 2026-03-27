package solver;

import fr.uga.pddl4j.parser.DefaultParsedProblem;
import fr.uga.pddl4j.parser.ErrorManager;
import fr.uga.pddl4j.parser.Message;
import fr.uga.pddl4j.parser.Parser;
import fr.uga.pddl4j.plan.Plan;
import fr.uga.pddl4j.planners.ProblemNotSupportedException;
import fr.uga.pddl4j.planners.statespace.FF;
import fr.uga.pddl4j.planners.statespace.HSP;
import fr.uga.pddl4j.problem.DefaultProblem;
import fr.uga.pddl4j.problem.Problem;
import fr.uga.pddl4j.problem.operator.Action;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class PDDLSolver {

    private static final String problemPath = "./p_generated.pddl";

    public static String solve(String domainPath, String problemName) {

        try {
            Path tempProblemPath = Path.of(problemPath);
            Files.writeString(tempProblemPath, problemName);
            System.out.printf("Fichier problème créé avec succès");

            final Parser parser = new Parser();

            String domainFullPath = PDDLSolver.class.getClassLoader().getResource(domainPath).getPath();
            final DefaultParsedProblem parsedProblem = parser.parse(domainFullPath, tempProblemPath.toString());

            final ErrorManager errorManager = parser.getErrorManager();

            if(!errorManager.isEmpty()){
                for (Message m : errorManager.getMessages()){
                    System.out.println(m.toString());
                }
            } else {
                System.out.print("\nparsing domain file \"" + domainPath + "\" done successfully");
                System.out.print("\nparsing problem file \"" + problemPath + "\" done successfully\n\n");
                // Print domain and the problem parsed
                System.out.println("================== SOLUTION ===================");

                final Problem problem = new DefaultProblem(parsedProblem);

                problem.instantiate();
                // Instantiate the planning problem
                HSP planner = new HSP();
                Plan plan = planner.solve(problem);

                if (plan != null) {
                    System.out.println("================== SOLUTION TROUVÉE ===================");
                    StringBuilder res = new StringBuilder();

                    for (Action a : plan.actions()) {
                        int[] instantiations = a.getInstantiations();
                        Character actionName = problem.getParsedProblem()
                                .getConstants()
                                .get(instantiations[instantiations.length - 1])
                                .toString().charAt(0);
                        res.append(Character.toUpperCase(actionName));
                    }
                    System.out.println(res);
                    return res.toString();
                } else {
                    System.out.println("================== AUCUNE SOLUTION ===================");
                    return ""; // Le niveau est impossible (ou deadlock)
                }
            }

        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (ProblemNotSupportedException e) {
            throw new RuntimeException(e);
        }
        return "";
    }

}
