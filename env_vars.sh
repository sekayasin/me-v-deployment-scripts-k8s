#!/usr/bin/env bash

DIRECTORY="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
ROOT_DIRECTORY=$(dirname $DIRECTORY)

BOLD='\e[1m'
BLUE='\e[34m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[92m'
NC='\e[0m'

init() {
    CREATED_FILES=()
    VARIABLES=()
}

info() {
    printf "\n${BOLD}${BLUE}====> $(echo $@ ) ${NC}\n"
}

warning () {
    printf "\n${BOLD}${YELLOW}====> $(echo $@ )  ${NC}\n"
}

error() {
    printf "\n${BOLD}${RED}====> $(echo $@ )  ${NC}\n"
    bash -c "exit 1"
}

success () {
    printf "\n${BOLD}${GREEN}====> $(echo $@ ) ${NC}\n"
}

# find template files
findTemplateFiles() {
    # determine the directory
    local new_dir=$([ "$2" != "" ] && echo $new_dir || echo $DIRECTORY )
    info "current directory is $new_dir"
    local _yamlFilesVariable=$1
    local _templates=$(find $new_dir -name "*.templ" -type f)
    if [ "$_yamlFilesVariable" ]; then
        # let variable parsed carry the array of templates
        eval $_yamlFilesVariable="'$_templates'"
    else
        echo $_templates;
    fi
}

# find variable and replace it within the file
findAndReplaceVariables() {
  for file in ${TEMPLATES[@]}; do
    local output=${file%.templ}
    local temp=""
    cp $file $output
    info "Building $(basename $file) template to $(basename $output)"
    for variable in ${VARIABLES[@]}; do
        local value=${!variable}
        sed -i -e "s|\$($variable)|$value|g" $output;
    done
    if [[ $? == 0 ]]; then
        success "Template file $(basename $file) has been successfuly built to $(basename $output)"
    else
        error "Failed to build template $(basename $file), variable $temp not found"
    fi
  done
  # info "Cleaning backup files after substitution" for mac
}

main(){
    local new_dir="$DIRECTORY"
    info "building $1 scripts"
    findTemplateFiles 'TEMPLATES' $new_dir
    findAndReplaceVariables
}

# set array of template variables
source variables.sh

main $@
