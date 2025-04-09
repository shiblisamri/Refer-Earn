FROM php:8.1-apache

# Enable mod_rewrite
RUN a2enmod rewrite

# Install required extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Create necessary files with proper permissions
RUN touch users.json error.log && \
    chown www-data:www-data users.json error.log && \
    chmod 664 users.json error.log

# Apache configuration
COPY .htaccess .htaccess
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!/var/www/html/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf