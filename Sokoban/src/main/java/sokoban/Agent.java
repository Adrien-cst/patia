package sokoban;

import java.util.Scanner;

public class Agent {
    public static void main(String[] args) {
        String solution = System.getProperty("sokoban.solution");
        for (char c : solution.toCharArray()) System.out.println(c);
    }
}
