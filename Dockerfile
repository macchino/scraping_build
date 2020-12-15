FROM ubuntu:latest
 
# update
RUN apt-get -y update && apt-get install -y \
sudo \
wget \
vim
 
#install anaconda3
WORKDIR /opt
# download anaconda package and install anaconda
# archive -> https://repo.continuum.io/archive/
RUN wget https://repo.continuum.io/archive/Anaconda3-2020.11-Linux-x86_64.sh  \
&& sh /opt/Anaconda3-2020.11-Linux-x86_64.sh -b -p /opt/anaconda3 \
&& rm -f Anaconda3-2020.11-Linux-x86_64.sh
# set path
ENV PATH /opt/anaconda3/bin:$PATH
ENV CHROME_VER=2.44
ENV FIREFOX_VER=v0.23.0

# Chrome and Firefox browsers
RUN apt-get update && \
	apt-get install -y gnupg && \
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
	sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
	apt-get update && apt-get install -y google-chrome-stable firefox
# Chrome driver
#RUN CHROME_VER=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
RUN wget -q https://chromedriver.storage.googleapis.com/${CHROME_VER}/chromedriver_linux64.zip && \
	unzip -o chromedriver_linux64.zip && \
	rm chromedriver_linux64.zip && \
	mv chromedriver /opt/conda/bin

# Firefox driver
#RUN FIREFOX_VER=$(wget -qO- https://api.github.com/repos/mozilla/geckodriver/releases/latest | grep -Po '"tag_name": "\K.*?(?=")') && \
RUN wget -qO- https://github.com/mozilla/geckodriver/releases/download/${FIREFOX_VER}/geckodriver-${FIREFOX_VER}-linux64.tar.gz | tar -xvz -C /opt/conda/bin
# update pip and conda & 色変更 & kite
RUN pip install --upgrade pip \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install nodejs \
    && python -m pip install selenium \
    && install -y chromium-browser \
    && apt-get install chromium-chromedriver \
    && pip install pillow \
    && pip install autopep8 \
    && pip install jupyterlab_code_formatter \
    && jupyter labextension install @ryantam626/jupyterlab_code_formatter \
    && jupyter serverextension enable --py jupyterlab_code_formatter \
    && jupyter labextension install jupyterlab-theme-solarized-dark \
    && jupyter labextension install @lckr/jupyterlab_variableinspector
    
WORKDIR /

RUN mkdir /notebook

# execute jupyterlab as a default command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]