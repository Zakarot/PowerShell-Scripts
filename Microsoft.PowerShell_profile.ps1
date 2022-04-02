function update (){
    Start-Process powershell Update-Help -Verb runAs -WindowStyle Hidden
    bash -c "\
        sudo apt update && \
        sudo apt upgrade -y && \
        sudo apt autoremove -y \
        "
}

function setup (){
    bash -c "\
        echo 'zadmin  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/zadmin && \
        touch /home/zadmin/.hushlogin && \
    "
}

function nano ($File){
    $File = $File -replace "\\", "/" -replace " ", "\ "
    bash -c "nano $File"
}

