package parsers;

import com.google.gson.Gson;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class JsonToPDDL {

    private File file;

    public JsonToPDDL(String file) {
        this.file = new File(file);
    }

    public static PddlProblem readProblem(String filePath) {

        Gson gson = new Gson();

        try (FileReader reader = new FileReader(filePath)) {

            PddlProblem problem = gson.fromJson(reader, PddlProblem.class);
            return problem;

        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public static String createProblem(PddlProblem pddlProblem) {
        String[] rows = pddlProblem.testIn.split("\n");

        StringBuilder objects = new StringBuilder();
        StringBuilder init = new StringBuilder();
        StringBuilder goal = new StringBuilder();


        // On parcourt la grille ligne par ligne (y) et colonne par colonne (x)
        for (int y = 0; y < rows.length; y++) {
            objects.append("\n");
            String row = rows[y];
            for (int x = 0; x < row.length(); x++) {
                char cell = row.charAt(x);
                String cellName = "c" + x + "_" + y;

                if (cell == '#') {
                    continue;
                }

                if(x < row.length() - 1 && row.charAt(x + 1) != '#'){
                    String neighbourName = "c" + (x+1) + "_" + y;
                    init.append("   (adjacent ").append(cellName).append(" ").append(neighbourName).append(" R) ");
                    init.append("   (adjacent ").append(neighbourName).append(" ").append(cellName).append(" L)");
                    init.append("\n");
                }

                if (y < rows.length - 1 && x < rows[y + 1].length() && rows[y + 1].charAt(x) != '#') {
                    String neighbourName = "c" + x + "_" + (y+1);
                    init.append("   (adjacent ").append(cellName).append(" ").append(neighbourName).append(" D)");
                    init.append("   (adjacent ").append(neighbourName).append(" ").append(cellName).append(" U)");
                    init.append("\n");
                }

                objects.append(cellName).append(" ");

                boolean isGoal = (cell == '.' || cell == '*' || cell == '+');

                boolean wallU = isWall(rows, x, y - 1);
                boolean wallD = isWall(rows, x, y + 1);
                boolean wallL = isWall(rows, x - 1, y);
                boolean wallR = isWall(rows, x + 1, y);

                boolean isCorner = (wallU || wallD) && (wallL || wallR);

                if (!isCorner || isGoal) {
                    init.append("    (safe_target ").append(cellName).append(")\n");
                }

                // Analyse du contenu de la case
                switch (cell) {
                    case ' ': // Case vide normale
                        init.append("    (empty_case ").append(cellName).append(")\n");
                        break;

                    case '@': // Gardien
                        init.append("    (guard_at ").append(cellName).append(")\n");
                        break;

                    case '$': // Caisse
                        init.append("    (box_at ").append(cellName).append(")\n");
                        break;

                    case '.': // Cible vide
                        init.append("    (empty_case ").append(cellName).append(")\n");
                        goal.append("    (box_at ").append(cellName).append(")\n");
                        break;

                    case '*': // Caisse sur une cible (les "caisses noircies")
                        init.append("    (box_at ").append(cellName).append(")\n");
                        goal.append("    (box_at ").append(cellName).append(")\n");
                        break;

                    case '+': // Gardien sur une cible (plus rare, mais ça existe !)
                        init.append("    (guard_at ").append(cellName).append(")\n");
                        goal.append("    (box_at ").append(cellName).append(")\n");
                        break;
                }
            }
        }

        return "(define (problem generated-problem)\n" +
                "(:domain sokoban)\n\n" +
                "(:objects" +
                objects +
                "- case\n" +
                "\n" +
                "U D L R - direction\n" +
                ")\n\n" +
                "(:init\n" +
                init +
                "\n)\n" +
                "\n" +
                "(:goal (and\n" +
                goal + "))\n" +
                "\n" +
                ")";
    }

    // Permet de vérifier si une case est un mur, en gérant les bords de la carte
    private static boolean isWall(String[] rows, int x, int y) {
        // Si on sort de la grille, c'est considéré comme un mur
        if (y < 0 || y >= rows.length) return true;
        if (x < 0 || x >= rows[y].length()) return true;

        // Sinon, on lit le caractère
        return rows[y].charAt(x) == '#';
    }
}