#!/bin/bash

# Function to determine the parameter file and resource group based on environment
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

    az deployment sub validate --name $uuid --location $location --template-file $template_file --parameters $parameterFile
    az deployment sub what-if --name $uuid  --location $location --template-file $template_file --parameters $parameterFile
}

# Main script starts here
template_file="./bicep/rg.bicep"
environment="$1"

validate_rg "$template_file" "$environment"
