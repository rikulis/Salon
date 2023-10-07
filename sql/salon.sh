#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Manly Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  #SERVICE_ID=$($PSQL "SELECT service_id FROM services ORDER BY service_id")
  #echo -e "\n1. Rent a bike\n2. Return a bike\n3. Exit"
  #read MAIN_MENU_SELECTION

   # get available bikes
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  # if no bikes available
  if [[ -z $AVAILABLE_SERVICES ]]
  then
    # send to main menu
    "Sorry, we don't have any service available right now."
  else
    # display available bikes
    echo -e "\nHere are the services we have available:"
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
  fi

  # ask for bike to rent
    echo -e "\nWhich one would you like to get?"
    read SERVICE_ID_SELECTED

    # if input is not a number
    if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]+$ ]]
    then
      # send to main menu
      MAIN_MENU "$AVAILABLE_SERVICES"
    else
        # get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME

   
          # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')") 
          fi
                 # Get time
          echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME"
          read SERVICE_TIME

          # get customer_id
          CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

          # Get right service
          SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")

          # insert appointment
          INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED,'$SERVICE_TIME')")
 
          # send to main menu
          echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
          exit
    fi
}
MAIN_MENU