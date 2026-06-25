#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# ====================

echo $($PSQL "TRUNCATE teams,games")


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # first loop through "winner" teams:
  # if not label on csv
  if [[ $WINNER != winner ]]
  then
    # get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert team name
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")

    fi

  fi

  # next loop through "opponent" teams:
  # if not label on csv
  if [[ $OPPONENT != opponent ]]
  then
    # get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert team name
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")

    fi

  fi

done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # skip the labels
  if [[ $YEAR != year ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")

    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

    # insert game
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', '$WINNER_ID', '$OPPONENT_ID', $WINNER_GOALS, $OPPONENT_GOALS);")

  fi
  
done 
