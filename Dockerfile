FROM microsoft/aspnetcore-build AS build-env
WORKDIR  /app

#copy project file, and restore
COPY *.csproj ./
RUN dotnet restore

EXPOSE 5000/tcp
ENV ASPNETCORE_URLS http://*:5000
ENV ASPNETCORE_ENVIRONMENT docker
#copy everything else and build
COPY . ./
RUN dotnet publish -c Release -r linux-arm -o out

#build runtime image
FROM microsoft/aspnetcore
WORKDIR /app
COPY --from=build-env /app/out ./
ENTRYPOINT [ "./mvcmovie" ]




