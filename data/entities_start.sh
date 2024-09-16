#!/bin/bash

# Main execution
echo "Starting entity and subscription creation..."
# Execute subscription.sh script
./entities_model.sh
./subscriptions.sh
./entities_dataset.sh


echo "Entity and subscription creation completed."
