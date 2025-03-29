#! /bin/bash
echo -e "\n~~~ MY SALON ~~~\n"
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\nWelcome to My Salon, how can I help you?\n"
  echo "1) cut"
  echo "2) color"
  echo "3) perm"
  echo "4) style"
  echo "5) trim"
  echo "6) exit"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1|2|3|4|5) CREATE_APPOINTMENT $SERVICE_ID_SELECTED;;
    6) EXIT;;
    *) MAIN_MENU "I could not find that service.";
  esac
}
CREATE_APPOINTMENT() {
  SERVICE_ID=$1
  echo -e "\nWhat's your phone number?"
  read PHONE_NUMBER
  # Get customer info
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$PHONE_NUMBER'")
  # if doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # insert new customer
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME','$PHONE_NUMBER')")
  fi
  echo -e "\nWhat time?"
  read APPOINTMENT_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$PHONE_NUMBER'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $1, '$APPOINTMENT_TIME')")
  if [[ $? -eq 0 ]]
  then
    BOOKED_SERVICE=$($PSQL "select name from services where service_id = $1")
    MAIN_MENU "I have put you down for a $BOOKED_SERVICE at $APPOINTMENT_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')." 
  fi
}
EXIT() {
  echo -e "\nThanks for stopping by."
}
MAIN_MENU