
from npuzzle import (Solution,
                     State,
                     Move,
                     UP, 
                     DOWN, 
                     LEFT, 
                     RIGHT,
                     create_goal,
                     get_children,
                     is_goal,
                     is_solution,
                     load_puzzle,
                     to_string)
from node import Node
from typing import Literal, List
import argparse
import math
import time

BFS = 'bfs'
DFS = 'dfs'
ASTAR = 'astar'
IDDFS = 'iddfs'

def solve_bfs(open : List[Node]) -> Solution:
    '''Solve the puzzle using the BFS algorithm'''
    current = open.pop(0)
    dimension = int(math.sqrt(len(current.get_state())))
    goal = create_goal(dimension)
    visited_set = []

    while current and not is_goal(current.state, goal) :
        if (current.get_state(),current.move) in visited_set:
            current = open.pop(0)
            continue

        visited_set.append((current.get_state(),current.move))

        children = get_children(current.get_state(), [UP, DOWN, LEFT, RIGHT], dimension)
        for tuple in children:
            open.append(Node(tuple[0], tuple[1], current.cost + 1, current.heuristic + 1, current))

        current = open.pop(0)

    return current.get_path()

def solve_dfs(open : List[Node]) -> Solution:
    '''Solve the puzzle using the DFS algorithm'''
    current = open.pop(0)
    dimension = int(math.sqrt(len(current.get_state())))
    goal = create_goal(dimension)
    visited_set = []

    while current and not is_goal(current.state, goal):
        if (current.get_state(), current.move) in visited_set:
            current = open.pop(0)
            continue

        visited_set.append((current.get_state(), current.move))

        children = get_children(current.get_state(), [UP, DOWN, LEFT, RIGHT], dimension)
        for tuple in children:
            open.insert(0, Node(tuple[0], tuple[1], current.cost + 1, current.heuristic + 1, current))

        current = open.pop(0)

    return current.get_path()


def find_best_state(open_dict: dict, goal_state: State) -> tuple:
    ''' Trying to find the path with the lowest score '''
    best_f = float('inf')
    best_state = None

    for state, node in open_dict.items():
        g = len(node.get_path())  # Cost of followed path
        h = heuristic(state, goal_state)  # Estimated cost
        f = g + h

        if f < best_f:
            best_f = f
            best_state = state

    return best_state

def solve_astar(open_list: List[Node]) -> Solution:
    '''Solve the puzzle using the formal A* algorithm'''

    dimension = int(math.sqrt(len(open_list[0].get_state())))
    goal_state = create_goal(dimension)

    # CLOSED stores explored nodes
    closed_list = {}

    open_dict = {tuple(open_list[0].get_state()): open_list[0]}

    while open_dict:
        # Remove from OPEN and place on CLOSED a node n for which f is minimum.
        n_state = find_best_state(open_dict, goal_state)
        n = open_dict.pop(n_state)
        closed_list[n_state] = n

        # If n is a goal node, exit successfully
        if is_goal(n.get_state(), goal_state):
            return n.get_path()

        # Otherwise expand n, generating all its successors
        for child_state, move in get_children(n.get_state(), [UP, DOWN, LEFT, RIGHT], dimension):
            n_prime_state = tuple(child_state)
            g_n_prime = len(n.get_path()) + 1  # g(n) + cost(1)

            # If n' is not already on OPEN or CLOSED
            if n_prime_state not in open_dict and n_prime_state not in closed_list:
                n_prime = Node(child_state, move, parent=n)
                open_dict[n_prime_state] = n_prime

            # If n' is already on OPEN or CLOSED
            else:
                existing_node = open_dict.get(n_prime_state) or closed_list.get(n_prime_state)

                # Check if path yielding the lowest g(n')
                if g_n_prime < len(existing_node.get_path()):
                    # Direct its pointers (update parent and move)
                    existing_node.parent = n
                    existing_node.move = move

                    # If it was found on CLOSED, reopen it
                    if n_prime_state in closed_list:
                        open_dict[n_prime_state] = closed_list.pop(n_prime_state)

    # If OPEN is empty, exit with failure
    return None


def heuristic(current_state: State, goal_state: State) -> int:
    '''Calculate the Manhattan distance of the puzzle'''

    dimension = int(math.sqrt(len(current_state)))
    dist: int = 0

    for i in range(len(current_state)):
        val = current_state[i]
        if val == 0:
            continue

        x_goal = val % dimension
        y_goal = val // dimension

        x_reel = i % dimension
        y_reel = i // dimension

        distance_case = abs(x_reel - x_goal) + abs(y_reel - y_goal)
        dist += distance_case

    return dist


def depth_limited_search(node: Node, limit: int, goal_state: State, moves: List[Move], dimension: int) -> Solution | None:
    '''Perform a depth-limited search'''
    if is_goal(node.get_state(), goal_state):
        return node.get_path()

    if limit <= 0:
        return None

    children = get_children(node.get_state(), moves, dimension)
    for state, move in children:
        child_node = Node(state, move, node.cost + 1, 0, node)
        result = depth_limited_search(child_node, limit - 1, goal_state, moves, dimension)
        if result is not None:
            return result
    return None

def solve_iddfs(root: Node, max_depth: int) -> Solution:
    '''Solve the puzzle using the Iterative Deepening Depth-First Search algorithm'''
    dimension = int(math.sqrt(len(root.get_state())))
    goal_state = create_goal(dimension)
    moves = [UP, DOWN, LEFT, RIGHT]

    for depth in range(max_depth + 1):
        result = depth_limited_search(root, depth, goal_state, moves, dimension)
        if result is not None:
            return result
    return None

def main():
    parser = argparse.ArgumentParser(description='Load an n-puzzle and solve it.')
    parser.add_argument('filename', type=str, help='File name of the puzzle')
    parser.add_argument('-a', '--algo', type=str, choices=['bfs', 'dfs', 'astar', 'iddfs'], required=True, help='Algorithm to solve the puzzle')
    parser.add_argument('-v', '--verbose', action='store_true', help='Increase output verbosity')
    parser.add_argument('-d', '--max_depth', type=int, default=100, help='Maximum depth for IDDFS')
    
    args = parser.parse_args()
    
    puzzle = load_puzzle(args.filename)
    
    if args.verbose:
        print('Puzzle:\n')
        print(to_string(puzzle))
    
    if not is_goal(puzzle, create_goal(int(math.sqrt(len(puzzle))))):   
         
        root = Node(state = puzzle, move = None)
        open = [root]
        
        if args.algo == BFS:
            print('BFS\n')
            start_time = time.time()
            solution = solve_bfs(open)
            duration = time.time() - start_time
            if solution:
                print('Solution:', solution)
                print('Valid solution:', is_solution(puzzle, solution))
                print('Duration:', duration)
            else:
                print('No solution')
        elif args.algo == DFS:
            print('DFS\n')
            start_time = time.time()
            solution = solve_dfs(open)
            duration = time.time() - start_time
            if solution:
                print('Solution:', solution)
                print('Valid solution:', is_solution(puzzle, solution))
                print('Duration:', duration)
            else:
                print('No solution')
        elif args.algo == ASTAR:
            print('A*')
            start_time = time.time()
            solution = solve_astar(open)
            duration = time.time() - start_time
            if solution:
                print('Solution:', solution)
                print('Valid solution:', is_solution(puzzle, solution))
                print('Duration:', duration)
        elif args.algo == IDDFS:
            print('IDDFS')
            start_time = time.time()
            solution = solve_iddfs(root, args.max_depth)
            duration = time.time() - start_time
            if solution:
                print('Solution:', solution)
                print('Valid solution:', is_solution(puzzle, solution))
                print('Duration:', duration)        
            else:
                print('No solution')
    else:
        print('Puzzle is already solved')
    
if __name__ == '__main__':
    main()