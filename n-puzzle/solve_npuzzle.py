
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


def solve_astar(open : List[Node], visited_set = []) -> Solution:
    '''Solve the puzzle using the A* algorithm'''
    if not open:
        return None

    current = open.pop(0)
    dimension = int(math.sqrt(len(current.get_state())))
    goal_state = create_goal(dimension)

    if is_goal(current.get_state(), goal_state):
        return current.get_path()

    visited_set.append(current)

    children = get_children(current.get_state(), [UP, DOWN, LEFT, RIGHT], dimension)
    for tuple in children:

        for opened_node_index in range(len(open)):
            if tuple[0] == open[opened_node_index].get_state() and current.cost + 1 < open[opened_node_index].cost:
                open[opened_node_index].cost = current.cost + 1
                open[opened_node_index].parent = current
                break

        for closed_node in visited_set:
            if tuple[0] == closed_node.get_state() and current.cost + 1 < closed_node.cost:
                open.append((closed_node.state, closed_node.move, current.cost + 1 , closed_node.heuristic, current))
                visited_set.remove(closed_node)
                break

        else:
            h = heuristic(current.get_state(), goal_state)
            g = current.cost + 1
            open.append(Node(tuple[0], tuple[1], g , h , current))

    open.sort(key=lambda node: node.heuristic)
    return solve_astar(open, visited_set)

def heuristic(current_state : State, goal_state : State) -> int:
    '''Calculate the Manhattan distance of the puzzle'''
    distance = 0
    dimension = int(math.sqrt(len(current_state)))

    for row in range(0, dimension):
        for column in range(0, dimension):
            val = current_state[row * dimension + column]
            if val != 0:  # Usually, we don't count the distance for the empty tile
                goal_index = goal_state.index(val)
                goal_row = goal_index // dimension
                goal_col = goal_index % dimension
                distance += abs(row - goal_row) + abs(column - goal_col)
    return distance


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