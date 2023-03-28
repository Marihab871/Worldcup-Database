#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE TABLE teams,games"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
    do
    if [[ $YEAR != year ]]
    then
      OUTPUT="$($PSQL "SELECT name FROM teams where name='$WINNER'")"
      if [[ -z $OUTPUT ]]
      then
        $PSQL "INSERT INTO teams(name) VALUES('$WINNER')" 
      fi
     OUTPUT="$($PSQL "SELECT name FROM teams where name='$OPPONENT'")"
      if [[ -z $OUTPUT ]]
      then
        $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')" 
      fi
    fi
  done
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
    do
        WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
        OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
        if [[ $YEAR != year ]]
        then
                  $PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) VALUES($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID)" 
        fi
    done
