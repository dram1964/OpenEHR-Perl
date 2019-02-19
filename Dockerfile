FROM perl

RUN apt update

RUN apt install -y apt-transport-https

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt update

RUN ACCEPT_EULA=Y apt install -y msodbcsql17 unixodbc-dev

RUN mkdir /app

WORKDIR /app

COPY cpanfile cpanfile

RUN cpanm --installdeps .

COPY . .

COPY odbc.ini /etc/odbc.ini
