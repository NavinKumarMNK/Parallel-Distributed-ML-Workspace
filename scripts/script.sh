#!/bin/bash
cp temp5.txt ~/.bashrc
source ~/.bashrc
rm -rf ~/miniconda
rm miniconda.sh

if command -v conda >/dev/null 2>&1 ; then
    echo "Miniconda is already installed on this system."
else
    # Download the latest version of Miniconda for Linux
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

    # Install Miniconda
    bash ~/miniconda.sh -b -p $HOME/miniconda

    # Add Miniconda to PATH
    conda_dir="/home/windows/miniconda"

    # Create a backup of the existing bashrc file
    cp ~/.bashrc ~/.bashrc.backup

    # Append the conda initialization code to the bashrc file
    echo "# >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup=\"\$('$conda_dir/bin/conda' 'shell.bash' 'hook' 2> /dev/null)\"
    if [ \$? -eq 0 ]; then
        eval \"\$__conda_setup\"
    else
        if [ -f \"$conda_dir/etc/profile.d/conda.sh\" ]; then
            . \"$conda_dir/etc/profile.d/conda.sh\"
        else
            export PATH=\"$conda_dir/bin:\$PATH\"
        fi
    fi
    unset __conda_setup
# <<< conda initialize <<<
conda activate ray
export NCCL_SOCKET_IFNAME=enp3s0" >> ~/.bashrc

    # Source the updated bashrc file to apply the changes
    source ~/.bashrc

    echo "Miniconda has been installed."
fi
source ~/miniconda/bin/activate
# Define the environment name
env_name="ray"
# Check if the environment is already present in conda
if conda env list | grep -q $env_name; then
    echo "$env_name is already present in conda."
else
    conda create -y --name ray
    conda activate ray
    conda install -y python='3.10.8'
    pip install -U 'ray[default]'
    conda install -y pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia
    # Check if requirements.txt exists
    if [ ! -f requirements.txt ]; then
        echo "ERROR: requirements.txt file not found"
        exit 1
    fi

    # Install packages from requirements.txt
    echo "Installing packages from requirements.txt..."
    pip install -r requirements.txt

    # Check if installation was successful
    if [ $? -eq 0 ]; then
   	 echo "Packages successfully installed"
    else
        echo "ERROR: Package installation failed"
        exit 1
    fi
fi
#rm script.sh
#rm miniconda.sh
