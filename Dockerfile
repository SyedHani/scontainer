FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Step 1: Use the official .NET 8 SDK image for the build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY *.csproj ./
RUN dotnet restore "scontainer.csproj"
COPY ..
WORKDIR "/src/scontainer"
RUN dotnet build "scontainer.csproj" -c Release -o /app/build

FROM build as publish
RUN dotnet publish "scontainer.csproj" -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","scontainer.dll"]