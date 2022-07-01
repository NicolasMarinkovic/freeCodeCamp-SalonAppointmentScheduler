#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c" #$($PSQL "<query_here>")

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
    if [[ $1 ]] 
        then
        echo -e "\n$1"
    fi

    SERVICES="$($PSQL "select * from services")"

    echo "$SERVICES" | while read SERVICE_ID BAR NAME
        do
            echo "$SERVICE_ID) $NAME"
        done
    echo "4) Exit"
    
    echo -e "\nPlease select the service you want to rent."   
    read SERVICE_ID_SELECTED
    case $SERVICE_ID_SELECTED in
    1) RENT_SALON ;;
    2) RENT_SALON ;;
    3) RENT_SALON ;;
    4) EXIT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
    esac
}

RENT_SALON() {
    # CUSTOMER TABLE
    #get customer info
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")   

    #if customer doesn't exist  (inserts a new one)
    if [[ -z $CUSTOMER_NAME ]]
    then
        #get new customer name
        echo -e "\nWhat's your name?"
        read CUSTOMER_NAME

        #insert new customer
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi
    #get Time
    echo -e "\nWhat time do you want to rent the service?"
    read SERVICE_TIME
    
    #get customer_id
    CUSTOMER_ID=$($PSQL "SELECT CUSTOMER_ID FROM CUSTOMERS WHERE PHONE='$CUSTOMER_PHONE'")
    #insert into appointment
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    if [[ $INSERT_APPOINTMENT == "INSERT 0 1" ]]
        then
        SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
        SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ //')
        echo "I have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."
    fi    
}

EXIT() {
    echo -e "\nThanks for passing by"
}

MAIN_MENU