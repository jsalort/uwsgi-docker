FROM jsalort/py38:latest

# Install locales and mysql
USER root
RUN apt install -y locales-all
# MYSQL password must be chosen at build time with --build-arg switch
ARG MYSQL_PWD
ENV MYSQL_PWD "$MYSQL_PWD"
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
