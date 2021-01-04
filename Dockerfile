FROM ubuntu:latest
 
 ENV DEBIAN_FRONTEND=noninteractiv
#::::::::::::::::::::::::::::::::::::::
#update
#::::::::::::::::::::::::::::::::::::::

RUN apt-get -y update && apt-get install -y \
sudo \
wget \
vim \
tzdata 

#::::::::::::::::::::::::::::::::::::::
RUN apt-get -qq -y install curl zip unzip
#::::::::::::::::::::::::::::::::::::::

#::::::::::::::::::::::::::::::::::::::
#install anaconda3
#::::::::::::::::::::::::::::::::::::::
WORKDIR /opt

#::::::::::::::::::::::::::::::::::::::
# download anaconda package and install anaconda
# archive -> https://repo.continuum.io/archive/
#::::::::::::::::::::::::::::::::::::::
RUN wget https://repo.continuum.io/archive/Anaconda3-2020.11-Linux-x86_64.sh && \
sh /opt/Anaconda3-2020.11-Linux-x86_64.sh -b -p /opt/anaconda3 && \
rm -f Anaconda3-2020.11-Linux-x86_64.sh
#::::::::::::::::::::::::::::::::::::::
# set path
#::::::::::::::::::::::::::::::::::::::
ENV PATH /opt/anaconda3/bin:$PATH
# ENV PATH CHROME_BIN=/usr/bin/google-chrome
# ENV PATH CHROME_DRIVER /usr/bin/chromedriver

#::::::::::::::::::::::::::::::::::::::
#chromeブラウザのインストール 
#::::::::::::::::::::::::::::::::::::::
RUN apt-get update && \
	apt-get install -y gnupg && \
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
	sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
	apt-get update && apt-get install -y google-chrome-stable firefox


#::::::::::::::::::::::::::::::::::::::
# chromeドライバのインストール 
#::::::::::::::::::::::::::::::::::::::
RUN curl -OL https://chromedriver.storage.googleapis.com/87.0.4280.88/chromedriver_linux64.zip \
&& unzip chromedriver_linux64.zip chromedriver \
&& mv chromedriver /usr/bin/chromedriver \
&& pip install "chromedriver_binary==87.0.4280.88"

#::::::::::::::::::::::::::::::::::::::
# Seleiumのインストール
#::::::::::::::::::::::::::::::::::::::
RUN pip install selenium

#::::::::::::::::::::::::::::::::::::::
# Juoyter-Dashのインストール
#::::::::::::::::::::::::::::::::::::::
RUN conda install -c conda-forge -c plotly jupyter-dash

#::::::::::::::::::::::::::::::::::::::
# SQLite3&SQLAlchemyのインストール
#::::::::::::::::::::::::::::::::::::::
RUN apt-get install sqlite3 libsqlite3-dev -y \
&& pip install SQLAlchemy

#::::::::::::::::::::::::::::::::::::::
# update pip and other
#::::::::::::::::::::::::::::::::::::::
RUN pip install --upgrade pip &&\
    curl -sL https://deb.nodesource.com/setup_10.x | bash - &&\
    apt install nodejs \
    && pip install autopep8 \
    && conda install -y -c conda-forge jupyter_contrib_nbextensions \
    && jupyter labextension install jupyterlab-theme-solarized-dark \
    && pip3 install jupyter-tabnine \
    && jupyter nbextension install --py jupyter_tabnine \
    && jupyter nbextension enable --py jupyter_tabnine \
    && jupyter serverextension enable --py jupyter_tabnine 

WORKDIR /

RUN mkdir /notebook

EXPOSE 8050
EXPOSE 8888
#::::::::::::::::::::::::::::::::::::::
# execute jupyterlab as a default command
#::::::::::::::::::::::::::::::::::::::
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]