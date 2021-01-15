FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ghcstest.csproj", "./"]
RUN dotnet restore "ghcstest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ghcstest.csproj" -c Debug -o /app/build

FROM build AS publish
RUN dotnet publish "ghcstest.csproj" -c Debug -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ghcstest.dll"]
