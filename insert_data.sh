#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE teams, games")"
echo "$($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")"
echo "$($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")"

cat "games.csv" | while IFS=',' read -r YEAR ROUND WINNER OPPONENT WGOALS OGOALS; do
if [[ $YEAR != "year" ]] 
then

if [[ -z "$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")" ]] 
then
echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
fi

if [[ -z "$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")" ]]
then 
echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
fi
 
WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"

OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

echo "$($PSQL "INSERT INTO games(year, round, opponent_id, winner_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $OPPONENT_ID, $WINNER_ID, $WGOALS, $OGOALS)")"

fi
done