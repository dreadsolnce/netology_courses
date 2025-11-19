#url
# https://github.com/terraform-linters/tflint

# Run for Docker
# docker run --rm -v $(pwd):/data -t ghcr.io/terraform-linters/tflint

#installed tflint for linux
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

#installed checkov fot linux
sudo apt install python3-pip
pip install checkov
