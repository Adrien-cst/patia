package parsers;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeAll;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;


public class JsonToPDDLTest {

    private static PddlProblem pddlProblem;
    private static final String FILE_PATH = "src/test/resources/test1.json";

    @BeforeAll
    public static void openJsonFile(){
        pddlProblem = JsonToPDDL.readProblem(FILE_PATH);
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
        System.out.println(problem);
    }
}
