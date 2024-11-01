#!/bin/bash

# Function to determine the parameter file based on environment
get_params() {
    local env=$1
    case $env in
        dev)
            parameterFile="./bicep/rg_parameters_dev.json"
            ;;
        test)
            parameterFile="./bicep/rg_parameters_test.json"
            ;;
        prod)
            parameterFile="./bicep/rg_parameters_prod.json"
            ;;
        *)
            echo "Invalid environment specified"
            exit 1
            ;;
    esac
}

# Function to deploy using Azure CLI
validate_rg() {
    local template_file="$1"
    local uuid="$(cat /proc/sys/kernel/random/uuid)"
    local location="centralus"
    local environment="$2"

    get_params "$environment"

    # Perform validation and what-if analysis
    az deployment sub validate --name "$uuid" --location "$location" --template-file "$template_file" --parameters "$parameterFile" || {
        echo "Validation failed"
        exit 1
    }
    az deployment sub what-if --name "$uuid" --location "$location" --template-file "$template_file" --parameters "$parameterFile" || {
        echo "What-if analysis failed"
        exit 1
    }
}

# Main script starts here
template_file="./bicep/rg.bicep"
environment="$1"

# Check if environment argument is provided
if [[ -z "$environment" ]]; then
    echo "Usage: $0 <environment>"
    echo "Environment options: dev, test, prod"
    exit 1
fi

validate_rg "$template_file" "$environment"
