# Use debugging techniques to resolve the three issues in the following script
# Call the function with the argument that ensures the final output is "Reptile"

#!/bin/bash

categorize_animals() {
    case $1 in
        dog|cat|lion)
            echo "Mammal"
            ;;
        eagle|penguin|sparrow)
            echo "Bird"
            ;;
        snake|lizards|turtle)
            echo "Reptile"
            ;;
        *)
            echo "Unknown animal class"
            ;;
    esac
}

categorize_animal

exit 0