# Update the recommend_outfit function to use a case statement
# Recommend an outfit based on the $weather argument
# Return the following strings based on the $weather argument:
#     sunny: "Wear light clothes, sunglasses, and don't forget sunscreen!"
#     rainy: "Bring an umbrella and wear a waterproof jacket and boots."
#     snowy: "Wear a warm coat, gloves, a scarf, and snow boots."
#     windy: "Wear layers and a windbreaker jacket."
#     cloudy: "Wear comfortable clothes and maybe bring a light jacket."
# If the $weather argument does not match any of the cases above, return:
#     "Sorry, I don't recognize that weather condition. Please try again."

#!/bin/bash

recommend_outfit() {
    local weather=$1

    case "$weather" in
        sunny)
            echo "Wear light clothes, sunglasses, and don't forget sunscreen!"
            ;;
        rainy)
            echo "Bring an umbrella and wear a waterproof jacket and boots."
            ;;
        snowy)
            echo "Wear a warm coat, gloves, a scarf, and snow boots."
            ;;
        windy)
            echo "Wear layers and a windbreaker jacket."
            ;;
        cloudy)
            echo "Wear comfortable clothes and maybe bring a light jacket."
            ;;
        *)
            echo "Sorry, I don't recognize that weather condition. Please try again."
            ;;
    esac
}

if [ $# -eq 0 ]; then
    echo "Please provide a weather condition as an argument."
    exit 1
fi

weather_input="$1"
recommend_outfit "$weather_input"
