#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=game --tuples-only -c"

RANDOM_NUMBER=$(( RANDOM%1001 ))

echo "Enter your username:"
read INPUT_NAME

USERNAME=$(echo $($PSQL "SELECT username from users WHERE username='$INPUT_NAME'") | tr -d " ")

if [[ -z $USERNAME ]]
then
  echo "Welcome, $INPUT_NAME! It looks like this is your first time here."
  INSERT_INPUT_NAME=$(echo $($PSQL "INSERT INTO users(username) VALUES('$INPUT_NAME')"))
  USER_ID=$(echo $($PSQL "SELECT user_id from users WHERE username='$INPUT_NAME'") | tr -d " ")
else
  USER_ID=$(echo $($PSQL "SELECT user_id from users WHERE username='$INPUT_NAME'") | tr -d " ")
  GAME_PLAYED=$(echo $($PSQL "SELECT COUNT(*) from games WHERE user_id='$USER_ID'") | tr -d " ")
  BEST_GAME=$(echo $($PSQL "SELECT MIN(number_of_guesses) from games WHERE user_id='$USER_ID'") | tr -d " ")
  echo "Welcome back, $USERNAME! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read INPUT_NUMBER
#USER_ID=$(echo $($PSQL "SELECT user_id from users WHERE username='$INPUT_NAME'") | tr -d " ")
#UPDATE_GAMES=$(echo $($PSQL "INSERT INTO games(secret_number,user_id,number_of_guesses) VALUES($RANDOM_NUMBER,$USER_ID,1)") | tr -d ' ')

I=1
while [ $RANDOM_NUMBER != $INPUT_NUMBER ]
do
    if [[ $INPUT_NUMBER =~ ^[0-9]+$ ]]
    then
      if [[ $INPUT_NUMBER > $RANDOM_NUMBER ]]
      then echo "It's lower than that, guess again:"
      read INPUT_NUMBER
      #UPDATE_GAMES_1=$(echo $($PSQL "INSERT INTO games(secret_number,user_id,number_of_guesses) VALUES($RANDOM_NUMBER,$USER_ID,1)") | tr -d ' ')
      else
        echo "It's higher than that, guess again:"
        read INPUT_NUMBER
        #UPDATE_GAMES_2=$(echo $($PSQL "INSERT INTO games(secret_number,user_id,number_of_guesses) VALUES($RANDOM_NUMBER,$USER_ID,1)") | tr -d ' ')
      fi
    else
      echo "That is not an integer, guess again:"
      read INPUT_NUMBER
    fi
    (( I++ ))
done


NUMBER_OF_GUESSES=$($PSQL "INSERT INTO games(secret_number,user_id,number_of_guesses) VALUES($RANDOM_NUMBER,$USER_ID,$I)")
echo "You guessed it in $I tries. The secret number was $RANDOM_NUMBER. Nice job!"