#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $WINNER != "winner" ]]
  then 
  #get winner id
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #if not found
    if [[ -z $TEAM_ID_WINNER ]]
    then 
      INSERT_RESULT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    #get new winner_id
      TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  #get opponent_id
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM_ID_OPPONENT ]]
    then
      INSERT_RESULT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
      #get new opponent_id
      TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #get game id
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")
    
  fi
done


