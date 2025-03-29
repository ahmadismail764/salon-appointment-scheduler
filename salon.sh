#! /bin/bash
echo -e "\n~~~ MY SALON ~~~\n"
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
MAIN_MENU() {
  if [[ -z $1 ]]
  then
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi
  # Fetch services dynamically
  SERVICES=$($PSQL "select service_id, name from services order by service_id")
  # Display available services dynamically
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  # Read the user's selection
  read SERVICE_ID_SELECTED
  # Check if the selected service ID exists in the available services
  VALID_SERVICE=$(echo "$SERVICES" | grep -w "$SERVICE_ID_SELECTED")
  if [[ -n $VALID_SERVICE ]]; 
  then
    CREATE_APPOINTMENT $SERVICE_ID_SELECTED
  else
    MAIN_MENU "I could not find that service. What would you like today?"
  fi
}

CREATE_APPOINTMENT() {
  SERVICE_ID=$1
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # Get customer info
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  # if doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # insert new customer
    echo -e "\nI don't have a record for that phone number. What's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  echo -e "\nWhat time?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $1, '$SERVICE_TIME')")
  if [[ $? -eq 0 ]]
  then
    BOOKED_SERVICE=$($PSQL "select name from services where service_id = $1")
    echo "\nI have put you down for a $(echo $BOOKED_SERVICE | sed -E 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')." 
  fi
}
MAIN_MENU