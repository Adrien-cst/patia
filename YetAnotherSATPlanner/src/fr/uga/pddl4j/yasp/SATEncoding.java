package fr.uga.pddl4j.yasp;

import fr.uga.pddl4j.plan.Plan;
import fr.uga.pddl4j.plan.SequentialPlan;
import fr.uga.pddl4j.problem.Fluent;
import fr.uga.pddl4j.problem.Problem;
import fr.uga.pddl4j.problem.operator.Action;
import fr.uga.pddl4j.util.BitVector;

import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * This class implements a planning problem/domain encoding into DIMACS
 *
 * @author H. Fiorino
 * @version 0.1 - 30.03.2024
 */
public final class SATEncoding {
    /*
     * A SAT problem in dimacs format is a list of int list a.k.a clauses
     */
    private List<List<Integer>> initList = new ArrayList<List<Integer>>();

    /*
     * Goal
     */
    private List<Integer> goalList = new ArrayList<Integer>();

    /*
     * Actions
     */
    private List<List<Integer>> actionPreconditionList = new ArrayList<List<Integer>>();
    private List<List<Integer>> actionEffectList = new ArrayList<List<Integer>>();

    /*
     * State transistions
     */
    private HashMap<Integer, List<Integer>> addList = new HashMap<Integer, List<Integer>>();
    private HashMap<Integer, List<Integer>> delList = new HashMap<Integer, List<Integer>>();
    private List<List<Integer>> stateTransitionList = new ArrayList<List<Integer>>();

    /*
     * Action disjunctions
     */
    private List<List<Integer>> actionDisjunctionList = new ArrayList<List<Integer>>();

    /*
     * Current DIMACS encoding of the planning domain and problem for #steps steps
     * Contains the initial state, actions and action disjunction
     * Goal is no there!
     */
    public List<List<Integer>> currentDimacs = new ArrayList<List<Integer>>();

    /*
     * Current goal encoding
     */
    public List<Integer> currentGoal = new ArrayList<Integer>();

    /*
     * Current number of steps of the SAT encoding
     */
    private int steps;
    
    private int actionsSize;
    private final int nbFluents;

    public SATEncoding(Problem problem, int steps) {

        this.steps = steps;

        // Encoding of init
        // Each fact is a unit clause
        // Init state step is 1
        // We get the initial state from the planning problem
        // State is a bit vector where the ith bit at 1 corresponds to the ith fluent being true
        nbFluents = problem.getFluents().size();
        //System.out.println(" fluents = " + nbFluents );

        final int nb_actions = problem.getActions().size();

        final BitVector init = problem.getInitialState().getPositiveFluents();
        
        
        for (int i = 0; i < nbFluents; i++) {
            if (init.get(i)) initList.add(List.of(pair(i, 1)));
            else initList.add(List.of(-pair(i, 1)));
        }

        List<Action> actions = problem.getActions();


        actionsSize = actions.size();
        for (int j = 0; j < actionsSize; j++) {
            Action action = actions.get(j);

            List<Integer> preconditions = new ArrayList();
            BitVector preconditionPositiveFluents = action.getPrecondition().getPositiveFluents();
            BitVector preconditionNegativeFluents = action.getPrecondition().getNegativeFluents();

            BitVector effectPositiveFluents = action.getUnconditionalEffect().getPositiveFluents();
            BitVector effectNegativeFluents = action.getUnconditionalEffect().getNegativeFluents();
            List<Integer> effects = new ArrayList<>();


            for (int i = 0; i < nbFluents; i++) {
                if (preconditionPositiveFluents.get(i)) preconditions.add(i);
                if (preconditionNegativeFluents.get(i)) preconditions.add(-i);

                if (effectPositiveFluents.get(i)) {
                    effects.add(i);

                    addList.computeIfAbsent(i, k -> new ArrayList<>()).add(j + nbFluents);
                }
                if (effectNegativeFluents.get(i)) {
                    effects.add(-i);

                    delList.computeIfAbsent(i, k -> new ArrayList<>()).add(j + nbFluents);
                }
            }

            actionPreconditionList.add(preconditions);

            actionEffectList.add(effects);
            
            for (int i = j + 1; i < actionsSize; i++){
                actionDisjunctionList.add(List.of(i + nbFluents, j + nbFluents));
            }

        }

        BitVector goalPositiveFluents = problem.getGoal().getPositiveFluents();
        BitVector goalNegativeFluents = problem.getGoal().getNegativeFluents();

        for (int i = 0; i < nbFluents; i++) {
            if (goalPositiveFluents.get(i)) goalList.add(i);
            if (goalNegativeFluents.get(i)) goalList.add(-i);
        }


        // Makes DIMACS encoding from 1 to steps
        encode(1, steps);
    }
    
    /*
     * SAT encoding for next step
     */
    public void next() {
        this.steps++;
        encode(this.steps, this.steps);
    }

    public String toString(final List<Integer> clause, final Problem problem) {
        final int nb_fluents = problem.getFluents().size();
        List<Integer> dejavu = new ArrayList<Integer>();
        String t = "[";
        String u = "";
        int tmp = 1;
        int [] couple;
        int bitnum;
        int step;
        for (Integer x : clause) {
            if (x > 0) {
                couple = unpair(x);
                bitnum = couple[0];
                step = couple[1];
            } else {
                couple = unpair(- x);
                bitnum = - couple[0];
                step = couple[1];
            }
            t = t + "(" + bitnum + ", " + step + ")";
            t = (tmp == clause.size()) ? t + "]\n" : t + " + ";
            tmp++;
            final int b = Math.abs(bitnum);
            if (!dejavu.contains(b)) {
                dejavu.add(b);
                u = u + b + " >> ";
                if (nb_fluents >= b) {
                    Fluent fluent = problem.getFluents().get(b - 1);
                    u = u + problem.toString(fluent)  + "\n";
                } else {
                    u = u + problem.toShortString(problem.getActions().get(b - nb_fluents - 1)) + "\n";
                }
            }
        }
        return t + u;
    }

    public Plan extractPlan(final List<Integer> solution, final Problem problem) {
        Plan plan = new SequentialPlan();
        HashMap<Integer, Action> sequence = new HashMap<Integer, Action>();
        final int nb_fluents = problem.getFluents().size();
        int[] couple;
        int bitnum;
        int step;
        for (Integer x : solution) {
            if (x > 0) {
                couple = unpair(x);
                bitnum = couple[0];
            } else {
                couple = unpair(-x);
                bitnum = -couple[0];
            }
            step = couple[1];
            // This is a positive (asserted) action
            // Actions are encoded as: actionIndex + nbFluents (e.g., action 0 is nbFluents)
            if (bitnum >= nb_fluents) {
                final int actionIndex = bitnum - nb_fluents;
                // Only extract if it's a valid action (not a fluent)
                if (actionIndex >= 0 && actionIndex < problem.getActions().size()) {
                    final Action action = problem.getActions().get(actionIndex);
                    if (action != null) {
                        sequence.put(step, action);
                    }
                }
            }
        }
        // Sort steps in ascending order and build the plan
        List<Integer> sortedSteps = new ArrayList<>(sequence.keySet());
        sortedSteps.sort(Integer::compareTo);
        int index = 0;
        for (Integer s : sortedSteps) {
            plan.add(index++, sequence.get(s));
        }
        return plan;
    }

    // Cantor paring function generates unique numbers
    private static int pair(int num, int step) {
        return (int) (0.5 * (num + step) * (num + step + 1) + step);
    }

    private static int[] unpair(int z) {
        /*
        Cantor unpair function is the reverse of the pairing function. It takes a single input
        and returns the two corespoding values.
        */
        int t = (int) (Math.floor((Math.sqrt(8 * z + 1) - 1) / 2));
        int bitnum = t * (t + 3) / 2 - z;
        int step = z - t * (t + 1) / 2;
        return new int[]{bitnum, step}; //Returning an array containing the two numbers
    }

    private void encode(int from, int to) {
        this.currentDimacs.clear();
        
        if (from == 1) currentDimacs.addAll(initList);

        for (int i = from; i <= to; i++){
             encodeStep(i);
        }
        
        currentGoal = new ArrayList<>();
        for (Integer predicate : goalList) {
            currentGoal.add(pair(predicate, to));
        }

        System.out.println("Encoding : successfully done (" + (this.currentDimacs.size()
                + this.currentGoal.size()) + " clauses, " + to + " steps)");
    }
    
    private void encodeStep(int step) {
        // ACTIONS
        for (int i = 0; i < actionsSize; i++) {
            int pairedAction = pair(i + nbFluents, step);

            // Préconditions
            for (int prec : actionPreconditionList.get(i)) {
                int pairedPrec = pair(prec, step);

                currentDimacs.add(List.of(-pairedAction, pairedPrec));
            }

            // Effets positifs et négatifs
            for (int effect : actionEffectList.get(i)) {
                int pairedEffect;

                if (effect >= 0) pairedEffect = pair(effect, step + 1);
                else pairedEffect = -pair(-effect, step + 1);

                currentDimacs.add(List.of(-pairedAction, pairedEffect));
            }

        }

        // EXCLUSION MUTUELLE
        for (List<Integer> actionExclusionPair : actionDisjunctionList) {
            List<Integer> pairedList = new ArrayList<>();
                    
            for (int action : actionExclusionPair) {
                pairedList.add(-pair(action, step));
            }
            
            currentDimacs.add(pairedList);
        }
        
        // AXIOMES
        for (int i = 0; i < nbFluents; i++) {
            // Negative frame axiom: if a fluent is true and no deletion action happens, it stays true
            // (¬fluent_i(t) ∨ fluent_i(t+1) ∨ deletion_actions)
            List<Integer> axiom = new  ArrayList<>();
            axiom.add(-pair(i, step));
            axiom.add(pair(i, step+1));
            List<Integer> negativeEffects = delList.get(i);
            if(negativeEffects != null){
                for (Integer action : negativeEffects) {
                    axiom.add(pair(action, step));
                }
            }
            currentDimacs.add(axiom);


            // Positive frame axiom: if a fluent is false and no addition action happens, it stays false
            // (fluent_i(t) ∨ ¬fluent_i(t+1) ∨ addition_actions)
            axiom = new  ArrayList<>();
            axiom.add(pair(i, step));
            axiom.add(-pair(i, step+1));
            List<Integer> postiveEffects = addList.get(i);
            if(postiveEffects != null){
                for (Integer action : postiveEffects) {
                    axiom.add(pair(action, step));
                }
            }
            currentDimacs.add(axiom);

        }
        
        
        
    }

}
