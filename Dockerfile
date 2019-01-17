FROM perl

RUN mkdir /app

WORKDIR /app

COPY cpanfile cpanfile

RUN cpanm --installdeps .

COPY . .
