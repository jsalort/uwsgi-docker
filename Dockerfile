FROM jsalort/py38:latest

# Install locales and mysql
USER root
RUN apt install -y locales-all
# Change the MySQL password in daughter images
ENV MYSQL_PWD "initial_root_password"
RUN echo "mysql-server mysql-server/root_password password $MYSQL_PWD" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_PWD" | debconf-set-selections
RUN apt-get -y install mysql-server

# Install the Python dependencies
USER liveuser
RUN conda install -q -y -c conda-forge uwsgi bokeh arrow && \
    python -m pip install uwsgi-tools flask_moment pygeoip user_agents 
RUN cd /home/liveuser && git clone https://github.com/jsalort/pyorcid.git && \
    cd /home/liveuser/pyorcid && \
    python setup.py develop

# Define CMD to execute uwsgi
