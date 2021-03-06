FROM mcr.microsoft.com/dotnet/sdk:5.0 AS restore
WORKDIR /app

COPY DockerSample.csproj .
RUN ["dotnet", "restore"]

FROM restore AS build
COPY . /app
RUN ["dotnet", "build", "--no-restore", "--configuration", "Release"]

FROM build AS publish
RUN ["dotnet", "publish", "--no-restore", "--no-build", "--configuration", "Release", "--output", "artifacts"]

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app

COPY --from=publish /app/artifacts /app
ENTRYPOINT ["dotnet", "DockerSample.dll"]