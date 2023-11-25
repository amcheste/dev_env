#!/bin/sh

#
# Constants
FAILED=1
SUCCESS=1

echo "Setting up development environment, please stand by..."

#
# Create directory for git repos
if [[ ! -d ~/Repos ]]
then
    echo "~/Repos does not exist creating..."
    mkdir ~/Repos
    if  [[ $? -ne  0 ]];  then
        echo  "ERROR:  Failed to create directory ~/Repos"
        exit $FAILED
    fi
fi

#
# Install homebrew
echo "Checking for homebrew..."
which brew > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ $? -ne  0 ]]; then
        echo "ERROR: Failed to install homebrew"
        exit $FAILED
    fi
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/achester/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
	
fi

#
# Install Go for development
echo "Checking for go..."
brew list go > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing go..."
    brew install go
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install go"
        exit $FAILED
    fi
fi

#
# Install python for development
echo "Checking for python3..."
brew list python@3.10 > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing python3..."
    brew install python3
    if  [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install python3"
        exit $FAILED
    fi  
fi

#
# Install virtual env
echo "Checking for virtualenv..."
brew list virtualenv > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing virtualenv..."
    brew install virtualenv
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install virtualenv"
        exit $FAILED
    fi
fi

#
# Install openjdk for Java development
echo "Checking for opensdk..."
brew list openjdk > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing openjdk..."
    brew install openjdk
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install openjdk"
        exit $FAILED
    fi
fi

#
# Install maven for java packages
echo "Checking for maven..."
brew list maven > /dev/null
if [[ $? -ne 0 ]]; then 
    echo "Installing maven..."
    brew install maven
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install maven"
        exit $FAILED
    fi
fi

#
# Install kind for local k8s development
echo "Checking for kind..."
brew list kind > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing kind..."
    brew install kind
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install kind"
        exit $FAILED
    fi
fi

#
# Install kubectl
echo "Checking for kubectl..."
brew list kubernetes-cli > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing kubernetes-cli..."
    brew install kubernetes-cli
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install kubectl"
        exit $FAILED
    fi
fi

#
# Install octant to visulaize k8s deployments
echo "Checking for octant..."
brew list octant > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing octant..."
    brew install octant
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install octant"
        exit $FAILED
    fi
fi

#
# Install operator-sdk for k8s operator development
#echo "Checking for operator-sdk..."
#brew list operator-sdk > /dev/null
#if [[ $? -ne 0 ]]; then
#    echo "Installing operator-sdk..."
#    brew install operator-sdk
#    if [[ $? -ne 0 ]]; then
#        echo "ERROR: Failed to install operator-sdk"
#        exit $FAILED
#    fi
#fi

#
# Install oci cli
echo "Checking for oci-cli..."
brew list oci-cli > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing oci-cli..."
    brew install oci-cli
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install oci cli"
        exit $FAILED
    fi
fi

#
# Install doctl cli
#echo "Checking for digital ocean cli..."
#brew list doctl > /dev/null
#if [[ $? -ne 0 ]]; then
#    echo "Installing doctl..."
#    brew install doctl
#    if [[ $? -ne 0 ]]; then
#        echo "ERROR: Failed to install doctl"
#        exit $FAILED
#    fi
#fi

#
# Install jq for json parsing
echo "Checking for jq..."
brew list jq > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Installing jq..."
    brew install jq
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to install jq"
        exit $FAILED
    fi
fi

#
# Installing terraform
#echo "Checking for terraform..."
#brew list terraform > /dev/null
#if [[ $? -ne 0 ]]; then
#    echo "Installing terraform..."
#    brew install terraform
#    if [[ $? -ne 0 ]]; then
#        echo "ERROR: Failed to install terraform"
#        exit $FAILED
#    fi
#fi

#
# Install gator for gatekeeper development
#echo "Checking for gator..."
#brew list gator > /dev/null
#if [[ $? -ne 0 ]]; then
#    echo "Installing gator..."
#    brew install gator
#    if [[ $? -ne 0 ]];  then
#        echo "ERROR: Failed to install gator"
#        exit $FAILED
#    fi
#fi

echo "Environment has been setup!"

exit $SUCCESS
