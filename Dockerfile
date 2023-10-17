FROM swaggerapi/swagger-ui:v5.9.0

# copy APIs documentation (yaml)
COPY ./apis /usr/share/nginx/html/apis

# copy customizations
COPY ./custom/index.css /usr/share/nginx/html/index.css

# change index page title
RUN sed -i 's/>Swagger UI/>API Documentation/g' /usr/share/nginx/html/index.html