FROM dart:stable

WORKDIR /app

COPY . .

RUN dart pub get

RUN dart pub global activate dart_frog_cli

RUN dart_frog build

EXPOSE 8080

CMD ["dart", "run", "build/bin/server.dart"]