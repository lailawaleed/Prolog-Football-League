# ⚽ AI-Football-League Analyzer 🤖

This project is developed in **Prolog** as part of an Artificial Intelligence course assignment at **Cairo University**. It performs logical queries on football league data, helping analyze matches, players, goals, and team statistics using rule-based reasoning.

---

## 📂 Project Files

- `league_data.pl` – Contains predefined facts about:
  - Teams
  - Players
  - Matches
  - Goals

- `league_analysis.pl` – The main Prolog file implementing custom logic to solve assignment tasks.

- `AI - Assignment 1 [Spring 2025].pdf` – The official assignment brief from the course instructor.

---

## ✅ Implemented Tasks

Below is a list of all implemented queries with their expected use:

| Task Description | Sample Query |
|------------------|--------------|
| 1. List all players in a specific team | `?- players_in_team(barcelona, L).` |
| 2. Count teams from a given country | `?- team_count_by_country(spain, N).` |
| 3. Identify the team with the most titles | `?- most_successful_team(T).` |
| 4. Get all matches involving a specific team | `?- matches_of_team(barcelona, M).` |
| 5. Count the number of matches for a team | `?- num_matches_of_team(barcelona, N).` |
| 6. Find the top goal scorer in the league | `?- top_scorer(P).` |
| 7. Determine the most frequent player position in a team | `?- most_common_position_in_team(barcelona, Pos).` |
| 🔄 Bonus. Prevent unneeded backtracking in results | All predicates include cut operators (`!`) to optimize query results. |

---

## 🚀 How to Run the Program

1. **Preparation**
   - Place all files in the same directory:
     ```
     league_data.pl
     league_analysis.pl
     ```

2. **Execution in SWI-Prolog**
   Launch your terminal and run:
   ```prolog
   ?- consult('league_data').
   ?- consult('league_analysis').
