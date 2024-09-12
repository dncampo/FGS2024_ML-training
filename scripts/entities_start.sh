#!/bin/bash





# Main execution
echo "Starting entity and subscription creation..."
# Execute subscription.sh script
./subscription.sh
./entities_dataset.sh
./entities_model.sh

echo "Entity and subscription creation completed."
