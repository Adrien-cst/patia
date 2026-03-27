package parsers;

import java.util.Map;
import java.util.Objects;

public class PddlProblem {
    public Map<String, String> title;
    public String testIn;
    public String isTest;
    public String isValidator;

    public PddlProblem(){}

    public PddlProblem(Map<String, String> title, String testIn, String isTest, String isValidator) {
        this.title = title;
        this.testIn = testIn;
        this.isTest = isTest;
        this.isValidator = isValidator;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        PddlProblem problem = (PddlProblem) o;
        return Objects.equals(title, problem.title) && Objects.equals(testIn, problem.testIn) && Objects.equals(isTest, problem.isTest) && Objects.equals(isValidator, problem.isValidator);
    }

    @Override
    public int hashCode() {
        return Objects.hash(title, testIn, isTest, isValidator);
    }
}
