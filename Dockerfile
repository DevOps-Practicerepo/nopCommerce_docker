FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
COPY . /src
WORKDIR /src
RUN dotnet publish -c Release ./src/Presentation/Nop.Web/Nop.Web.csproj -o ./published/
RUN cd ./published/ && mkdir bin logs

FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS runtime
LABEL org="qtdevops" author="venkat"
ARG USERNAME=venkat
RUN adduser -D -h /Nop -s /bin/sh ${USERNAME}
COPY --from=build --chown=venkat:venkat /src/published /Nop
USER ${USERNAME}
WORKDIR /Nop
ENV ASPNETCORE_URLS="http://0.0.0.0:5000"
EXPOSE 5000
CMD [ "dotnet", "Nop.Web.dll"]