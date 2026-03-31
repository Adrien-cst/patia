import argparse
import time
from collections import defaultdict
from random import choice
import matplotlib.pyplot as plt
import multiprocessing
import sys
import os

# Ajoute le répertoire du script au chemin pour permettre les importations
# depuis les autres fichiers du projet (npuzzle, node, etc.).
sys.path.append(os.path.abspath(os.path.dirname(__file__)))

try:
    import npuzzle as np
    from node import Node
    from solve_npuzzle import (
        solve_bfs, solve_dfs, solve_astar, solve_iddfs,
        BFS, DFS, ASTAR, IDDFS
    )
except ImportError as e:
    print(f"Erreur d'importation : {e}")
    print("Assurez-vous que les fichiers npuzzle.py, node.py et solve_npuzzle.py se trouvent dans le même répertoire que ce script.")
    sys.exit(1)


def generate_puzzle(dimension: int, depth: int) -> np.State:
    """
    Génère un puzzle en utilisant la fonction shuffle de npuzzle (comme generate_npuzzle.py).
    """
    puzzle = np.create_goal(dimension)
    if depth > 0:
        puzzle = np.shuffle(puzzle)
        for _ in range(0, depth - 1):
            puzzle = np.shuffle(puzzle)
    return puzzle

def solver_wrapper(solver_func, puzzle_state, solver_name, iddfs_max_depth, result_queue):
    """
    Wrapper pour exécuter une fonction de résolution dans un processus séparé.
    """
    start_time = time.perf_counter()
    root = Node(state=puzzle_state, move=None)
    
    # Appelle les solveurs en respectant leur signature d'origine
    if solver_name == IDDFS:
        solution = solver_func(root, iddfs_max_depth)
    else:
        solution = solver_func([root])

    duration = time.perf_counter() - start_time
    
    # Évite un temps de 0.0s qui "casse" l'affichage logarithmique du graphique
    duration = max(duration, 1e-5)
    result_queue.put((duration, solution is not None))


def main():
    parser = argparse.ArgumentParser(description='Benchmark N-Puzzle solvers.')
    parser.add_argument('-s', '--size', type=int, default=3, help='Taille du puzzle (ex: 3 pour un 3x3)')
    parser.add_argument('-n', '--num_puzzles', type=int, default=3, help='Nombre de puzzles à tester par profondeur')
    parser.add_argument('--min_depth', type=int, default=2, help='Profondeur de mélange minimale')
    parser.add_argument('--max_depth', type=int, default=18, help='Profondeur de mélange maximale')
    parser.add_argument('--timeout', type=int, default=5, help='Temps maximum (secondes) par résolution')
    parser.add_argument('--iddfs_max_depth', type=int, default=35, help='Profondeur de recherche maximale pour IDDFS')

    args = parser.parse_args()

    solvers = {
        BFS: solve_bfs,
        DFS: solve_dfs,
        ASTAR: solve_astar,
        IDDFS: solve_iddfs
    }

    results = defaultdict(lambda: defaultdict(list))

    print(f"Lancement du benchmark pour des puzzles {args.size}x{args.size}...")
    print(f"Profondeurs de {args.min_depth} à {args.max_depth}, {args.num_puzzles} puzzles par profondeur.")
    print(f"Timeout de {args.timeout} secondes par essai.\n")

    for depth in range(args.min_depth, args.max_depth + 1):
        print(f"--- Test des puzzles de profondeur {depth} ---")
        for i in range(args.num_puzzles):
            puzzle = generate_puzzle(args.size, depth)
            print(f"  Puzzle {i + 1}/{args.num_puzzles} (profondeur {depth})")

            for name, solver in solvers.items():
                result_queue = multiprocessing.Queue()
                process = multiprocessing.Process(target=solver_wrapper, args=(solver, puzzle, name, args.iddfs_max_depth, result_queue))
                
                process.start()
                process.join(timeout=args.timeout)

                if process.is_alive():
                    process.terminate()
                    process.join()
                    print(f"    -> {name}: TIMEOUT")
                    results[name][depth].append((args.timeout, False))
                else:
                    try:
                        duration, solved = result_queue.get_nowait()
                        if solved:
                            print(f"    -> {name}: Résolu en {duration:.4f}s")
                            results[name][depth].append((duration, True))
                        else:
                            print(f"    -> {name}: Terminé mais PAS DE SOLUTION TROUVÉE (temps: {duration:.4f}s)")
                            results[name][depth].append((args.timeout, False))
                    except multiprocessing.queues.Empty:
                        print(f"    -> {name}: ERREUR - Processus terminé sans résultat.")
                        results[name][depth].append((args.timeout, False))

    print("\n--- Génération du graphique ---")
    plt.figure(figsize=(12, 8))

    for algo_name, data in results.items():
        if not data:
            continue

        depths = [d for d in sorted(data.keys()) if len(data[d]) > 0]
        if not depths:
            continue

        # Calcul de la moyenne en incluant les timeouts
        avg_times = [sum(t for t, solved in data[d]) / len(data[d]) for d in depths]

        line = plt.plot(depths, avg_times, marker='o', linestyle='-', linewidth=2, markersize=6, label=algo_name)[0]
        
        # Marquer d'une croix ('X') les points où il y a eu au moins un échec/timeout
        for d, avg_t in zip(depths, avg_times):
            has_failure = any(not solved for t, solved in data[d])
            if has_failure:
                plt.plot(d, avg_t, marker='X', color=line.get_color(), markersize=10, linestyle='None')

    plt.axhline(y=args.timeout, color='red', linestyle='--', linewidth=2, label='Limite de Timeout')
    plt.plot([], [], color='black', marker='X', linestyle='None', markersize=10, label='Échec / Timeout inclus')
    plt.title(f'Temps de résolution moyen vs. Profondeur du Puzzle ({args.size}x{args.size})')
    plt.xlabel('Profondeur de génération du puzzle')
    plt.ylabel(f'Temps de résolution moyen (s) - Timeout: {args.timeout}s')
    plt.yscale('log')
    plt.legend()
    plt.grid(True, which="both", ls="--")

    ax = plt.gca()
    ax.xaxis.set_major_locator(plt.MaxNLocator(integer=True))

    filename = f'benchmark_{args.size}x{args.size}_depth_time.png'
    plt.savefig(filename)
    print(f"Graphique sauvegardé : {filename}")
    plt.show()


if __name__ == '__main__':
    # Nécessaire pour la compatibilité de multiprocessing avec certains OS (Windows, macOS)
    multiprocessing.freeze_support()
    main()