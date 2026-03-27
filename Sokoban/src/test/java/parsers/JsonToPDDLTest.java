package parsers;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeAll;
import solver.PDDLSolver;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;


public class JsonToPDDLTest {

    private static PddlProblem pddlProblem;
    private static final String PROBLEM_PATH = "test1.json";
    private static final String DOMAIN_PATH = "domain.pddl";

    @BeforeAll
    public static void openJsonFile(){
        pddlProblem = JsonToPDDL.readProblem(PROBLEM_PATH);
    }

    @Test
    public void openAndParseJsonFile(){
        PddlProblem expectedProblem = new PddlProblem(
                Map.of("2", "Scoria - Level 1"),
                "  ####\n  #  #\n### .#\n#  * #\n# #@ #\n# $* #\n##   #\n #####",
                "true",
                "true"
        );

        assertEquals(expectedProblem, pddlProblem, "Test de lecture de fichier JSON");
    }

    @Test
    public void createPddlProblem(){
        String problem = JsonToPDDL.createProblem(pddlProblem);
        String expectedProblem = "(define (problem generated-problem)\n" +
                "(:domain sokoban)\n" +
                "\n" +
                "(:objects\n" +
                "c0_0 c1_0 \n" +
                "c0_1 c1_1 c3_1 c4_1 \n" +
                "c3_2 c4_2 \n" +
                "c1_3 c2_3 c3_3 c4_3 \n" +
                "c1_4 c3_4 c4_4 \n" +
                "c1_5 c2_5 c3_5 c4_5 \n" +
                "c2_6 c3_6 c4_6 \n" +
                "c0_7 - case\n" +
                "\n" +
                "U D L R - direction\n" +
                ")\n" +
                "\n" +
                "(:init\n" +
                "   (adjacent c0_0 c1_0 R)    (adjacent c1_0 c0_0 L)\n" +
                "   (adjacent c0_0 c0_1 D)   (adjacent c0_1 c0_0 U)\n" +
                "    (empty_case c0_0)\n" +
                "   (adjacent c1_0 c1_1 D)   (adjacent c1_1 c1_0 U)\n" +
                "    (empty_case c1_0)\n" +
                "   (adjacent c0_1 c1_1 R)    (adjacent c1_1 c0_1 L)\n" +
                "    (empty_case c0_1)\n" +
                "    (empty_case c1_1)\n" +
                "   (adjacent c3_1 c4_1 R)    (adjacent c4_1 c3_1 L)\n" +
                "   (adjacent c3_1 c3_2 D)   (adjacent c3_2 c3_1 U)\n" +
                "    (empty_case c3_1)\n" +
                "   (adjacent c4_1 c4_2 D)   (adjacent c4_2 c4_1 U)\n" +
                "    (empty_case c4_1)\n" +
                "   (adjacent c3_2 c4_2 R)    (adjacent c4_2 c3_2 L)\n" +
                "   (adjacent c3_2 c3_3 D)   (adjacent c3_3 c3_2 U)\n" +
                "    (safe_target c3_2)\n" +
                "    (empty_case c3_2)\n" +
                "   (adjacent c4_2 c4_3 D)   (adjacent c4_3 c4_2 U)\n" +
                "    (safe_target c4_2)\n" +
                "    (empty_case c4_2)\n" +
                "   (adjacent c1_3 c2_3 R)    (adjacent c2_3 c1_3 L)\n" +
                "   (adjacent c1_3 c1_4 D)   (adjacent c1_4 c1_3 U)\n" +
                "    (empty_case c1_3)\n" +
                "   (adjacent c2_3 c3_3 R)    (adjacent c3_3 c2_3 L)\n" +
                "    (safe_target c2_3)\n" +
                "    (empty_case c2_3)\n" +
                "   (adjacent c3_3 c4_3 R)    (adjacent c4_3 c3_3 L)\n" +
                "   (adjacent c3_3 c3_4 D)   (adjacent c3_4 c3_3 U)\n" +
                "    (safe_target c3_3)\n" +
                "    (box_at c3_3)\n" +
                "   (adjacent c4_3 c4_4 D)   (adjacent c4_4 c4_3 U)\n" +
                "    (safe_target c4_3)\n" +
                "    (empty_case c4_3)\n" +
                "   (adjacent c1_4 c1_5 D)   (adjacent c1_5 c1_4 U)\n" +
                "    (safe_target c1_4)\n" +
                "    (empty_case c1_4)\n" +
                "   (adjacent c3_4 c4_4 R)    (adjacent c4_4 c3_4 L)\n" +
                "   (adjacent c3_4 c3_5 D)   (adjacent c3_5 c3_4 U)\n" +
                "    (safe_target c3_4)\n" +
                "    (guard_at c3_4)\n" +
                "   (adjacent c4_4 c4_5 D)   (adjacent c4_5 c4_4 U)\n" +
                "    (safe_target c4_4)\n" +
                "    (empty_case c4_4)\n" +
                "   (adjacent c1_5 c2_5 R)    (adjacent c2_5 c1_5 L)\n" +
                "    (empty_case c1_5)\n" +
                "   (adjacent c2_5 c3_5 R)    (adjacent c3_5 c2_5 L)\n" +
                "   (adjacent c2_5 c2_6 D)   (adjacent c2_6 c2_5 U)\n" +
                "    (safe_target c2_5)\n" +
                "    (box_at c2_5)\n" +
                "   (adjacent c3_5 c4_5 R)    (adjacent c4_5 c3_5 L)\n" +
                "   (adjacent c3_5 c3_6 D)   (adjacent c3_6 c3_5 U)\n" +
                "    (safe_target c3_5)\n" +
                "    (box_at c3_5)\n" +
                "   (adjacent c4_5 c4_6 D)   (adjacent c4_6 c4_5 U)\n" +
                "    (safe_target c4_5)\n" +
                "    (empty_case c4_5)\n" +
                "   (adjacent c2_6 c3_6 R)    (adjacent c3_6 c2_6 L)\n" +
                "    (empty_case c2_6)\n" +
                "   (adjacent c3_6 c4_6 R)    (adjacent c4_6 c3_6 L)\n" +
                "    (safe_target c3_6)\n" +
                "    (empty_case c3_6)\n" +
                "    (empty_case c4_6)\n" +
                "    (empty_case c0_7)\n" +
                "\n" +
                ")\n" +
                "\n" +
                "(:goal (and\n" +
                "    (box_at c4_2)\n" +
                "    (box_at c3_3)\n" +
                "    (box_at c3_5)\n" +
                "))\n" +
                "\n" +
                ")";
        assertEquals(expectedProblem, problem, "Test de création de problème");
    }

    @Test
    public void getSolution(){
        String expectedSolution = "UDRDDLURUULLLDDRDRRUUUUULDRDDDDLLURDRUUULDRDDLLULUUR";
        String solution = PDDLSolver.solve(DOMAIN_PATH, JsonToPDDL.createProblem(pddlProblem));

        assertEquals(expectedSolution, solution, "Test de résolution de problème");
    }
}
